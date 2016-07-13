mkdir -p /etc/supervisor

BLOCK="[include]
files = supervisor/*.conf"

FILE=/etc/supervisord.conf
grep -q "$BLOCK" "$FILE" || echo "$BLOCK" >> "$FILE"

rm -f /etc/supervisor/*
