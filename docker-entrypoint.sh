#!/usr/bin/env bash

echo Starting server

set -u
set -e

php composer.phar install

cd /app/app
php console doctrine:query:sql "CREATE EXTENSION IF NOT EXISTS \"uuid-ossp\";"
php console doctrine:migrations:status
php console --no-interaction doctrine:migrations:migrate
php console cache:clear --env=prod
php console cache:warmup --env=prod
chown -R www-data:www-data /app/app/cache && find /app/app/cache -type d -exec chmod -R 0770 {} \; && find /app/app/cache -type f -exec chmod -R 0660 {} \;
php console assetic:dump --env=prod

service php7.0-fpm start
nginx -g "daemon off;"
