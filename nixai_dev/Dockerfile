# ===== STAGE 1: Build Dependencies =====
FROM debian:trixie-slim AS builder
ARG TARGETARCH

# Install build dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates curl gnupg git build-essential \
    golang-go nodejs npm \
    && rm -rf /var/lib/apt/lists/*

# Install opencode from GitHub releases
RUN ARCH=${TARGETARCH} \
    && if [ "$ARCH" = "amd64" ]; then ARCH="x86_64"; fi \
    && curl -fsSL "https://github.com/anomalyco/opencode/releases/latest/download/opencode_linux_${ARCH}.tar.gz" \
    | tar -xz -C /usr/local/bin opencode \
    && chmod +x /usr/local/bin/opencode

# Build openclaw from source
WORKDIR /build/openclaw
RUN git clone --depth 1 https://github.com/openclaw/openclaw.git . \
    && npm ci \
    && npm run build \
    && mkdir -p /opt/openclaw \
    && cp -r dist/* /opt/openclaw/ \
    && cp package.json /opt/openclaw/ \
    && cp -r node_modules /opt/openclaw/

# ===== STAGE 2: Runtime =====
FROM debian:trixie-slim

# Install runtime dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    supervisor curl ca-certificates tini \
    && curl -fsSL https://ollama.com/install.sh | sh \
    && rm -rf /var/lib/apt/lists/*

# Install code-server
RUN curl -fsSL https://code-server.dev/install.sh | sh -s -- --method=standalone

# Copy binaries from builder
COPY --from=builder /usr/local/bin/opencode /usr/local/bin/opencode
COPY --from=builder /opt/openclaw /opt/openclaw

# Create volume directories
RUN mkdir -p \
    /data/ollama \
    /config /data /projects \
    /home/node/.openclaw /home/node/.openclaw/workspace /home/node/.config/openclaw \
    /data/vscode/data /data/vscode/config

# Copy supervisor config
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Copy default opencode config
COPY opencode-config.json /config/config.json

# Set timezone
ENV TZ=America/Vancouver
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Entrypoint
ENTRYPOINT ["tini", "--", "/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]