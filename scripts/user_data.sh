#!/bin/bash
set -e

echo 'Acquire::ForceIPv4 "true";' > /etc/apt/apt.conf.d/99force-ipv4

apt update -y
apt install -y apache2

systemctl start apache2
systemctl enable apache2

cat <<EOF > /var/www/html/index.html
<h1>Root page from $(hostname -f)</h1>
EOF

mkdir -p /var/www/html/admin
cat <<EOF > /var/www/html/admin/index.html
<h1>Admin page from $(hostname -f)</h1>
EOF

cat <<EOF > /var/www/html/health
OK
EOF

chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html
