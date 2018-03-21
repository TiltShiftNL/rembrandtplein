#!/usr/bin/env bash

echo Starting server

set -u
set -e

DB_HOST=${SYMFONY__REMBRANDT__DATABASE__HOST:-rembrandtplein-db.service.consul}
DB_PORT=${SYMFONY__REMBRANDT__DATABASE__PORT:-5432}

cat > /app/app/config/parameters.yml <<EOF
parameters:
   database_host: ${DB_HOST}
   database_port: ${DB_PORT}
   database_name: ${SYMFONY__REMBRANDT__DATABASE__NAME}
   database_user: ${SYMFONY__REMBRANDT__DATABASE__USER}
   database_password: ${SYMFONY__REMBRANDT__DATABASE__PASSWORD}
   mailer_transport: ${SYMFONY__REMBRANDT__MAILER__TRANSPORT}
   mailer_host: ${SYMFONY__REMBRANDT__MAILER__HOST}
   mailer_user: ${SYMFONY__REMBRANDT__MAILER__USER}
   mailer_password: ${SYMFONY__REMBRANDT__MAILER__PASSWORD}
   mailer_port: ${SYMFONY__REMBRANDT__MAILER__PORT}
   mailer_encryption: ${SYMFONY__REMBRANDT__MAILER__ENCRYPTION}
   mail_from: ${SYMFONY__REMBRANDT__MAIL__FROM}
   mail_cc: ${SYMFONY__REMBRANDT__MAIL__CC}
   auto_login_from_email: ${SYMFONY__REMBRANDT__AUTO__LOGIN__FROM__EMAIL}
   retention_policy: ${SYMFONY__REMBRANDT__RETENTION__POLICY}
   secret: ${SYMFONY__REMBRANDT__SECRET}
   messagebird_accountkey: ${SYMFONY__REMBRANDT__MESSAGEBIRD__API__KEY}
   messagebird_enable: ${SYMFONY__REMBRANDT__MESSAGEBIRD__ENABLE}
   cmsmsgateway_token: ${SYMFONY__REMBRANDT__CMSMSGATEWAY__TOKEN}
   rembrandtplein.appbundle.services.sms: ${SYMFONY__REMBRANDT__SERVICES}
   sms_originator: ${SYMFONY__REMBRANDT__SMS__ORGINATOR}
   sms_disable: false
   trusted_proxies:
        - 127.0.0.1
        - 10.0.0.0/8
        - 172.16.0.0/12
        - 192.168.0.0/16
EOF


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
