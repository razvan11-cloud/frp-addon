# Use the official Home Assistant base image
ARG BUILD_FROM
FROM ${BUILD_FROM}

# Set environment variables for frp version
ENV FRP_VERSION="0.45.0"

# Install the frpc binary
RUN \
    set -x && \
    apk add --no-cache curl && \
    ARCH=$(uname -m) && \
    if [ "${ARCH}" = "aarch64" ]; then FRP_ARCH="arm64"; fi && \
    if [ "${ARCH}" = "x86_64" ]; then FRP_ARCH="amd64"; fi && \
    if [ "${ARCH}" = "armv7l" ]; then FRP_ARCH="arm"; fi && \
    curl -Lo /tmp/frp.tar.gz "https://github.com/fatedier/frp/releases/download/v${FRP_VERSION}/frp_${FRP_VERSION}_linux_${FRP_ARCH}.tar.gz" && \
    tar -xzf /tmp/frp.tar.gz -C /tmp && \
    mv /tmp/frp_${FRP_VERSION}_linux_${FRP_ARCH}/frpc /usr/bin/frpc && \
    chmod a+x /usr/bin/frpc && \
    rm -rf /tmp/*

# Copy the root filesystem (our startup script) into the image
COPY rootfs /