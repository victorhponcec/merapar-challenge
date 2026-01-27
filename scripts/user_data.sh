#!/bin/bash
set -eux
yum update -y
yum install -y httpd awscli
systemctl enable httpd
systemctl start httpd

mkdir -p /var/www/cgi-bin
chown -R apache:apache /var/www
chmod -R 755 /var/www

# CGI script
cat <<'EOF' > /var/www/cgi-bin/index.cgi
#!/bin/bash
echo "Content-Type: text/html"
echo ""

CONTENT=$(aws dynamodb get-item \
  --region us-east-1 \
  --table-name dynamic-content \
  --key '{"id":{"S":"root"}}' \
  --query "Item.content.S" \
  --output text)

echo "$CONTENT"
EOF

chmod +x /var/www/cgi-bin/index.cgi
chown apache:apache /var/www/cgi-bin/index.cgi

#Enable CGI in httpd.conf
cat <<'EOF' > /etc/httpd/conf.d/cgi-root.conf
# Serve CGI at /cgi-bin
ScriptAlias /cgi-bin/ "/var/www/cgi-bin/"

<Directory "/var/www/cgi-bin">
    AllowOverride None
    Options +ExecCGI
    AddHandler cgi-script .cgi
    Require all granted
</Directory>

# Make / serve the CGI script
<Directory "/var/www/html">
    Options FollowSymLinks
    AllowOverride None
    Require all granted

    RewriteEngine On
    RewriteRule ^/?$ /cgi-bin/index.cgi [L]
</Directory>
EOF

echo "OK" > /var/www/html/health
chown apache:apache /var/www/html/health
chmod 644 /var/www/html/health

httpd -t
systemctl restart httpd
