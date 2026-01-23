#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="${SCRIPT_DIR}/../config"

load_config() {
	if command -v jq &>/dev/null; then
		jq -r "$1" "${CONFIG_DIR}/sources.json"
	else
		echo "ERROR: jq is required but not installed" >&2
		exit 1
	fi
}

curl_download() {
	local url="$1"
	local output="$2"
	local retries=3
	local delay=2

	for i in $(seq 1 "$retries"); do
		if curl -sSL --fail --connect-timeout 30 --max-time 300 "$url" -o "$output" 2>/dev/null; then
			return 0
		fi
		echo "Download failed (attempt $i/$retries), retrying in ${delay}s..." >&2
		sleep "$delay"
	done

	echo "ERROR: Failed to download $url after $retries attempts" >&2
	return 1
}

wget_download() {
	local url="$1"
	local output="$2"
	local retries=3
	local delay=2

	for i in $(seq 1 "$retries"); do
		if wget -q --timeout=300 "$url" -O "$output" 2>/dev/null; then
			return 0
		fi
		echo "Download failed (attempt $i/$retries), retrying in ${delay}s..." >&2
		sleep "$delay"
	done

	echo "ERROR: Failed to download $url after $retries attempts" >&2
	return 1
}

extract_dnsmasq_domains() {
	local input="$1"
	local output="$2"

	perl -ne '/^server=\/([^\/]+)\// && print "$1\n"' "$input" >>"$output"
}

extract_dnsmasq_full_domains() {
	local input="$1"
	local output="$2"

	perl -ne '/^server=\/([^\/]+)\// && print "full:$1\n"' "$input" >>"$output"
}

extract_hosts_domains() {
	local input="$1"
	local output="$2"
	local pattern="${3:-"0.0.0.0\\|127.0.0.1"}"

	grep -E "$pattern" "$input" | awk '{print $2}' >>"$output"
}

extract_abp_domains() {
	local input="$1"
	local output="$2"

	perl -ne '/^\|\|([-_0-9a-zA-Z]+(\.[-_0-9a-zA-Z]+){1,64})\^$/ && print "$1\n"' "$input" |
		perl -ne 'print if not /^[0-9]{1,3}(\.[0-9]{1,3}){3}$/' >>"$output"
}


extract_domain_list_custom() {
	local input="$1"
	local output="$2"
	local exclude_cn="${3:-false}"

	if [ "$exclude_cn" = "true" ]; then
		grep -Ev ":@cn" "$input" | perl -ne '/^(domain):([^:]+)(\n$|:@.+)/ && print "$2\n"' >>"$output"
	else
		perl -ne '/^(domain):([^:]+)(\n$|:@.+)/ && print "$2\n"' "$input" >>"$output"
	fi
}

extract_wildcard_domains() {
	local input="$1"
	local output="$2"

	sed 's/^\*\\.//g' >>"$output"
}

extract_plain_domains() {
	local input="$1"
	local output="$2"

	cat "$input" >> "$output"
}

extract_domain_list_custom_reserved() {
	local input="$1"
	local output="$2"
	local exclude_cn="${3:-false}"

	if [ "$exclude_cn" = "true" ]; then
		grep -Ev ":@cn" "$input" | perl -ne '/^((full|regexp|keyword):[^:]+)(\n$|:@.+)/ && print "$1\n"' | sort --ignore-case -u >>"$output"
	else
		perl -ne '/^((full|regexp|keyword):[^:]+)(\n$|:@.+)/ && print "$1\n"' "$input" | sort --ignore-case -u >>"$output"
	fi
}

validate_domain() {
	local domain="$1"

	perl -ne '/^((?=^.{1,255})[a-zA-Z0-9][-_a-zA-Z0-9]{0,62}(\.[a-zA-Z0-9][-_a-zA-Z0-9]{0,62})*)/ && print "$1\n"' <<<"$domain"
}

filter_valid_domains() {
	local input="$1"
	local output="$2"

	perl -ne '/^((?=^.{1,255})[a-zA-Z0-9][-_a-zA-Z0-9]{0,62}(\.[a-zA-Z0-9][-_a-zA-Z0-9]{0,62})*)/ && print "$1\n}' "$input" >>"$output"
}

filter_valid_fqdn() {
	local input="$1"
	local output="$2"

	perl -ne '/^((?=^.{3,255})[a-zA-Z0-9][-_a-zA-Z0-9]{0,62}(\.[a-zA-Z0-9][-_a-zA-Z0-9]{0,62})+)/ && print "$1\n"' "$input" >>"$output"
}

filter_not_ip() {
	local input="$1"
	local output="$2"

	perl -ne 'print if not /^[0-9]{1,3}(\.[0-9]{1,3}){3}$/' "$input" >>"$output"
}

filter_not_cn_tld() {
	local input="$1"
	local output="$2"

	perl -ne 'print if not /\.cn$/' "$input" >>"$output"
}

sort_unique() {
	local input="$1"
	local output="$2"

	sort --ignore-case -u "$input" -o "$output"
}

merge_files() {
	local output="$1"
	shift
	local files=("$@")

	for file in "${files[@]}"; do
		if [ -f "$file" ]; then
			cat "$file" >>"$output"
		fi
	done
}

count_lines() {
	local file="$1"

	if [ -f "$file" ]; then
		wc -l <"$file"
	else
		echo "0"
	fi
}

setup_gfwlist() {
	local gfwlist_dir="$1"
	local output_file="$2"

	cd "$gfwlist_dir" || return 1
	chmod +x ./gfwlist2dnsmasq.sh
	./gfwlist2dnsmasq.sh -l -o "$output_file"
	cd - >/dev/null
}

jsdelivr_purge() {
	local repo="$1"
	local branch="${2:-release}"
	local files=("$@")
	local base_url="https://purge.jsdelivr.net/gh/${repo}@${branch}/"

	for file in "${files[@]:2}"; do
		echo "Purging: ${base_url}${file}"
		curl -sSL -X PURGE "${base_url}${file}" >/dev/null || true
	done
}

git_init_and_push() {
	local dir="$1"
	local message="$2"
	local branch="${3:-release}"
	local repo_url="$4"

	cd "$dir" || return 1

	if [ ! -d ".git" ]; then
		git init
		git config --local user.name "github-actions[bot]"
		git config --local user.email "41898282+github-actions[bot]@users.noreply.github.com"
	fi

	git checkout -b "$branch" 2>/dev/null || git checkout "$branch"
	git add .
	git commit -m "$message" || true
	git remote add origin "$repo_url"
	git push -f -u origin "$branch"

	cd - >/dev/null
}

install_to_publish() {
	local source="$1"
	local dest_dir="$2"
	local filename="${3:-$(basename "$source")}"

	install -Dp "$source" "${dest_dir}/${filename}"
}

install_list_files() {
	local pattern="$1"
	local dest_dir="$2"

	for file in $pattern; do
		if [ -f "$file" ]; then
			install -Dp "$file" "${dest_dir}/$(basename "$file")"
		fi
	done
}

zip_publish_files() {
	local dir="$1"
	local files=("$@")

	cd "$dir" || return 1
	zip rules.zip "${files[@]:1}"
	cd - >/dev/null
}

generate_sha256() {
	local file="$1"
	local output="${2:-${file}.sha256sum}"

	sha256sum "$file" >"$output"
}
