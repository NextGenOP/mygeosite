# █▀▀█ █▀▀█ █▀▀ █▀▀ █▀▀▄ 　 ▀▀█▀▀ █▀▀█ 　 █▀▀▄ █▀▀█ █▀▀▄ █▀▀ █▀▀ █▀▀█ 
# █▄▄█ █▄▄▀ ▀▀█ █▀▀ █░░█ 　 ░░█░░ █▄▄█ 　 █░░█ █▄▄█ █░░█ █▀▀ ▀▀█ █▄▄▀ 
# ▀░░▀ ▀░▀▀ ▀▀▀ ▀▀▀ ▀░░▀ 　 ░░▀░░ ▀░░▀ 　 ▀▀▀░ ▀░░▀ ▀▀▀░ ▀▀▀ ▀▀▀ ▀░▀▀ 
# 
# ╔══════════════════════════════════════════════════════════════════╗
# ║                 ENHANCED V2RAY GEOLOCATION RULES                 ║
# ║                    mygeosite                        ║
# ╚══════════════════════════════════════════════════════════════════╝

> 🔥 Advanced routing rules that replace official V2Ray `geoip.dat` & `geosite.dat` 🔥  
> 🌐 Compatible with Xray-core, Trojan-Go, Shadowsocks & Leaf clients  
> 📅 Updated weekly via GitHub Actions on Sundays

```
This Geosite will eat up your memory
```

---

## 🎯 **PROJECT OVERVIEW**

**Geosite Project** provides enhanced routing rules that significantly improve upon the official V2Ray geolocation datasets. Our custom-built `geoip.dat` and `geosite.dat` files offer comprehensive IP and domain filtering capabilities with expanded categories and weekly updates.

### 🤖 **COMPATIBILITY**
- ✅ V2Ray Core / V2Fly
- ✅ Xray Core 
- ✅ Trojan-Go
- ✅ Leaf
- ✅ Shadowsocks-Windows

---

## 📦 **FILE STRUCTURE & CONTENT**

