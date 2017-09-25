#!/bin/sh

STAMP=$(date)

# execute any pre-init scripts, useful for images
# based on this image
for i in /scripts/pre-init.d/*sh
do
	if [ -e "${i}" ]; then
		echo "[${STAMP}] pre-init.d - processing $i"
		. "${i}"
	fi
done

# set apache as owner/group
if [ "$FIX_OWNERSHIP" != "" ]; then
	chown -R apache:apache /app
fi

# execute any pre-exec scripts, useful for images
# based on this image
for i in /scripts/pre-exec.d/*sh
do
	if [ -e "${i}" ]; then
		echo "[${STAMP}] pre-exec.d - processing $i"
		. "${i}"
	fi
done

# run apache httpd daemon
echo "[${STAMP}] Starting daemon..."
echo "----====="
whoami
echo "---------"
apk add --allow-untrusted --force /packages/apache2-2.4.27-r1.apk

echo "---------"
which httpd
echo "---------"
find / -name httpd
echo "---------"
ls -l /packages
echo "---------"
apk info
echo "---------"
apk info apache2
echo "---------"
cat /etc/apk/repositories
echo "---------"
# httpd -D FOREGROUND

