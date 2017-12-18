FROM alpine:3.4

RUN \
    # add www user
    adduser -D www \
    && apk --update add --no-cache pcre-dev openssl-dev openssl zlib-dev \
    && apk add --no-cache --virtual build-dependencies build-base curl \
    # install Nginx
    && curl -SLO http://nginx.org/download/nginx-1.11.3.tar.gz \
    && tar -xzvf nginx-1.11.3.tar.gz \
    && cd nginx-1.11.3/ \
    && ./configure \
    --with-http_ssl_module \
    --with-http_gzip_static_module \
    --with-http_v2_module \
    --with-http_stub_status_module \
    --prefix=/usr/share/nginx \
    --sbin-path=/usr/local/sbin/nginx \
    --conf-path=/etc/nginx/conf/nginx.conf \
    --pid-path=/var/run/nginx.pid \
    --http-log-path=/data/logs/nginx/access.log \
    --error-log-path=/data/logs/nginx/error.log \
    && make \
    && make install \
    && ln -sf /dev/stdout /data/logs/nginx/access.log \
    && ln -sf /dev/stderr /data/logs/nginx/error.log \
    && cd / \
    && apk del --purge build-dependencies \
    && rm -rf nginx-1.11.3.tar.gz nginx-1.11.3 \
    && rm -rf /etc/nginx/conf/nginx.conf /etc/nginx/conf/fastcgi_params \
    && mkdir -p /etc/nginx/ssl \
    && openssl genrsa -out /etc/nginx/ssl/dummy.key 2048 \
    && openssl req -new -key /etc/nginx/ssl/dummy.key -out /etc/nginx/ssl/dummy.csr -subj "/C=JP" \
    && openssl x509 -req -days 3650 -in /etc/nginx/ssl/dummy.csr -signkey /etc/nginx/ssl/dummy.key -out /etc/nginx/ssl/dummy.crt

ADD container-files /

ENV \
  DEFAULT_DOCUMENT_ROOT=/data/www/html/public

RUN chmod a+x /nginx-init.sh

EXPOSE 80 443

CMD ["/nginx-init.sh"]