### 📍 **geoip.dat** - Enhanced IP Address Ranges
Built using the [@Loyalsoldier/geoip](https://github.com/Loyalsoldier/geoip) generator with data from:
- **Global IPs:** MaxMind GeoLite2 (IPv4 & IPv6)
- **China IPs:** IPIP.NET
- **Enhanced Categories:**
  ```
  geoip:cloudflare    geoip:facebook    geoip:google
  geoip:netflix       geoip:telegram    geoip:twitter
  geoip:cloudfront    geoip:fastly
  ```

### 🌐 **geosite.dat** - Comprehensive Domain Lists
Aggregated from multiple authoritative sources:
- **Base Data:** V2Fly Community Domain List
- **China Domains:** Felixonmars DNSMasq China List
- **GFW Lists:** GFWList + Greatfire Analyzer
- **Ad Blocking:** EasyList, AdGuard, Peter Lowe, Dan Pollock
- **System Filtering:** WindowsSpyBlocker components
- **Specialized Categories:** Over 40 specialized filters including gaming, streaming, social media, NSFW, malware protection, and regional optimizations

---

## 📥 **DOWNLOAD & SETUP**

### 🔗 **Download Links** *(Choose One)*
| File | Direct GitHub | CDN (12h Delay) |
|------|---------------|-----------------|
| **geoip.dat** | [Download](https://github.com/NextGenOP/mygeosite/releases/latest/download/geoip.dat) | [CDN Mirror](https://cdn.jsdelivr.net/gh/NextGenOP/mygeosite@release/geoip.dat) |
| **geosite.dat** | [Download](https://github.com/NextGenOP/mygeosite/releases/latest/download/geosite.dat) | [CDN Mirror](https://cdn.jsdelivr.net/gh/NextGenOP/mygeosite@release/geosite.dat) |

### 🛠️ **Installation Steps**
1. **Install** your preferred V2Ray client
2. **Download** both `geoip.dat` and `geosite.dat`
3. **Place** files in your client's configuration directory
4. **Replace** existing rule files
5. **Configure** using the examples below

---

## ⚙️ **CONFIGURATION EXAMPLES**

### 📍 **GeoIP Routing Example**
```json
{
  "routing": {
    "rules": [
      {
        "type": "field",
        "outboundTag": "Direct",
        "ip": [
          "223.5.5.5/32",
          "119.29.29.29/32", 
          "geoip:cn",
          "geoip:private"
        ]
      },
      {
        "type": "field",
        "outboundTag": "Proxy",
        "ip": [
          "1.1.1.1/32",
          "8.8.8.8/32",
          "geoip:us",
          "geoip:telegram"
        ]
      }
    ]
  }
}
```

### 🌐 **GeoSite Advanced Configuration**
#### **Whitelist Mode:**
```json
{
  "routing": {
    "rules": [
      {
        "type": "field",
        "outboundTag": "Reject",
        "domain": ["geosite:category-ads-all"]
      },
      {
        "type": "field",
        "outboundTag": "Direct",
        "domain": [
          "geosite:private",
          "geosite:apple-cn",
          "geosite:google-cn",
          "geosite:tld-cn"
        ]
      },
      {
        "type": "field",
        "outboundTag": "Proxy",
        "domain": ["geosite:geolocation-!cn"]
      },
      {
        "type": "field",
        "outboundTag": "Direct",
        "domain": ["geosite:cn"]
      }
    ]
  }
}
```

#### **Blacklist Mode:**
```json
{
  "routing": {
    "rules": [
      {
        "type": "field",
        "outboundTag": "Reject",
        "domain": ["geosite:category-ads-all"]
      },
      {
        "type": "field",
        "outboundTag": "Proxy",
        "domain": ["geosite:gfw", "geosite:greatfire"]
      },
      {
        "type": "field",
        "outboundTag": "Proxy",
        "ip": ["geoip:telegram"]
      },
      {
        "type": "field",
        "outboundTag": "Direct",
        "network": "tcp,udp"
      }
    ]
  }
}
```

---

## 🧩 **SPECIALIZED CATEGORIES**

### 🔥 **Exclusive Categories** *(Not Available in Official Datasets)*
- `geosite:apple-cn` - China-based Apple services
- `geosite:google-cn` - China-based Google services  
- `geosite:win-spy` - Windows telemetry/spyware domains
- `geosite:win-update` - Windows update domains
- `geosite:win-extra` - Additional Windows tracking domains
- `geosite:category-ads-all` - Comprehensive ad blocking
- `geosite:category-games@cn` - China-accessible game domains
- `geosite:gfw` - Great Firewall list domains
- `geosite:greatfire` - Greatfire analyzer blocked domains
- `geosite:oisd-full` - OISD comprehensive blocking list
- `geosite:oisd-nsfw` - OISD NSFW content blocking
- `geosite:steven-black` - Steven Black unified hosts list
- `geosite:adult` - Adult/NSFW content domains
- `geosite:adblock` - Combined ad-blocking list
- `geosite:prevent-bypass` - Parental control bypass prevention
- `geosite:rule-ads` - Advertisement domains
- `geosite:rule-gaming` - Gaming services domains
- `geosite:rule-indo` - Indonesian content domains
- `geosite:rule-playstore` - Google Play Store related domains
- `geosite:rule-sosmed` - Social media domains
- `geosite:rule-streaming` - Streaming services domains
- `geosite:rule-umum` - General purpose domains
- `geosite:rule-ipcheck` - IP check/verification services
- `geosite:rule-doh` - DNS over HTTPS domains
- `geosite:videoconference` - Video conferencing platforms
- `geosite:hagezi-normal` - Hagezi multi-category DNS blocklist
- `geosite:rule-bank-id` - Indonesian banking domains
- `geosite:rule-speedtest` - Speed test service domains
- `geosite:urltest` - URL testing services
- `geosite:tiuxo-nsfw` - NSFW domains from Tiuxo
- `geosite:mx-nsfw` - NSFW domains from mhxion/PornAway
- `geosite:sinfonietta-nsfw` - NSFW domains from Sinfonietta
- `geosite:abpid-adult` - Indonesian adult content domains
- `geosite:rule-malicious` - Malicious host domains
- `geosite:hblock` - hBlock malware/phishing protection

### 📊 **Advanced Attribute Support**
Categories with `@cn` attributes for regional optimization:
- `geosite:category-games@cn` - Games accessible in China
- `geosite:steam@cn` - Steam services in China
- `geosite:google@cn` - Google services in China

---

## 🚀 **ADVANCED USAGE PATTERNS**

### 🎮 **Gaming Optimization**
For gamers who want local access to regional game services:
```
geosite:category-games@cn    → Direct (No Proxy)
geosite:steam@cn             → Direct (No Proxy)
geosite:rule-gaming          → Direct or Proxy (depending on region)
```

### 🛡️ **Privacy Protection**
For maximum privacy control:
```
geosite:category-ads-all     → Reject (Block)
geosite:win-spy              → Reject (Block)
geosite:win-update           → Reject (Block)
geosite:adblock              → Reject (Block ads/malware)
geosite:oisd-full            → Reject (Comprehensive protection)
geosite:steven-black         → Reject (Unified blocking)
geosite:hblock               → Reject (Malware/phishing)
```

### 📱 **Mobile App Routing**
Optimize app traffic patterns:
```
geosite:google               → Proxy (External Access)
geosite:apple-cn             → Direct (Local Access)
geosite:category-ads-all     → Reject (Block Ads)
geosite:rule-playstore       → Direct (Local Play Store)
geosite:rule-sosmed          → Proxy (Social Media)
geosite:rule-streaming       → Proxy (Streaming Services)
```

### 🎥 **Media Streaming Optimization**
For streaming services with regional restrictions:
```
geosite:rule-streaming       → Proxy (International Streams)
geosite:rule-playstore       → Direct (Regional Apps)
geosite:gfw                  → Proxy (Blocked Content)
geosite:greatfire            → Proxy (Censored Sites)
```

### 🔞 **Content Control**
For parental controls and content filtering:
```
geosite:adult                → Reject (Adult Content)
geosite:oisd-nsfw            → Reject (NSFW Sites)
geosite:tiuxo-nsfw           → Reject (NSFW Sites)
geosite:mx-nsfw              → Reject (NSFW Sites)
geosite:sinfonietta-nsfw     → Reject (NSFW Sites)
geosite:prevent-bypass       → Reject (Bypass Prevention)
```

### 💰 **Financial Services**
For banking and financial services:
```
geosite:rule-bank-id         → Direct (Indonesian Banks)
```

### 📶 **Performance Testing**
For network performance evaluation:
```
geosite:rule-speedtest       → Direct (Speed Tests)
geosite:rule-ipcheck         → Direct (IP Checkers)
geosite:urltest              → Direct (URL Testing)
```

### 📹 **Video Conferencing**
For communication services:
```
geosite:videoconference      → Proxy (Global Access)
```

---

## 💡 **TIPS & BEST PRACTICES**

### ⚠️ **Priority Rules**
Remember: **Higher priority categories come first in routing rules**
```
geosite:apple-cn     ← Higher Priority
geosite:google-cn    ← Higher Priority  
geosite:geolocation-!cn    ← Lower Priority
```

### 🔧 **DNS Integration**
Example DNS configuration for optimal performance:
```json
{
  "dns": {
    "hosts": {
      "dns.google": "8.8.8.8",
      "dns.pub": "119.29.29.29",
      "geosite:category-ads-all": "127.0.0.1"
    },
    "servers": [
      {
        "address": "https://1.1.1.1/dns-query",
        "domains": ["geosite:geolocation-!cn"],
        "expectIPs": ["geoip:!cn"]
      }
    ]
  }
}
```

---

## 🙏 **ACKNOWLEDGMENTS**

### 🏗️ **Data Sources**
This project aggregates data from multiple open-source initiatives:

**Direct Route Sources (China-related):**
- [felixonmars/dnsmasq-china-list/accelerated](https://github.com/felixonmars/dnsmasq-china-list) - China domain acceleration list
- [Loyalsoldier/domain-list-custom/cn](https://github.com/Loyalsoldier/domain-list-custom) - Custom China domains

**Proxy Route Sources (Non-China):**
- [cokebar/gfwlist2dnsmasq](https://github.com/cokebar/gfwlist2dnsmasq) - GFW domain list
- [Loyalsoldier/cn-blocked-domain](https://github.com/Loyalsoldier/cn-blocked-domain) - Greatfire Analyzer blocked domains
- [felixonmars/dnsmasq-china-list/google.china](https://github.com/felixonmars/dnsmasq-china-list) - China-based Google domains
- [felixonmars/dnsmasq-china-list/apple.china](https://github.com/felixonmars/dnsmasq-china-list) - China-based Apple domains
- [Loyalsoldier/domain-list-custom/geolocation-!cn](https://github.com/Loyalsoldier/domain-list-custom) - Non-China domains

**Blocking Sources (Ads/Malware/Tracking):**
- [hmirror.molinero.dev/easylist](https://hmirror.molinero.dev/easylist/list.txt) - Global ad blocking rules
- [adblockplus/EasylistChina+Easylist](https://easylist-downloads.adblockplus.org/easylistchina+easylist.txt) - China+global ad blocking
- [PeterLowe/adservers](https://pgl.yoyo.org/adservers/serverlist.php) - Ad server blocking list
- [AdGuardTeam/AdGuardSDNSFilter](https://github.com/AdGuardTeam/AdGuardSDNSFilter) - DNS filtering rules
- [DanPollock/someonewhocares](https://someonewhocares.org/hosts/hosts) - Hosts-based ad blocking

**Additional Category Sources:**
- [hblock.molinero.dev](https://hblock.molinero.dev/hosts_domains.txt) - Malware/phishing protection
- [crazy-max/WindowsSpyBlocker](https://github.com/crazy-max/WindowsSpyBlocker) - Windows telemetry blocking
- [OISD.nl](https://hosts.oisd.nl/) - Comprehensive blocking lists (normal and NSFW)
- [StevenBlack/hosts](https://github.com/StevenBlack/hosts) - Unified hosts file
- [Tiuxo/hosts/porn](https://github.com/tiuxo/hosts) - NSFW content blocking
- [mhxion/pornaway](https://github.com/mhxion/pornaway) - Pornography site blocking
- [Sinfonietta/hostfiles](https://github.com/Sinfonietta/hostfiles) - NSFW host files
- [ABPindo/indonesianadblockrules](https://github.com/ABPindo/indonesianadblockrules) - Indonesian ad blocking
- [dibdot/DoH-IP-blocklists](https://github.com/dibdot/DoH-IP-blocklists) - DNS-over-HTTPS IP blocklists
- [NextDNS/metadata](https://github.com/nextdns/metadata) - Parental control bypass methods
- [malikshi/v2ray-rules-dat](https://github.com/malikshi/v2ray-rules-dat) - Gaming, streaming, and social media rules
- [elliotwutingfeng/Inversion-DNSBL-Blocklists](https://github.com/elliotwutingfeng/Inversion-DNSBL-Blocklists) - Malicious host blocking
- [Hagezi/dns-blocklists](https://gitlab.com/hagezi/mirror) - Multi-category DNS blocklists

### 🔄 **Build Process**
Automated weekly builds powered by GitHub Actions ensure fresh, accurate data.

---

## 📈 **PROJECT METRICS**

[![Build Status](https://github.com/NextGenOP/mygosite/actions/workflows/run.yml/badge.svg?branch=master&event=workflow_run)](https://github.com/NextGenOP/mygeosite/actions/workflows/run.yml)

---

## ©️ **LICENSE & DISCLAIMER**

> This project is built for educational and personal use purposes.  
> Use responsibly and comply with local laws and regulations.  
> No guarantees provided - use at your own risk.

```

*Made with 💻 for the V2Ray community*  
*Enhanced weekly since 2023*
