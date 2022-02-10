# Web Docker

Configuration:
* Alpine
* Nginx
* MySQL 8
* PHP 8

## Compose - recommended for persistence
```
curl -O https://raw.githubusercontent.com/als698/web-docker/master/docker-compose.yml && docker-compose up -d
```

## Pull
```
docker pull als698/web
```

## Run
```
docker run --name web -p 80:8080 -it als698/web
```

## Config
phpMyAdmin: http://localhost/pma/

Default Env
  * Database: app
  * User DB: dbus3r
  * Password DB: dbpas
  * Root Pass DB: t0rpas
  * IMPORT_DB: unset - set it to 1 in docker-compose if you want to import your db from db/import.sql

## Docker Run Env
```
docker run -it --name web -p 80:8080 \
  -e MYSQL_DATABASE=dbName \
  -e MYSQL_USER=uName \
  -e MYSQL_PASSWORD=pAss \
  -e MYSQL_ROOT_PASSWORD=rPass \
  als698/web
```

## Directory for docker-compose

```
db/ - Database
db/data/ - Database data - /db/data/
db/import.sql - Import database - /db/import.sql

web/html/ - Web files - /var/www/html/
web/pma/ - phpMyAdmin - /var/www/pma/
```

## Fix
[ ] Database bind

## Acknowledgements
This image was inspired by [khromov/alpine-nginx-php8](https://github.com/khromov/alpine-nginx-php8), [TrafeX/docker-php-nginx](https://github.com/TrafeX/docker-php-nginx), [wangxian/alpine-mysql](https://github.com/wangxian/alpine-mysql) and [this subsequent fork](https://github.com/khromov/docker-php-nginx)
