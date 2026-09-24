FROM debian:12-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
        gcc libc6-dev binutils python3 curl ca-certificates gdb \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /lab

COPY application/vuln.c       /lab/vuln.c
COPY scripts/exploit.py       /lab/exploit.py
COPY scripts/escape.sh        /lab/escape.sh
COPY application/app_flag.txt  /app_flag.txt

RUN gcc -fno-stack-protector -no-pie -g -O0 -o /lab/vuln /lab/vuln.c && \
    chmod +x /lab/vuln

CMD ["sleep", "infinity"]
