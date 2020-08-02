#!/bin/bash
apt-get update -y
apt-get -y install apache2 php7.0 libapache2-mod-php7.0
service apache2 start
service apache2 stop


cat <<EOF > /var/www/html/index.php
<?php
\$hostname = gethostname();
echo "<h2>Hello World!</h2>";
echo "<h2>Server Hostname: \$hostname</h2>";
?>
EOF

rm /var/www/html/index.html

service apache2 start