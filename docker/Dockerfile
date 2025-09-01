# Global variables
ARG ALPINE_VERSION="3.22.1" \
    BUILD_DATE="2025-09-01T20:00:00Z" \
    PIMSYNC_VERSION="0.4.4"

# -----------------------------------------------------------------------------------------------

# Set Alpine as the base image for building Pimsync
FROM alpine:${ALPINE_VERSION} AS pimsync-build

# Set arguments for Pimsync version and build date
ARG ALPINE_VERSION \
    BUILD_DATE \
    PIMSYNC_VERSION \
    PIMSYNC_GIT="https://git.sr.ht/~whynothugo/pimsync"

# Set labels
LABEL org.opencontainers.image.authors="Bleala" \
      org.opencontainers.image.vendor="Bleala" \
      org.opencontainers.image.version="${PIMSYNC_VERSION}" \
      org.opencontainers.image.created="${BUILD_DATE}" \
      org.opencontainers.image.title="Pimsync-DOCKERIZED" \
      org.opencontainers.image.description="Pimsync - to synchronise calendars and contacts between different storages. DOCKERIZED!" \
      org.opencontainers.image.documentation="https://pimsync.whynothugo.nl/" \
      org.opencontainers.image.url="https://hub.docker.com/r/bleala/pimsync" \
      org.opencontainers.image.source="https://github.com/Bleala/Pimsync-DOCKERIZED"

# Set shell to ash
SHELL ["/bin/ash", "-eo", "pipefail", "-c"]

# Set workdir
WORKDIR /tmp/pimsync-build

# Install build dependencies, build pimsync and remove dependencies
RUN set -x && \
    apk update && \
    apk add --no-cache --virtual .build-deps \
      git=~2.49.1 \
      gnupg=~2.4.7 \
      curl=~8.14.1 \
      lynx=~2.9.2 \
      grep=~3.12 \
      make=~4.4.1 \
      rust=~1.87.0 \
      cargo=~1.87.0 \
      sqlite-dev=~3.49.2 \
      mandoc=~1.14.6 && \
    # Download Pimsync from Sourcehut
    git clone "${PIMSYNC_GIT}" "/tmp/pimsync-build/pimsync-${PIMSYNC_VERSION}" && \
    # Import GPG Key from Pimsync developer/website
    curl -sL "https://pimsync.whynothugo.nl/install.html" | \
    lynx -stdin -dump | \
    awk '/BEGIN PGP PUBLIC KEY BLOCK/,/END PGP PUBLIC KEY BLOCK/' | \
    gpg --import -

# Set workdir to the git Pimsync directory
WORKDIR /tmp/pimsync-build/pimsync-${PIMSYNC_VERSION}

# # Prepare git directory for Pimsync
RUN set -x && \
    # Checkout the specific version
    git checkout "v${PIMSYNC_VERSION}" && \
    # Verify the git tag with GPG and grep for "Good signature from", because gpg key is expired at the moment
    git tag -v "v${PIMSYNC_VERSION}" 2>&1 | grep -e "Good signature from" || true

# Build Pimsync
RUN set -x && \
    # Compile and install Pimsync
    make build && \
    make install
  
# Set workdir to the tmp directory
WORKDIR /pimsync

# Finalize the build stage
RUN set -x && \
    rm -rf /tmp/pimsync-build && \
    # Clean up build dependencies
    apk del .build-deps && \
    # Echo the build date
    echo "Build date: ${BUILD_DATE}" > /pimsync/build_date.txt

# -----------------------------------------------------------------------------------------------

# Set Alpine as the base image
FROM alpine:${ALPINE_VERSION}

# Build arguments
ARG ALPINE_VERSION \
    BUILD_DATE \
    PIMSYNC_USER="pimsync" \
    PIMSYNC_USER_UID="1000" \
    PIMSYNC_USER_GID="1000" \
    PIMSYNC_VERSION

# Set environment variables
    # Set Pimsync path
ENV PATH="/usr/local/bin/pimsync:${PATH}" \
    # Set Timezone
    TZ="Europe/Vienna" \
    # Set Pimsync user and group
    PIMSYNC_USER="${PIMSYNC_USER}"

# Healthcheck
# HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \
#   CMD nslookup -timeout=1 -retry=1 google.com 127.0.0.1 || exit 1

# Set labels
LABEL org.opencontainers.image.authors="Bleala" \
      org.opencontainers.image.vendor="Bleala" \
      org.opencontainers.image.version="${PIMSYNC_VERSION}" \
      org.opencontainers.image.created="${BUILD_DATE}" \
      org.opencontainers.image.title="Pimsync-DOCKERIZED" \
      org.opencontainers.image.description="Pimsync - to synchronise calendars and contacts between different storages. DOCKERIZED!" \
      org.opencontainers.image.documentation="https://pimsync.whynothugo.nl/" \
      org.opencontainers.image.url="https://hub.docker.com/r/bleala/pimsync" \
      org.opencontainers.image.source="https://github.com/Bleala/Pimsync-DOCKERIZED"

# Set workdir
WORKDIR /pimsync

# Install runtime dependencies
RUN apk update && \
    apk add --no-cache \
      sqlite-libs=~3.49.2 \
      musl=~1.2.5 \
      libgcc=~14.2.0 \
      mandoc=~1.14.6 \
      tzdata=~2025b

# Add Pimsync user and group
RUN addgroup -g "${PIMSYNC_USER_GID}" -S "${PIMSYNC_USER}" && \
    adduser -u "${PIMSYNC_USER_UID}" -S -D -H -G "${PIMSYNC_USER}" "${PIMSYNC_USER}"

# Copy Pimsync from the build stage 
COPY --from=pimsync-build /usr/local/bin/pimsync /usr/local/bin/pimsync

# Copy the Pimsync configuration file
COPY --from=pimsync-build /usr/local/share/man /usr/local/share/man

# Copy build date file
COPY --from=pimsync-build /pimsync/build_date.txt /pimsync/build_date.txt

# Copy Files
COPY files /files

# Copy example configuration files
COPY files/examples/pimsync.conf /pimsync/pimsync.conf.example

# Set permissions for Pimsync directories and scripts
RUN chown -R "${PIMSYNC_USER}":"${PIMSYNC_USER}" /pimsync && \
    chown -R "${PIMSYNC_USER}":"${PIMSYNC_USER}" /files && \
    chmod +x /files/scripts/*.sh 

# Switch to Pimsync user
USER "${PIMSYNC_USER}"

# Run start script
ENTRYPOINT ["sh","/files/scripts/start.sh"]
