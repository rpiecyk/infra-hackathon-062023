## install jdk
sudo apt-get update
sleep 2
sudo apt-get purge openjdk-\* -y
sleep 2
sudo apt-get install openjdk-18-jdk -y
# Add a user
sudo useradd -m -s /bin/bash -p $(echo "admin" | openssl passwd -1 stdin) kafka
# Add kafka user to sudoers
sudo usermod -aG sudo kafka
# make a dir
sudo mkdir -p /data/kafka/logs
cd /data/kafka
# Download binaries
sudo wget https://dlcdn.apache.org/kafka/3.5.0/kafka_2.13-3.5.0.tgz
sudo tar -xvzf kafka_2.13-3.5.0.tgz --strip 1
sudo chown -R kafka:kafka /data/kafka
