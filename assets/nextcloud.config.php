<?php
$CONFIG = array (
    'dbtype' => 'mysql',
    'dbhost' => 'db:3306',
    'mail_smtpmode' => 'php',
    'memcache.locking' => '\OC\Memcache\Redis',
    'redis' => array(
        'host' => 'redis',
        'port' => 6379,
    ),
);
