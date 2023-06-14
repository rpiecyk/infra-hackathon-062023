## install jdk
sudo apt-get update
sleep 2
sudo apt-get purge openjdk-\* -y
sleep 2
sudo apt-get install openjdk-18-jdk -y
# Add a user & set default passwd - changed later on
sudo useradd -m -s /bin/bash -p $(echo "admin" | openssl passwd -1 stdin) zkadmin
# Add zkadmin user to sudoers
sudo usermod -aG sudo zkadmin
#switch to zkadmin user for the rest of the setup
su -l zkadmin
sudo mkdir -p /data/zookeeper
sudo chown -R zkadmin:zkadmin /data/zookeeper
cd /opt
sudo wget https://dlcdn.apache.org/zookeeper/zookeeper-3.6.4/apache-zookeeper-3.6.4-bin.tar.gz
sudo tar -xvf apache-zookeeper-3.6.4-bin.tar.gz
sudo mv /tmp/zoo.cfg apache-zookeeper-3.6.4-bin/conf/
sudo chown zkadmin:zkadmin -R apache-zookeeper-3.6.4-bin
sudo ln -s /opt/apache-zookeeper-3.6.4-bin/* /opt/zookeeper/
sudo chown -h zkadmin:zkadmin -R /opt/zookeeper
#sudo systemctl enable zookeeper.service