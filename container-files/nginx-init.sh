#!/bin/sh

set -e
set -u

mkdir -p $DEFAULT_DOCUMENT_ROOT
chown -R www:www $DEFAULT_DOCUMENT_ROOT

mkdir -p /data/tmp/nginx/client_temp
mkdir -p /data/tmp/nginx/proxy_temp
mkdir -p /data/tmp/nginx/fastcgi_cache
mkdir -p /data/tmp/nginx/fastcgi_cache_tmp
chmod 711 /data/tmp/nginx

mkdir -p /data/www
chown -R www:www /data/www

WITH_PHP_FPM=${WITH_PHP_FPM:-"FALSE"}
MY_SERVER_NAME=${MY_SERVER_NAME:-"myserver.local"}

PHP_FPM_UPSTREAM="
# Weighted Round Robin setting
upstream php-upstream {
  server php-fpm:9000;
}
"

rm -f /etc/nginx/conf/access/location.conf
if [ "${WITH_PHP_FPM}" = TRUE ]; then
  # php-fpm must be started before Nginx starts.
  cp /etc/nginx/conf/access/location.conf.php.fpm /etc/nginx/conf/access/location.conf
  echo "${PHP_FPM_UPSTREAM}" >> /etc/nginx/conf/nginx/upstream.conf
else
  cp /etc/nginx/conf/access/location.conf.default /etc/nginx/conf/access/location.conf
fi

sed -i -e "s/MY_SERVER_NAME/${MY_SERVER_NAME}/" /etc/nginx/conf/hosts/server.conf

# Start Nginx
/bin/sh -c "nginx"
