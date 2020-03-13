#!/bin/bash
SCRIPTNAME=$0
function out() {
  echo "$(date) $SCRIPTNAME[$$]: ${1+$@}"
}

if [ -f /app/install.php ]; then
  out "WARNING: Setup has not completed yet as 'install.php' is still present. Skipping start."
  exit 0
fi

if [ -f /app/logs/autostart_deactivated ]; then
  out "INFO: Bot autostart is disabled. Please start it manually first. Skipping start."
  exit 0
fi

running_bot_pid=$(pgrep -f "php /app/jobs/bot.php")
if [ -n "$running_bot_pid" -a -f /app/logs/pid ]; then
  pid=$(cat /app/logs/pid)
  if [ "$running_bot_pid" == "$pid" ]; then
    out "INFO: Bot is running. Skipping start."
    exit 0
  else
    out "WARNING: Bot is running but pid file does not match."
  fi
fi

out "Starting worker check job"
trap "out Finished with '$?'" SIGINT SIGTERM
. /cronjob/env
exec /sbin/runuser -u www-data -g www-data -p -- /usr/local/bin/php /app/worker.php check

