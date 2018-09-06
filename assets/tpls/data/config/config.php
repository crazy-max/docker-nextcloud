<?php

$CONFIG = array(
    'datadirectory' => '/data/data',
    'tempdirectory' => '/data/tmp',
    'supportedDatabases' => array(
        'sqlite',
        'mysql',
        'pgsql'
    ),
    'logtimezone' => '@TZ@',
    'logdateformat' => 'Y-m-d H:i:s',
    'memcache.local' => '\OC\Memcache\APCu',
    'apps_paths' => array(
        array(
            'path'=> '/var/www/apps',
            'url' => '/apps',
            'writable' => false,
        ),
        array(
            'path'=> '/data/userapps',
            'url' => '/userapps',
            'writable' => true,
        ),
    ),
    'mail_smtpmode' => 'smtp'
);
