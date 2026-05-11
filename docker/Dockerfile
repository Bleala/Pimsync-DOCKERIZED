# Global variables
ARG ALPINE_VERSION="3.23.4" \
    IMAGE_VERSION="1.0.5" \
    PIMSYNC_VERSION="0.5.8"

# -----------------------------------------------------------------------------------------------

# Set Alpine as the base image for building Pimsync
FROM alpine:${ALPINE_VERSION} AS pimsync-builder

# Set arguments for Pimsync version and build date
ARG ALPINE_VERSION \
    PIMSYNC_VERSION \
    PIMSYNC_GIT="https://git.sr.ht/~whynothugo/pimsync" \
    PIMSYNC_WEBSITE="https://pimsync.whynothugo.nl/install.html"

# Set shell options
SHELL ["/bin/ash", "-eo", "pipefail", "-c"]
# Install build dependencies
RUN set -x && \
    apk add --no-cache --virtual .build-deps \
      # For strip command
      binutils \
      build-base \
      curl \
      git \
      gnupg \
      grep \
      lynx \
      make \
      mandoc \
      sqlite-dev \
      sqlite-static && \
    # Install newest Rust version
    curl --proto '=https' --tlsv1.3 -sSf https://sh.rustup.rs | sh -s -- -y

# Set workdir
WORKDIR /tmp/pimsync-build-${PIMSYNC_VERSION}

# Clone git repository, verify GPG key, build Pimsync and install Pimsync      
    # Download Pimsync from Sourcehut
RUN git clone "${PIMSYNC_GIT}" "/tmp/pimsync-build-${PIMSYNC_VERSION}" && \
    # Curl complete website, where the GPG key is located
    curl -sL "${PIMSYNC_WEBSITE}" | \
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
    # Add Rust to PATH
    export PATH="$HOME/.cargo/bin:$PATH" && \
    # Compile Pimsync
    # Cores not set as cargo uses all available cores by default
    make build && \
    # Install Pimsync
    make install && \
    # Strip binary to reduce size
    strip /usr/local/bin/pimsync

# -----------------------------------------------------------------------------------------------

# Set Alpine as the base image
FROM alpine:${ALPINE_VERSION} AS pimsync

# Build arguments
ARG ALPINE_VERSION \
    IMAGE_VERSION \
    PIMSYNC_USER="pimsync" \
    PIMSYNC_USER_UID="1000" \
    PIMSYNC_USER_GID="1000"

# Set shell options
SHELL ["/bin/ash", "-eo", "pipefail", "-c"]

# Set environment variables
    # Set Mode for container
ENV CONTAINER_MODE="auto" \
    # Set Pimsync path
    PATH="/usr/local/bin:${PATH}" \
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
    PIMSYNC_USER="${PIMSYNC_USER}" \
    # Sleep Path
    SLEEP_EXECUTABLE_PATH="/bin/sleep"

# Healthcheck
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=1 \
  CMD ["/files/scripts/healthcheck.sh"]

# Install runtime dependencies
RUN apk add --no-cache \
      # For running Pimsync
      libgcc \
      # To view the manual pages of Pimsync
      mandoc \
      # For running Pimsync
      musl \
      # For running Pimsync
      sqlite-libs \
      # For timezone handling
      tzdata \
      # Tini as a minimal init system to handle signal processing
      tini

# Add Pimsync user and group
RUN addgroup -g "${PIMSYNC_USER_GID}" -S "${PIMSYNC_USER}" && \
    adduser -u "${PIMSYNC_USER_UID}" -S -D -G "${PIMSYNC_USER}" "${PIMSYNC_USER}"

# Copy Pimsync from the build stage 
COPY --from=pimsync-builder /usr/local/bin/pimsync /usr/local/bin/pimsync

# Copy the Pimsync manual pages
COPY --from=pimsync-builder /usr/local/share/man /usr/local/share/man

# Copy Files
COPY --chown="${PIMSYNC_USER_UID}:${PIMSYNC_USER_GID}" --chmod=755 files /files

# Set build date argument here, because caching would break otherwise
# It is set during the build process in the reusable workflow
ARG BUILD_DATE

# Set labels
LABEL org.opencontainers.image.authors="Bleala" \
      org.opencontainers.image.vendor="Bleala" \
      org.opencontainers.image.version="${IMAGE_VERSION}" \
      org.opencontainers.image.created="${BUILD_DATE}" \
      org.opencontainers.image.title="Pimsync-DOCKERIZED" \
      org.opencontainers.image.description="Pimsync - to synchronise calendars and contacts between different storages. DOCKERIZED!" \
      org.opencontainers.image.documentation="https://pimsync.whynothugo.nl/" \
      org.opencontainers.image.url="https://hub.docker.com/r/bleala/pimsync" \
      org.opencontainers.image.source="https://github.com/Bleala/Pimsync-DOCKERIZED"

# Switch to Pimsync user
USER "${PIMSYNC_USER}"

# Set workdir
# Needs to be after USER --> otherwise would be owned by root
WORKDIR /pimsync

# Run start script
ENTRYPOINT ["/sbin/tini", "--", "/bin/sh", "/files/scripts/start.sh"]
