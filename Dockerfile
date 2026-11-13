
FROM debian:bookworm-slim

ENV HOME=/home/claude
ENV BUN_INSTALL=/home/claude/.bun
ENV PATH=/home/claude/.bun/bin:/home/claude/.local/bin:$PATH
ENV CLAUDE_CONFIG_DIR=/home/claude/.claude

# Keep Python and tool caches in writable locations
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV PIP_CACHE_DIR=/tmp/pip-cache
ENV UV_CACHE_DIR=/tmp/uv-cache

ARG DEBIAN_FRONTEND=noninteractive

# System dependencies and user
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    git \
    bash \
    iptables \
    ipset \
    postgresql-client \
    python3 \
    python3-venv \
    python3-pip \
    unzip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    useradd -m -u 1000 -s /bin/bash claude && \
    mkdir -p /opt/claude-seed && \
    chown -R claude:claude /opt/claude-seed

USER claude

# Install uv
RUN curl -LsSf https://astral.sh/uv/install.sh | sh

# Install Bun
RUN curl -fsSL https://bun.sh/install | bash

# Install Claude Code
RUN curl -fsSL https://claude.ai/install.sh | bash

# Preinstall pg-aiguide into the plugin seed
RUN CLAUDE_CODE_PLUGIN_CACHE_DIR=/opt/claude-seed claude plugin marketplace add timescale/pg-aiguide && \
    CLAUDE_CODE_PLUGIN_CACHE_DIR=/opt/claude-seed claude plugin install pg@aiguide

WORKDIR /workspace

ENTRYPOINT ["claude"]
