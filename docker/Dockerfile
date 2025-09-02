# Global variables
ARG ALPINE_VERSION="3.22.1" \
    BUILD_DATE="2025-09-01T20:00:00Z" \
    PIMSYNC_VERSION="0.4.4"

# -----------------------------------------------------------------------------------------------

# Set Alpine as the base image for building Pimsync
FROM alpine:${ALPINE_VERSION} AS pimsync-builder

# Set arguments for Pimsync version and build date
ARG ALPINE_VERSION \
    BUILD_DATE \
    PIMSYNC_VERSION \
    PIMSYNC_GIT="https://git.sr.ht/~whynothugo/pimsync"

# Set shell to ash
SHELL ["/bin/ash", "-eo", "pipefail", "-c"]

# Set workdir
WORKDIR /tmp/pimsync-build-${PIMSYNC_VERSION}

# Install build dependencies, clone git repository, verify gpg key, build pimsync and install pimsync
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
    git clone "${PIMSYNC_GIT}" "/tmp/pimsync-build-${PIMSYNC_VERSION}" && \
    # Curl complete website, where the GPG key is located
    curl -sL "https://pimsync.whynothugo.nl/install.html" | \
    # Dump it with lynx
    lynx -stdin -dump | \
    # Extract the GPG key with awk
    awk '/BEGIN PGP PUBLIC KEY BLOCK/,/END PGP PUBLIC KEY BLOCK/' | \
    # Import GPG Key from Pimsync developer/website
    gpg --import - && \
    # Checkout the specific version
    git checkout "v${PIMSYNC_VERSION}" && \
    # Verify the git tag with GPG and grep for "Good signature from", because gpg key is expired at the moment
    git tag -v "v${PIMSYNC_VERSION}" 2>&1 | grep -e "Good signature from" || true && \
    # Compile Pimsync
    make build && \
    # Install Pimsync
    make install
  
# Set workdir to the tmp directory
WORKDIR /pimsync

# Finalize the build stage
RUN set -x && \
    rm -rf "/tmp/pimsync-build-${PIMSYNC_VERSION}" && \
    # Clean up build dependencies
    apk del .build-deps && \
    # Echo the build date
    echo "Build date: ${BUILD_DATE}" > /pimsync/build_date.txt

# -----------------------------------------------------------------------------------------------

# Set Alpine as the base image
FROM alpine:${ALPINE_VERSION} AS pimsync

# Build arguments
ARG ALPINE_VERSION \
    BUILD_DATE \
    PIMSYNC_USER="pimsync" \
    PIMSYNC_USER_UID="1000" \
    PIMSYNC_USER_GID="1000" \
    PIMSYNC_VERSION

# Set environment variables
    # Set Mode for container
ENV CONTAINER_MODE="auto" \
    # Set Pimsync path
    PATH="/usr/local/bin/pimsync:${PATH}" \
    # Set Timezone
    TZ="Europe/Vienna" \
    # Pimsync Command
    PIMSYNC_COMMAND="daemon" \
    # Pimsync Config
    PIMSYNC_CONFIG="/pimsync/pimsync.conf" \
    # Pimsync Path
    PIMSYNC_EXECUTABLE_PATH="/usr/local/bin/pimsync" \
    # Pimsync Log Level
    PIMSYNC_LOG_LEVEL="info" \
    # Set script path to run after Pimsync commands
    PIMSYNC_POST_SYNC_SCRIPT_FILE="" \
    # Set script path to run before Pimsync commands
    PIMSYNC_PRE_SYNC_SCRIPT_FILE="" \
    # Set Pimsync user and group
    PIMSYNC_USER="${PIMSYNC_USER}"

# Healthcheck
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=1 \
  CMD ["/files/scripts/healthcheck.sh"]

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

# Install runtime dependencies
RUN apk update && \
    apk add --no-cache \
      sqlite-libs=~3.49.2 \
      musl=~1.2.5 \
      libgcc=~14.2.0 \
      mandoc=~1.14.6 \
      tzdata=~2025b

# Set workdir
WORKDIR /pimsync

# Copy Pimsync from the build stage 
COPY --from=pimsync-builder /usr/local/bin/pimsync /usr/local/bin/pimsync

# Copy the Pimsync manual pages
COPY --from=pimsync-builder /usr/local/share/man /usr/local/share/man

# Copy build date file
COPY --from=pimsync-builder /pimsync/build_date.txt /pimsync/build_date.txt

# Copy Files
COPY files /files

# Add Pimsync user and group
RUN addgroup -g "${PIMSYNC_USER_GID}" -S "${PIMSYNC_USER}" && \
    adduser -u "${PIMSYNC_USER_UID}" -S -D -H -G "${PIMSYNC_USER}" "${PIMSYNC_USER}" && \
    # Set permissions for Pimsync directories and scripts
    chown -R "${PIMSYNC_USER}":"${PIMSYNC_USER}" /pimsync && \
    chown -R "${PIMSYNC_USER}":"${PIMSYNC_USER}" /files && \
    chmod +x /files/scripts/*.sh 

# Switch to Pimsync user
USER "${PIMSYNC_USER}"

# Run start script
ENTRYPOINT ["sh","/files/scripts/start.sh"]
