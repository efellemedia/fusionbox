mkdir -p /etc/httpd/sites-available
mkdir -p /etc/httpd/sites-enabled

LINE='Include sites-enabled/*.conf'
FILE=/etc/httpd/conf/httpd.conf
grep -q "$LINE" "$FILE" || echo "$LINE" >> "$FILE"

rm -f /etc/httpd/sites-enabled/*
rm -f /etc/httpd/sites-available/*
