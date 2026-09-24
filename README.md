# Laboratorio: da Buffer Overflow a Container Escape

Catena di attacco completa:

```
Applicazione vulnerabile (buffer overflow in C)
   -> exploit ret2win: shell nel container      [accesso al container]
   -> abuso del socket Docker montato           [escape container -> host]
   -> lettura come root sull'host               [condizione finale]
```

L'host compromesso e' la VM locale del Docker Engine (su Windows/macOS la VM di Docker Desktop).

## Struttura

```
assignment/
├── README.md
├── report/report.pdf
├── environment/
│   ├── Dockerfile
│   └── docker-compose.yml      # monta /var/run/docker.sock (misconfigurazione)
├── application/
│   ├── vuln.c                  # applicazione vulnerabile (buffer overflow)
│   └── app_flag.txt            # flag container-local
├── scripts/
│   ├── exploit.py              # bof ret2win -> shell
│   ├── escape.sh               # eseguito dalla shell: escape via socket
│   ├── setup.sh
│   ├── demo.sh
│   └── cleanup.sh
└── references.md
```

## Prerequisiti
- Docker Engine + Docker Compose v2.
- Script .sh: Linux/macOS o, su Windows, Git Bash o WSL. In alternativa, sezione
  "Esecuzione manuale (Windows cmd)".

## Esecuzione rapida (Linux / macOS / WSL / Git Bash)
Dalla cartella assignment/:
```bash
bash scripts/setup.sh     # pull alpine, pianta la flag host, build e avvio
bash scripts/demo.sh      # baseline + catena completa (bof -> shell -> escape)
bash scripts/cleanup.sh   # smonta e ripulisce
```
 nella tappa finale compare HOST-FLAG{docker_socket_mount_equals_root_on_host}.

## Esecuzione manuale (Windows cmd)
Dalla cartella assignment (un comando per volta).

1) Helper e flag di host:
```
docker pull alpine:latest
docker run --rm -v /:/host alpine:latest sh -c "echo HOST-FLAG{docker_socket_mount_equals_root_on_host} > /host/host_flag_secret.txt && chmod 600 /host/host_flag_secret.txt"
```
2) Build e avvio:
```
docker compose -f environment\docker-compose.yml up -d --build
```
3) Baseline (uso normale del programma):
```
docker compose -f environment\docker-compose.yml exec lab sh -c "cd /lab && echo Mario | ./vuln"
```
4) Catena completa (buffer overflow -> shell -> escape):
```
docker compose -f environment\docker-compose.yml exec lab sh -c "cd /lab && python3 exploit.py escape.sh | ./vuln"
```
Compare HOST-FLAG{...}.
5) Pulizia:
```
docker compose -f environment\docker-compose.yml down --rmi local -v
docker run --rm -v /:/host alpine:latest sh -c "rm -f /host/host_flag_secret.txt"
```

## Verifica del risultato
| Tappa | Esito atteso |
|------|--------------|
| baseline | "Ciao, Mario" + "Programma terminato normalmente." |
| bof -> shell | "id" restituisce uid=0(root) |
| flag container-local | APP-FLAG{...} |
| lettura diretta flag host | errore "No such file" (isolamento intatto) |
| escape via socket | HOST-FLAG{...} (isolamento violato) |

## Come funziona l'exploit (sintesi)
Il buffer overflow sovrascrive l'indirizzo di ritorno con quello di win(), che
avvia /bin/sh. Il payload e' 72 byte + gadget ret (allineamento stack per
system()) + indirizzo di win(), riempito a 256 byte cosi' che read(0,buf,256)
consumi solo il payload; i comandi successivi (escape.sh) vengono eseguiti dalla
shell ottenuta. La shell usa il socket Docker montato per creare un container che
monta la root dell'host e legge la flag di host.

## Nota etica
Vulnerabilita' deliberate a scopo didattico. Eseguire solo sulla propria
macchina. Tutte le azioni restano confinate al Docker Engine locale.
