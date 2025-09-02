#!/bin/sh

# Set TS function for logging
# Moreutils (which contains ts command) would need to much space in my opinion, because of perl dependencies
# So awk is used
ts_awk(){
    awk '{ printf "[%s] %s\n", strftime("%Y-%m-%d %H:%M:%S"), $0; fflush() }'
}

# Welcome Message
{
    echo "Welcome to Pimsync-DOCKERIZED! :)"
    printf "\n"

    echo "For more information please visit the official docs page."
    echo "There you will also find configuration examples."
    echo "https://pimsync.whynothugo.nl/"
    printf "\n"

    echo "If you have any problems with Pimsync, please"
    echo "visit the Sourcehut repository and open an issue."
    echo "https://git.sr.ht/~whynothugo/pimsync"
    printf "\n"

    echo "If there is a problem with the container,"
    echo "contact me or open an issue in my Github repo."
    echo "https://github.com/Bleala/Pimsync-DOCKERIZED"
    echo "I am trying to fix it, so that everything"
    echo "is running as expected. :)"
    printf "\n"

    echo "Enjoy!"
    printf "\n"
} 2>&1 | ts_awk

# Starting logging
{
    echo "Starting Logging..."
    printf "\n"
} 2>&1 | ts_awk

# Log current Timezone and Date/Time
{
    echo "Current timezone is ${TZ}."
    echo "Current time is $(date)."
    printf "\n"
} 2>&1 | ts_awk

# Log current CONTAINER_MODE
{
    echo "Current CONTAINER_MODE is ${CONTAINER_MODE}."
    printf "\n"
} 2>&1 | ts_awk

# Log current PIMSYNC_COMMAND
{
    echo "Current PIMSYNC_COMMAND is ${PIMSYNC_COMMAND}."
    printf "\n"
} 2>&1 | ts_awk

# Log current PIMSYNC_CONFIG
{
    echo "Current PIMSYNC_CONFIG is ${PIMSYNC_CONFIG}."
    printf "\n"
} 2>&1 | ts_awk

# Log current PIMSYNC_EXECUTABLE_PATH
{
    echo "Current PIMSYNC_EXECUTABLE_PATH is ${PIMSYNC_EXECUTABLE_PATH}."
    printf "\n"
} 2>&1 | ts_awk

# Log current PIMSYNC_LOG_LEVEL
{
    echo "Current PIMSYNC_LOG_LEVEL is ${PIMSYNC_LOG_LEVEL}."
    printf "\n"
} 2>&1 | ts_awk

# Check if the pimsync.conf.example exists
if [ ! -e "/pimsync/pimsync.conf.example" ]
then
    # Copy pimsync.conf.example to vdirsyncer directory
    cp /files/examples/pimsync.conf.example /pimsync/pimsync.conf.example
    # User info
    {
        echo "pimsync.conf.example has been copied to /pimsync."
        printf "\n"
    } 2>&1 | ts_awk
fi

# Check, if PIMSYNC_PRE_SYNC_SCRIPT_FILE is set
if [ -z "${PIMSYNC_PRE_SYNC_SCRIPT_FILE}" ]
then
    # Set Post Sync Snippet to nothing
    PRE_SYNC_SNIPPET=""

# Set PRE_SYNC_SNIPPET, if  PIMSYNC_PRE_SYNC_SCRIPT_FILE is set
else
    # User info
    {
        echo "Custom before script is enabled."
        printf "\n"
    } 2>&1 | ts_awk

    # Set Post Sync Snippet to Post Sync File
    PRE_SYNC_SNIPPET="${PIMSYNC_PRE_SYNC_SCRIPT_FILE} &&"
fi

# Check, if PIMSYNC_POST_SYNC_SCRIPT_FILE is set
if [ -z "${PIMSYNC_POST_SYNC_SCRIPT_FILE}" ]
then
    # Set Post Sync Snippet to nothing
    POST_SYNC_SNIPPET=""

# Set POST_SYNC_SNIPPET, if  PIMSYNC_POST_SYNC_SCRIPT_FILE is set
else
    # User info
    {
        echo "Custom after script is enabled."
        printf "\n"
    } 2>&1 | ts_awk

    # Set Post Sync Snippet to Post Sync File
    POST_SYNC_SNIPPET="&& ${PIMSYNC_POST_SYNC_SCRIPT_FILE}"
fi

# If container is in automatic mode
if [ "${CONTAINER_MODE}" = "auto" ]
then
    :

    # User info
    {
        echo "Container is running in automatic mode."
        printf "\n"
        echo "Starting Pimsync with command: ${PRE_SYNC_SNIPPET} ${PIMSYNC_EXECUTABLE_PATH} -c ${PIMSYNC_CONFIG} -v ${PIMSYNC_LOG_LEVEL} ${PIMSYNC_COMMAND} ${POST_SYNC_SNIPPET}"
        printf "\n"
        echo "#######################################"
        printf "\n"
    } 2>&1 | ts_awk

    # Start Pimsync
    exec "${PRE_SYNC_SNIPPET} ${PIMSYNC_EXECUTABLE_PATH} -c ${PIMSYNC_CONFIG} -v ${PIMSYNC_LOG_LEVEL} ${PIMSYNC_COMMAND} ${POST_SYNC_SNIPPET}" 2>&1 | ts_awk

# If container is in manual mode
elif [ "${CONTAINER_MODE}" = "manual" ]
then
    # User info
    {
        echo "Container is running in manual mode."
        printf "\n"
        echo "To start Pimsync, please use the following command:"
        echo "${PRE_SYNC_SNIPPET} pimsync ${PIMSYNC_COMMAND} ${POST_SYNC_SNIPPET}"
        printf "\n"
        echo "To enter the container, please use the following command:"
        echo "docker exec -it <container_name> /bin/sh"
        printf "\n"
        echo "#######################################"
        printf "\n"
    } 2>&1 | ts_awk

    # Start container
    exec tail -f /dev/null

# If CONTAINER_MODE is not set correctly
else
    # User info
    {
        echo "CONTAINER_MODE is not set correctly!"
        echo "Please set CONTAINER_MODE to \"auto\" or \"manual\"."
        printf "\n"
        echo "Container is stopping now."
        printf "\n"
        echo "#######################################"
        printf "\n"
    } 2>&1 | ts_awk

    # Exit script with error code 1
    exit 1
fi
