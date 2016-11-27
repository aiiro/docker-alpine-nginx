# docker-alpine-nginx

## Usage
- docker-compose
```
$ docker-compose up
$ docker-compose up -d
```

## Basic
```
$ docker run -d -p 80:80 -p 443:443 aiiro/alpine-nginx:latest
```

## Add PHP-FPM upstream
1. Boot php-fpm server

2. Execute docker run
```
$ docker run -d -p 80:80 -p 443:443 -e WITH_PHP_FPM="TRUE" aiiro/alpine-nginx:latest
```


## Set servername
1. Add the host name to /etc/hosts file.
`
127.0.0.1 devserver.local
`  

2. Execute docker run
```
$ docker run -d -p 80:80 -p 443:443 -e MY_SERVER_NAME="devserver.local" aiiro/alpine-nginx:latest
```
