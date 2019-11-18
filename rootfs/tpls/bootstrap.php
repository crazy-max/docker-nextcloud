<?php

include '/data/config/config.php';

$CONFIG['logtimezone'] = '@TZ@';
$CONFIG['logdateformat'] = 'Y-m-d H:i:s';

echo "<?php\n\n\$CONFIG = ";
var_export($CONFIG);
echo ";\n";
