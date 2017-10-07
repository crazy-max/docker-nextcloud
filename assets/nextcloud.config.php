<?php
$CONFIG = array (
    'dbtype' => 'mysql',
    'dbhost' => 'db:3306',
    'dbname' => '{{ MYSQL_DATABASE }}',
    'dbport' => '',
    'dbuser' => '{{ MYSQL_USER }}',
    'dbpassword' => '{{ MYSQL_PASSWORD }}',
    'mail_smtpmode' => 'php',
    'mail_from_address' => 'nextcloud',
    'mail_smtpauthtype' => 'LOGIN',
    'memcache.locking' => '\OC\Memcache\Redis',
    'redis' => array(
        'host' => 'redis',
        'port' => 6379,
    ),
);
