ARG DISTRO=alpine
ARG DISTRO_VARIANT=3.19

FROM docker.io/tiredofit/nginx:${DISTRO}-${DISTRO_VARIANT}
LABEL maintainer="Dave Conroy (github.com/tiredofit)"

ARG ZEROTIER_VERSION
ARG ZT_NET_VERSION

ENV ZEROTIER_VERSION=${ZEROTIER_VERSION:-"1.14.0"} \
    ZT_NET_VERSION=${ZT_NET_VERSION:-"v0.6.7"} \
    ZEROTIER_REPO_URL=https://github.com/zerotier/ZeroTierOne \
    ZT_NET_REPO_URL=https://github.com/sinamics/ztnet \
    NGINX_LOG_ACCESS_LOCATION=/logs/nginx \
    NGINX_LOG_ERROR_LOCATION=/logs/nginx \
    NGINX_LOG_BLOCKED_LOCATION=/logs/nginx \
    NGINX_ENABLE_CREATE_SAMPLE_HTML=FALSE \
    NGINX_SITE_ENABLED=ztnet \
    CONTAINER_ENABLE_MESSAGING=FALSE \
    IMAGE_NAME="tiredofit/zerotier" \
    IMAGE_REPO_URL="https://github.com/tiredofit/zerotier/"

ADD build-assets/ /build-assets

RUN source assets/functions/00-container && \
    set -x && \
    addgroup -S -g 2323 zerotier && \
    adduser -D -S -s /sbin/nologin \
            -h /dev/null \
            -G zerotier \
            -g "zerotier" \
            -u 2323 zerotier \
            && \
    \
    package update && \
    package upgrade && \
    package install .zerotier-build-deps \
                    binutils \
                    build-base \
                    git \
                    linux-headers \
                    && \
    \
    package install .zerotier-run-deps \
                    iptables \
                    libc6-compat \
                    libstdc++ \
                    && \
    \
    clone_git_repo "${ZEROTIER_REPO_URL}" "${ZEROTIER_VERSION}" && \
    if [ -d "/build-assets/zerotier/src" ] ; then cp -Rp /build-assets/zerotier/src/* /usr/src/ztnet ; fi; \
    if [ -d "/build-assets/zerotier/scripts" ] ; then for script in /build-assets/zerotier/scripts/*.sh; do echo "** Applying $script"; bash $script; done && \ ; fi ; \
    sed -i "s|ZT_SSO_SUPPORTED=1|ZTG_SSO_SUPPORTED=0|g" make-linux.mk && \
    make -j $(nproc) -f make-linux.mk && \
    make -j $(nproc) -f make-linux.mk install && \
    package install .ztnet-build-deps \
                    go \
                    zip \
                    && \
    package install .ztnet-run-deps \
                    nodejs \
                    npm \
                    postgresql-client \
                    && \
    \
    clone_git_repo "${ZT_NET_REPO_URL}" "${ZT_NET_VERSION}" && \
    if [ -d "/build-assets/zt-net/src" ] ; then cp -Rp /build-assets/zt-net/src/* /usr/src/ztnet ; fi; \
    if [ -d "/build-assets/zt-net/scripts" ] ; then for script in /build-assets/zt-net/scripts/*.sh; do echo "** Applying $script"; bash $script; done && \ ; fi ; \
    cd /usr/src/ztnet && \
    npx prisma generate && \
    npm ci && \
    SKIP_ENV_VALIDATION=1 npm run build && \
    cd /usr/src/ztnet/ztnodeid && \
    go build -ldflags='-s -w' -trimpath -o /usr/bin/ztmkworld cmd/mkworld/main.go && \
    cd /usr/src/ztnet && \
    mkdir -p /app && \
    cp -R next.config.mjs /app/next.config.mjs && \
    cp -R public /app/public && \
    cp -R package.json /app/package.json && \
    mkdir -p /app/.next && \
    cp -R .next/server /app/.next/server && \
    cp -R .next/standalone/. /app/ && \
    cp -R .next/static /app/.next/static && \
    cp -R prisma /app/prisma && \
    cp -R .next/BUILD* /app/.next/ && \
    cp -R .next/*.json /app/.next && \
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
    package remove \
                    .zerotier-build-deps \
                    .ztnet-build-deps \
                    && \
    package cleanup && \
    \
    chown -R zerotier:zerotier /app && \
    rm -rf \
            /root/.cache \
            /root/.gitconfig \
            /root/.npm \
            /root/go
#            /usr/src/*

EXPOSE 3000
EXPOSE 9993/udp

COPY install /
