#!/
# Originally from https://github.com/pozgo/docker-cacti/blob/master/container-files/config/init/start.sh

echo '*/5    *   *   *   *   php /var/www/html/poller.php > /dev/null 2>&1' > /tmp/import-cron.conf


echo "import crontab"
crontab /tmp/import-cron.conf

echo "start cron"
cron -f

echo "start apache"

/usr/local/bin/apache2-foreground
