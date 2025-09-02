#!/bin/sh

# Set TS function for logging
# Moreutils (which contains ts command) would need too much space in my opinion, because of perl dependencies
# So awk is used
# Use 'docker logs -t' instead of ts_awk, if you want docker to add timestamps
# ts_awk(){
#     awk '{ printf "[%s] %s\n", strftime("%Y-%m-%d %H:%M:%S"), $0; fflush() }'
# }

# Function to log messages with timestamp, reduce code duplication
log_message() {
    {
        # Remove tabs and leading spaces from the message
        printf "%s\n" "$@" | sed 's/^[ \t]*//'
        printf "\n"
    }
    # 2>&1 | ts_awk
}

# Welcome Message
log_message "Welcome to Pimsync-DOCKERIZED! :)"

log_message "For more information please visit the official docs page.
            There you will also find configuration examples.
            https://pimsync.whynothugo.nl/"

log_message "If you have any problems with Pimsync, please
            visit the Sourcehut repository and open an issue.
            https://git.sr.ht/~whynothugo/pimsync"

log_message "If there is a problem with the container,
            contact me or open an issue in my Github repo.
            https://github.com/Bleala/Pimsync-DOCKERIZED
            I am trying to fix it, so that everything
            is running as expected. :)"

log_message "Enjoy!"

# Line
log_message "----------------------------------------"

# Starting logging
log_message "Starting Logging."

# Log current Timezone
log_message "Current timezone is ${TZ}."

# Log current Date/Time
log_message "Current time is $(date)."

# Log current CONTAINER_MODE
log_message "Current CONTAINER_MODE is ${CONTAINER_MODE}."

# Log current PIMSYNC_COMMAND
log_message "Current PIMSYNC_COMMAND is ${PIMSYNC_COMMAND}."

# Log current PIMSYNC_CONFIG
log_message "Current PIMSYNC_CONFIG is ${PIMSYNC_CONFIG}."

# Log current PIMSYNC_EXECUTABLE_PATH
log_message "Current PIMSYNC_EXECUTABLE_PATH is ${PIMSYNC_EXECUTABLE_PATH}."

# Log current PIMSYNC_LOG_LEVEL
log_message "Current PIMSYNC_LOG_LEVEL is ${PIMSYNC_LOG_LEVEL}."

# Check if the pimsync.conf.example exists
if [ ! -e "/pimsync/pimsync.conf.example" ]
then
    # Copy pimsync.conf.example to vdirsyncer directory
    cp /files/examples/pimsync.conf.example /pimsync/pimsync.conf.example
    
    # User info
    log_message "pimsync.conf.example has been copied to /pimsync."
fi

# Has to be implemented for the manual mode or a special cron mode
# Check, if PIMSYNC_PRE_SYNC_SCRIPT_FILE is set
if [ -z "${PIMSYNC_PRE_SYNC_SCRIPT_FILE}" ]
then
    # Set Post Sync Snippet to nothing
    PRE_SYNC_SNIPPET=""

# Set PRE_SYNC_SNIPPET, if  PIMSYNC_PRE_SYNC_SCRIPT_FILE is set
else
    # User info
    log_message "Custom before script is enabled."

    # Set Post Sync Snippet to Post Sync File
    PRE_SYNC_SNIPPET="${PIMSYNC_PRE_SYNC_SCRIPT_FILE} &&"
fi

# Has to be implemented for the manual mode or a special cron mode
# Check, if PIMSYNC_POST_SYNC_SCRIPT_FILE is set
if [ -z "${PIMSYNC_POST_SYNC_SCRIPT_FILE}" ]
then
    # Set Post Sync Snippet to nothing
    POST_SYNC_SNIPPET=""

# Set POST_SYNC_SNIPPET, if  PIMSYNC_POST_SYNC_SCRIPT_FILE is set
else
    # User info
    log_message "Custom after script is enabled."

    # Set Post Sync Snippet to Post Sync File
    POST_SYNC_SNIPPET="&& ${PIMSYNC_POST_SYNC_SCRIPT_FILE}"
fi

# Line
log_message "----------------------------------------"

# If container is in automatic mode
if [ "${CONTAINER_MODE}" = "auto" ]
then
    # User info
    log_message "Container is running in automatic mode."

    log_message "Starting Pimsync with command: ${PIMSYNC_EXECUTABLE_PATH} -c ${PIMSYNC_CONFIG} -v ${PIMSYNC_LOG_LEVEL} ${PIMSYNC_COMMAND}"

    # Line
    log_message "----------------------------------------"

    # Start Pimsync
    exec "${PIMSYNC_EXECUTABLE_PATH}" -c "${PIMSYNC_CONFIG}" -v "${PIMSYNC_LOG_LEVEL}" "${PIMSYNC_COMMAND}"

# If container is in manual mode
elif [ "${CONTAINER_MODE}" = "manual" ]
then
    # User info
    log_message "Container is running in manual mode."

    log_message "To enter the container, please use the following command:
                docker exec -it <container_name> /bin/sh"

    log_message "To start Pimsync, please use the following command:
                pimsync <your-command>"

    # Line
    log_message "----------------------------------------"

    # Start container
    exec tail -f /dev/null

# If CONTAINER_MODE is not set correctly
else
    # User info
    log_message "CONTAINER_MODE is not set correctly!
                Please set CONTAINER_MODE to \"auto\" or \"manual\"."

    log_message "Container is stopping now."

    # Exit script with error code 1
    exit 1
fi
