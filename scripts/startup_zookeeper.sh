#!/bin/bash

# Get node ID
export NODE_NAME=$(curl "http://metadata.google.internal/computeMetadata/v1/instance/name"   -H "Metadata-Flavor: Google")
sudo echo "$${NODE_NAME: -1}" >> /data/zookeeper/myid
sudo chown -h zkadmin:zkadmin /data/zookeeper/myid

# Bind disk
DISK_ID=/dev/disk/by-id/google-stateful-disk
MNT_DIR=/data
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
    cp -r $$MNT_DIR /tmp/data
    systemctl daemon-reload
    sudo mount $$MNT_DIR
    cp -r /tmp/data/* $$MNT_DIR
fi

# Add all zk nodes to cfg file
grep server.1 /opt/zookeeper/conf/zoo.cfg >/dev/null &&\
cat << EOF >> /opt/zookeeper/conf/zoo.cfg
server.1=zookeeper-1.${region}-b.c.${project_id}.internal:2888:3888
server.2=zookeeper-2.${region}-c.c.${project_id}.internal:2888:3888
server.3=zookeeper-3.${region}-d.c.${project_id}.internal:2888:3888
EOF

# Enable & start service
sudo systemctl enable zookeeper.service
sudo systemctl start zookeeper.service