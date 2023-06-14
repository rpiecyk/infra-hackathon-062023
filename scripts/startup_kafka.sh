#!/bin/bash

# Get broker ID
export NODE_NAME=$(curl "http://metadata.google.internal/computeMetadata/v1/instance/name" -H "Metadata-Flavor: Google")
export BROKER_ID=$(expr  $(echo $${NODE_NAME: -1}) - 1)
sudo sed -i "s/broker.id=0/broker.id=$${BROKER_ID}/g" /data/kafka/config/server.properties

# Set node IP
export NODE_IP=$(curl "http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/ip" -H "Metadata-Flavor: Google")
sudo sed -i "s/10.0.101.20/$${NODE_IP}/g" /data/kafka/config/server.properties

# Set zookeeper connection
sudo sed -i "s/10.0.101.10:2181/${zookeeper_nodes}/g" /data/kafka/config/server.properties

# Bind disk
DISK_ID=/dev/disk/by-id/google-stateful-disk
MNT_DIR=/data/kafka/logs
if [[ $(lsblk $$DISK_ID -no fstype) != 'ext4' ]]; then
          sudo mkfs.ext4 -m 0 -F -E lazy_itable_init=0,lazy_journal_init=0,discard $$DISK_ID
else
    sudo e2fsck -fp $$DISK_ID
    sudo resize2fs $$DISK_ID
fi
if [[ ! $(grep -qs "$$MNT_DIR " /proc/mounts) ]]; then
    if [[ ! $(grep -qs "$$MNT_DIR " /etc/fstab) ]]; then
        UUID=$(blkid -s UUID -o value $$DISK_ID)
        echo "UUID=$$UUID $$MNT_DIR ext4 discard,defaults,nofail 0 2" | sudo tee -a /etc/fstab
    fi
    cp -r $$MNT_DIR /tmp/data/kafka/logs
    systemctl daemon-reload
    sudo mount $$MNT_DIR
    cp -r /tmp/data/kafka/logs/* $$MNT_DIR
fi

# Start service
sudo systemctl start kafka.service