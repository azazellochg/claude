
FROM debian:bookworm-slim

ENV HOME=/home/claude
ENV BUN_INSTALL=/home/claude/.bun
ENV PATH=/home/claude/.bun/bin:/home/claude/.local/bin:$PATH
ENV CLAUDE_CONFIG_DIR=/home/claude/.claude

ARG DEBIAN_FRONTEND=noninteractive

# System dependencies and user
RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates curl git bash iptables ipset unzip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    useradd -m -u 1000 -s /bin/bash claude && \
    mkdir -p /opt/claude-seed && \
    chown -R claude:claude /opt/claude-seed

USER claude

# Install Bun
RUN curl -fsSL https://bun.sh/install | bash

# Install Claude Code
RUN curl -fsSL https://claude.ai/install.sh | bash

# Preinstall pg-aiguide into the plugin seed
RUN CLAUDE_CODE_PLUGIN_CACHE_DIR=/opt/claude-seed claude plugin marketplace add timescale/pg-aiguide && \
    CLAUDE_CODE_PLUGIN_CACHE_DIR=/opt/claude-seed claude plugin install pg@aiguide

WORKDIR /workspace

ENTRYPOINT ["claude"]
