#!/bin/bash
SCRIPTNAME=$0
function out() {
  echo "$(date) $SCRIPTNAME[$$]: ${1+$@}"
}
out "Starting Container $0"

out "Checking if database configuration is present"
if [ -f /app/other/dbconfig.php ]; then
  diff /app/other.default/dbconfig.php /app/other/dbconfig.php &>/dev/null
  if [ $? -ne 0 ]; then
    out "Database is configured, deleting 'install.php'."
    [ -f "/app/install.php" ] && rm /app/install.php
  fi
fi
[ -f "/app/install.php" ] && out "WARNING: install.php is removed when you run through the installation process or when you restart the container."

out "Copying missing configuration files"
cp -v -n /app/other.default/* /app/other/

out "Chowning '/app' and /cronjob to 'www-data'"
chown www-data: -R /app /cronjob

out "Copying env for cronjob"
env | sed -e 's/=/=\x27/;s/$/\x27/' > /cronjob/env

out "Starting bot"
/cronjob/cronjob.sh
out "Starting cron"
service cron start
out "Starting apache"
exec apachectl -D FOREGROUND

