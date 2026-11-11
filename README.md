# Custom Claude Code container

- requires podman-compose
- Debian-based
- includes timescale/pg-aiguide plugin
- read-only container with config and project folder volume-mounted separately
- no telemetry or updates

```bash
podman build -t claude .
podman-compose -f compose.yaml up -d
podman exec -it claude claude --resume XXXXX
```
