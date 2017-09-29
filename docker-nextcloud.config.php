<?php
$CONFIG = array (
    'dbtype' => 'mysql',
    'dbhost' => 'db:3306',
    'mail_smtpmode' => 'postfix',
    'mail_smtphost' => 'postfix',
    'mail_smtpport' => '25',
    'memcache.locking' => '\OC\Memcache\Redis',
    'redis' => array(
        'host' => 'redis',
        'port' => 6379,
    ),
);
