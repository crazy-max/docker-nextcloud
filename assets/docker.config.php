<?php
$CONFIG = array (
    'dbtype' => 'mysql',
    'dbhost' =>  getenv('MYSQL_HOST'),
    'dbname' => getenv('MYSQL_DATABASE'),
    'dbuser' => getenv('MYSQL_USER'),
    'dbpassword' => getenv('MYSQL_PASSWORD'),
    'mail_smtpmode' => 'php',
    'mail_from_address' => 'nextcloud',
    'mail_smtpauthtype' => 'LOGIN',
    'memcache.locking' => '\OC\Memcache\Redis',
    'redis' => array(
        'host' => 'redis',
        'port' => 6379,
    ),
);
