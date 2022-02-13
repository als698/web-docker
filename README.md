# Web Docker

Configuration:
* Alpine 3.5
* Nginx
* MySQL 8
* PHP 8.1

## Compose - recommended for persistence
```
curl -O https://raw.githubusercontent.com/als698/web-docker/master/docker-compose.yml && docker-compose up -d
```

## Pull
```
docker pull als698/web:compose
docker pull als698/php:latest
```

## Config
phpMyAdmin: http://localhost/pma/

Default Env
  * Database: app
  * User DB: dbus3r
  * Password DB: dbpas
  * Root Pass DB: t0rpas
  * IMPORT_DB: unset - set it to 1 in docker-compose if you want to import your db from db/import.sql

## Directory for docker-compose

```
db/ - Database
db/data/ - Database data - /db/data/
db/import.sql - Import database - /db/import.sql

web/html/ - Web files - /var/www/html/
web/pma.zip - phpMyAdmin - /var/www/pma/
```

## Fix
[x] Database bind
[x] PHP Glob function

## Acknowledgements
This image was inspired by [khromov/alpine-nginx-php8](https://github.com/khromov/alpine-nginx-php8), [TrafeX/docker-php-nginx](https://github.com/TrafeX/docker-php-nginx), [wangxian/alpine-mysql](https://github.com/wangxian/alpine-mysql) and [this subsequent fork](https://github.com/khromov/docker-php-nginx)
