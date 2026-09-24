# Riferimenti e fonti

## Escape del container (tappa 2)
- CVE-2019-5736 - container breakout in runc.
  - NVD: https://nvd.nist.gov/vuln/detail/CVE-2019-5736
  - Advisory (Openwall): https://www.openwall.com/lists/oss-security/2019/02/11/2
- Docker - Docker daemon attack surface:
  https://docs.docker.com/engine/security/#docker-daemon-attack-surface
- Docker - Protect the Docker daemon socket:
  https://docs.docker.com/engine/security/protect-access/
- Docker - Rootless mode:
  https://docs.docker.com/engine/security/rootless/
- Docker Engine API:
  https://docs.docker.com/engine/api/latest/

## Vulnerabilita' applicativa - buffer overflow (tappa 1)
- CWE-121 Stack-based Buffer Overflow: https://cwe.mitre.org/data/definitions/121.html
- CWE-787 Out-of-bounds Write: https://cwe.mitre.org/data/definitions/787.html
- CVE-2015-7547 (glibc getaddrinfo): https://nvd.nist.gov/vuln/detail/CVE-2015-7547
- CVE-2021-3156 (sudo, "Baron Samedit"): https://nvd.nist.gov/vuln/detail/CVE-2021-3156

## Linee guida e meccanismi
- CIS Docker Benchmark: https://www.cisecurity.org/benchmark/docker
- NIST SP 800-190 Application Container Security Guide:
  https://csrc.nist.gov/publications/detail/sp/800-190/final
- OWASP Command Injection (contesto sulle iniezioni): https://owasp.org/www-community/attacks/Command_Injection
- Linux namespaces: https://man7.org/linux/man-pages/man7/namespaces.7.html
- Linux capabilities: https://man7.org/linux/man-pages/man7/capabilities.7.html
