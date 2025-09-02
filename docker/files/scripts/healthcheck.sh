#!/bin/sh
set -e

# Überprüft, ob der pimsync-Prozess mit dem erwarteten Befehl läuft
if pgrep -f "${PIMSYNC_EXECUTABLE_PATH}.*${PIMSYNC_COMMAND}" > /dev/null 2>&1
then
  exit 0
else
  exit 1
fi