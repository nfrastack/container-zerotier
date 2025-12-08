## 1.2.0pre 2025-09-04 <code at nfrastack dot com>

   ### Changed
     - Switch to nfrastack/container-nginx as base image
     - ZeroTier 1.16.0
     - ZT Net 0.7.12

   ### Removed
     - DNS and Client Mode

## 1.1.99 2025-09-04 <dave at tiredofit dot ca>

Add EOL Notice and deprecate image


## 1.1.12 2025-08-17 <dave at tiredofit dot ca>

   ### Added
      - ZT Net 0.7.7


## 1.1.11 2025-08-03 <dave at tiredofit dot ca>

   ### Added
      - ZTNet 0.7.6


## 1.1.10 2025-06-23 <dave at tiredofit dot ca>

   ### Added
      - Add fallthrough support to CoreDNS ZTNET Companion


## 1.1.9 2025-06-23 <dave at tiredofit dot ca>

   ### Added
      - CoreDNS 1.12.2


## 1.1.8 2025-06-23 <dave at tiredofit dot ca>

   ### Changed
      - And another check


## 1.1.7 2025-06-23 <dave at tiredofit dot ca>

   ### Added
      - Add additional performance check for dns log file to solve logrotate issues


## 1.1.6 2025-06-05 <dave at tiredofit dot ca>

   ### Added
      - Add log rotation for MODE=DNS


## 1.1.5 2025-06-05 <dave at tiredofit dot ca>

   ### Changed
      - Fix Client Configuration JSON generation


## 1.1.4 2025-06-05 <dave at tiredofit dot ca>

   ### Changed
      - Update go modules to resolve build issue of ZTnet Mkworld


## 1.1.3 2025-06-05 <dave at tiredofit dot ca>

   ### Added
      - ZT-Net 0.7.5

   ### Changed
      - Change zerotier uid/gid from 2323 to 9376
      - Fix issue with MODE=CLIENT


## 1.1.2 2025-05-23 <dave at tiredofit dot ca>

   ### Added
      - ZTNet 0.7.4


## 1.1.1 2025-04-08 <dave at tiredofit dot ca>

   ### Added
      - DNS: Add Zone File Output options
      - DNS: Add Custom Zones file entries
      - DNS: Add Custom Zones Environment variables


## 1.1.0 2025-04-08 <dave at tiredofit dot ca>

Paths have changed again - take notice!

   ### Added
      - Add new MODE - CLIENT - Cannot run CONTROLLER and CLIENT at same time - See README for Environment variables
      - DNS Mode - Allow Zone Transfers via AXFR
      - DNS Mode - Add support to include custom CoreDNS Configuration (COREDNS_INCLUDE_CONFIG)
      - DNS Mode - Add support to include custom Hosts entries (COREDNS_INCLUDE_HOSTS)
      - DNS Mode - Add support to add environment variable to add custom host entry (DNS_CUSTOM_HOST01-99)
      - DNS Mode - Debugging

   ### Changed
      - Changed Controller path to /data/controller/


## 1.0.2 2025-04-03 <dave at tiredofit dot ca>

   ### Added
      - Add some safety nets for DNS mode checking if API is live before proceeding
      - Add warning with UI_SECRET not set
      - Minor cleanup


## 1.0.1 2025-04-02 <dave at tiredofit dot ca>

   ### Changed
      - Bugfixes to 1.0.0 release to ztnet-dns-companion script
      - Add more utils to perform better hosts file mapping


## 1.0.0 2025-04-02 <dave at tiredofit dot ca>

Take note a breaking change paths. Move your zerotier data from /data to /data/zerotier or lose all network information

   ### Added
      - Introduce new DNS MODE to serve DNS records from ZTNet API. Runs a locally installed CoreDNS server that can be accessed on interfaces or port mapped and resolve hostnames that are entered into the ZTNET Gui from whatever networks have been defined
      - Introdued log rotation and optimizations to container runtime

   ### Changed
      - New MODE - DNS
      - Changed data path from /data to /data/zerotier - make sure you move all preexisting data into this folder, otherwise lose your networks and connectivity.


## 0.47.0 2025-02-21 <dave at tiredofit dot ca>

   ### Added
      - ZT-Net 0.73.0


## 0.46.0 2024-12-16 <dave at tiredofit dot ca>

   ### Added
      - ZTNet 0.7.2


## 0.44.1 2024-12-07 <dave at tiredofit dot ca>

   ### Added
      - Pin to tiredofit/nginx:alpine-3.21


## 0.44.0 2024-11-21 <dave at tiredofit dot ca>

   ### Added
      - ZTNet 0.7.1


## 0.43.1 2024-10-29 <dave at tiredofit dot ca>

   ### Added
      - Zerotier 1.14.2


## 0.43.0 2024-09-12 <dave at tiredofit dot ca>

   ### Added
      - ZerotierOne 1.14.1


## 0.39.3 2024-09-02 <dave at tiredofit dot ca>

   ### Added
      - ZTNet 0.7.0


## 0.39.2 2024-08-21 <dave at tiredofit dot ca>

   ### Added
      - ZT-Net 0.6.10


## 0.39.1 2024-08-09 <dave at tiredofit dot ca>

   ### Added
      - ZT-Net 0.6.9


## 0.39.0 2024-08-08 <dave at tiredofit dot ca>

   ### Added
      - ZT-Net 0.6.8


## 0.38.0 2024-07-12 <dave at tiredofit dot ca>

   ### Changed
      - Update ZTNET version


## 0.37.0 2024-07-12 <dave at tiredofit dot ca>

   ### Added
      - ZT-Net 0.6.7


## 0.36.0 2024-06-04 <dave at tiredofit dot ca>

   ### Added
      - ZTNet 0.6.6


## 0.35.0 2024-05-22 <dave at tiredofit dot ca>

   ### Added
      - ZTNet 0.6.5


## 0.34.0 2024-05-17 <dave at tiredofit dot ca>

   ### Added
      - Zerotier 1.14.0
      - ZTNet 0.6.4


## 0.33.0 2024-04-14 <dave at tiredofit dot ca>

   ### Added
      - ZTNet 0.6.2


## 0.29.3 2024-04-07 <dave at tiredofit dot ca>

   ### Added
      - ZTNet 0.6.1


## 0.29.2 2024-03-02 <dave at tiredofit dot ca>

   ### Added
      - ZT Net 0.5.11


## 0.29.1 2024-03-02 <dave at tiredofit dot ca>

   ### Added
      - Zerotier 0.5.11


## 0.29.0 2024-02-08 <dave at tiredofit dot ca>

   ### Added
      - ZTNet 0.5.10


## 0.28.0 2024-01-13 <dave at tiredofit dot ca>

   ### Added
      - ZTNet 0.5.9


## 0.27.1 2024-01-07 <dave at tiredofit dot ca>

   ### Added
      - ZTNet 0.5.8


## 0.27.0 2023-12-29 <dave at tiredofit dot ca>

   ### Added
      - ZTNet 0.5.7


## 0.26.0 2023-12-25 <dave at tiredofit dot ca>

   ### Added
      - ZTNet 0.5.6


## 0.25.0 2023-12-19 <dave at tiredofit dot ca>

   ### Added
      - ZTNET 0.5.5


## 0.24.0 2023-12-13 <dave at tiredofit dot ca>

   ### Added
      - Alpine 3.19 base
      - ZTNET 0.5.4


