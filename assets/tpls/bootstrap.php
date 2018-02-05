<?php

include '/data/config/config.php';

$CONFIG['logtimezone'] = '@TZ@';
$CONFIG['logdateformat'] = 'Y-m-d H:i:s';

$CONFIG['mail_smtpmode'] = 'php';
$CONFIG['mail_smtpauthtype'] = 'LOGIN';
$CONFIG['mail_smtpauth'] = false;

echo "<?php\n\n\$CONFIG = ";
var_export($CONFIG);
echo ";\n";
