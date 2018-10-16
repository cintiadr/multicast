#!/bin/bash

# Setup the hostname on the avahi config
sed -r "s/(host-name=).*/\1${MDNS_HOSTNAME}/g" -i /etc/avahi/avahi-daemon.conf

cd /multicast
cp .config.template .config

sed -r "s/\"username\"/\"${MONGO_USERNAME}\"/g" -i .config
sed -r "s/\"password\"/\"${MONGO_PWD}\"/g" -i .config
sed -r "s/\"1234ABCD\"/\"${APP_ID}\"/g" -i .config
sed -r "s/\"127.0.0.1\"/\"${MONGO_HOST}\"/g" -i .config

ARGS=""
if [[ "${CONNECT_DEVICES}" == "false" ]]; then
  ARGS="--serve-only"
fi

# Required services for mDNS to work on debian
/etc/init.d/dbus start
/etc/init.d/avahi-daemon start

/wait-for-it.sh ${MONGO_HOST}:27017 --timeout=60 --strict -- echo "Mongodb is up"

# Some logging
echo
echo 'Starting multicast server'
echo "http://${MDNS_HOSTNAME}.local"

sleep 3
node . ${ARGS}
