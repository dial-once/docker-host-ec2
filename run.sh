#!/bin/sh
if [ -f /data/authorized_keys ] && [ -w /data/authorized_keys ]; then
  echo 'Generating rsa...'
  ssh-keygen -t rsa -b 4096 -C "updatebot@localhost" -q -N "" -f /root/.ssh/id_rsa
else
  echo 'You have to mount with rw permission the host authorized_keys in /data/authorized_keys'
  exit 1;
fi

#add newly generated rsa to authorized_keys
cat /root/.ssh/id_rsa.pub >> /data/authorized_keys

if [ -n "$DOCKERCLOUD_NODE_FQDN" ]; then
  HOSTNAME=$DOCKERCLOUD_NODE_FQDN
fi

#update and upgrade
scp -o StrictHostKeyChecking=no /configure.sh $HOST_USR@$HOSTNAME:/data/config.sh
ssh -o StrictHostKeyChecking=no $HOST_USR@$HOSTNAME 'sh /data/config.sh'

#remove generated rsa from authorized keys
sort /root/.ssh/id_rsa.pub /data/authorized_keys | uniq -u > output
cat output > /data/authorized_keys