<?php
use Symfony\Component\Yaml\Yaml;

/** @var $container \Symfony\Component\DependencyInjection\ContainerBuilder */
$container;

$params = [
    'database_host' => getenv('SYMFONY__REMBRANDT__DATABASE__HOST'),
    'database_port' => getenv('SYMFONY__REMBRANDT__DATABASE__PORT'),
    'database_name' => getenv('SYMFONY__REMBRANDT__DATABASE__NAME'),
    'database_user' => getenv('SYMFONY__REMBRANDT__DATABASE_USER'),
    'database_password' => getenv('SYMFONY__REMBRANDT__DATABASE_PASSWORD'),
    'mailer_transport' => getenv('SYMFONY__REMBRANDT__MAILER_TRANSPORT'),
    'mailer_host' => getenv('SYMFONY__REMBRANDT__MAILER_HOST'),
    'mailer_user' => getenv('SYMFONY__REMBRANDT__MAILER_USER'),
    'mailer_password' => getenv('SYMFONY__REMBRANDT__MAILER_PASSWORD'),
    'mailer_encryption' => getenv('SYMFONY__REMBRANDT__MAILER_ENCRYPTION'),
    'secret' => getenv('SYMFONY__REMBRANDT__SECRET'),
    'app_messagebird_key' => getenv('SYMFONY__REMBRANDT__APP_MESSAGEBIRD_KEY'),
    'messagebird_sms_originator' => getenv('SYMFONY__REMBRANDT__SMS__ORGINATOR'),
    'piwik_site_id' => getenv('SYMFONY__REMBRANDT__PIWIK_SITE_ID'),
    'app_phone_enabled' => getenv('SYMFONY__REMBRANDT__APP_PHONE_ENABLED')
];

foreach ($params as $key => $value) {
    $container->setParameter($key, $value);
}
