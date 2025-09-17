# SPDX-FileCopyrightText: © 2025 Nfrastack <code@nfrastack.com>
#
# SPDX-License-Identifier: MIT

ARG BASE_IMAGE
ARG DISTRO
ARG DISTRO_VARIANT

FROM ${BASE_IMAGE}:${DISTRO}_${DISTRO_VARIANT}

LABEL \
        org.opencontainers.image.title="Zerotier" \
        org.opencontainers.image.description="Virtual ethernet switch and Administation Console" \
        org.opencontainers.image.url="https://hub.docker.com/r/nfrastack/zerotier" \
        org.opencontainers.image.documentation="https://github.com/nfrastack/container-zerotier/blob/main/README.md" \
        org.opencontainers.image.source="https://github.com/nfrastack/container-zerotier.git" \
        org.opencontainers.image.authors="Nfrastack <code@nfrastack.com>" \
        org.opencontainers.image.vendor="Nfrastack <https://www.nfrastack.com>" \
        org.opencontainers.image.licenses="MIT"

ARG \
    ZEROTIER_VERSION="1.16.0" \
    ZT_NET_VERSION="v0.7.7" \
    ZEROTIER_REPO_URL=https://github.com/zerotier/ZeroTierOne \
    ZT_NET_REPO_URL=https://github.com/sinamics/ztnet

COPY CHANGELOG.md /usr/src/container/CHANGELOG.md
COPY LICENSE /usr/src/container/LICENSE
COPY README.md /usr/src/container/README.md

ENV \
    NGINX_ENABLE_CREATE_SAMPLE_HTML=FALSE \
    NGINX_SITE_ENABLED=ztnet \
    CONTAINER_ENABLE_SCHEDULING=TRUE \
    CONTAINER_ENABLE_MESSAGING=FALSE \
    IMAGE_NAME="nfrastack/zerotier" \
    IMAGE_REPO_URL="https://github.com/nfrastack/container-zerotier/"

COPY build-assets/ /build-assets

RUN echo "" && \
    ZEROTIER_BUILD_DEPS_ALPINE=" \
                                binutils \
                                build-base \
                                git \
                                linux-headers \
rust cargo \
                            " \
                        && \
    ZEROTIER_RUN_DEPS_ALPINE=" \
                                iptables \
                                libc6-compat \
                                libstdc++ \
                            " \
                        && \
    \
    ZTNET_BUILD_DEPS_ALPINE=" \
                                go \
                                zip \
                            " \
                        && \
    ZTNET_RUN_DEPS_ALPINE=" \
                                nodejs \
                                npm \
                                postgresql-client \
                            " \
                        && \
    source /container/base/functions/container/build && \
    container_build_log image && \
    create_user zerotier 9376 zerotier 9376 /dev/null && \
    package update && \
    package upgrade && \
    package install \
                        ZEROTIER_BUILD_DEPS \
                        ZEROTIER_RUN_DEPS \
                        ZTNET_BUILD_DEPS \
                        ZTNET_RUN_DEPS \
                        && \
    \
    clone_git_repo "${ZEROTIER_REPO_URL}" "${ZEROTIER_VERSION}" && \
    if [ -d "/build-assets/zerotier/src" ] ; then cp -Rp /build-assets/zerotier/src/* /usr/src/ztnet ; fi; \
    if [ -d "/build-assets/zerotier/scripts" ] ; then for script in /build-assets/zerotier/scripts/*.sh; do echo "** Applying $script"; bash $script; done && \ ; fi ; \
    sed -i "s|ZT_SSO_SUPPORTED=1|ZT_SSO_SUPPORTED=0|g" make-linux.mk && \
    make -j $(nproc) -f make-linux.mk ZT_NONFREE=1 ZT_CONTROLLER=0 && \
    make install && \
    rm -rf /var/lib/zerotier-one && \
    container_build_log add "Zerotier" "${ZEROTIER_VERSION}" "${ZEROTIER_REPO_URL}" && \
    \
    clone_git_repo "${ZT_NET_REPO_URL}" "${ZT_NET_VERSION}" && \
    if [ -d "/build-assets/zt-net/src" ] ; then cp -Rp /build-assets/zt-net/src/* /usr/src/ztnet ; fi; \
    if [ -d "/build-assets/zt-net/scripts" ] ; then for script in /build-assets/zt-net/scripts/*.sh; do echo "** Applying $script"; bash $script; done && \ ; fi ; \
    cd /usr/src/ztnet && \
    npx prisma generate && \
    npm ci && \
    SKIP_ENV_VALIDATION=1 npm run build && \
    cd /usr/src/ztnet/ztnodeid && \
    go mod tidy && \
    go build -ldflags='-s -w' -trimpath -o /usr/bin/ztmkworld cmd/mkworld/main.go && \
    cd /usr/src/ztnet && \
    mkdir -p /app /app/.next && \
    cp next.config.mjs package.json /app/ && \
    cp -R \
            public \
            prisma \
        /app/ && \
    cp -R \
            .next/server \
            .next/static \
        /app/.next/ && \
    cp -R \
            .next/standalone/. \
        /app/ && \
    cp -R \
            .next/BUILD* \
            .next/*.json \
        /app/.next/ && \
    cd /app && \
    npm install \
            @prisma/client \
            @paralleldrive/cuid2 \
            && \
    \
    npm install -g \
                prisma \
                ts-node \
                && \
    \
    container_build_log add "ZT Net" "${ZT_NET_VERSION}" "${ZT_NET_REPO_URL}" && \
    echo "${ZT_NET_VERSION}" > /app/.ztnet-version && \
    chown -R zerotier:zerotier /app && \
    \
    package remove \
                    ZEROTIER_BUILD_DEPS \
                    ZTNET_BUILD_DEPS \
                    && \
    package cleanup

EXPOSE 3000
EXPOSE 9993/udp

COPY rootfs /
