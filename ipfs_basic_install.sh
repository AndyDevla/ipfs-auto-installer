#!/bin/bash
sleep 2
echo ''
read -p 'Please, type your current username: ' user_name
sleep 1
echo ''
read -p 'Change max storage capacity in GB: ' max_storage
# echo ''
# But, you might want to skip this one if allowing people to access files through your gateway makes you nervous##
# echo 'Enable as a public gateway? y/n'
# read public_access
sleep 2
echo ''
echo '          ╔══════════════════════════════════════════════════════════════╗'
echo '          ║                      Dowloading IPFS                         ║'
echo '          ╚══════════════════════════════════════════════════════════════╝'
echo ''
sleep 2
wget https://dist.ipfs.tech/kubo/v0.26.0/kubo_v0.26.0_linux-amd64.tar.gz
sleep 2
echo '          ╔══════════════════════════════════════════════════════════════╗'
echo '          ║                      Installing IPFS                         ║'
echo '          ╚══════════════════════════════════════════════════════════════╝'
echo ''
sleep 2
tar -xvzf kubo_v0.26.0_linux-amd64.tar.gz
rm kubo_v0.26.0_linux-amd64.tar.gz
cd kubo 
sudo bash install.sh
cd .. 
#ipfs --version 

# echo 'export IPFS_PATH=/data/ipfs' >>~/.bashrc
# source ~/.bashrc
# sudo mkdir -p $IPFS_PATH
# sudo chown $user:$user $IPFS_PATH
sleep 2
echo ''
echo '          ╔══════════════════════════════════════════════════════════════╗'
echo '          ║                   Initiating repository                      ║'
echo '          ╚══════════════════════════════════════════════════════════════╝'
echo ''

# sudo -u dellmer ipfs init --profile server
sudo -u ${user_name} ipfs init --profile server

sudo -u ${user_name} ipfs config Datastore.StorageMax "${max_storage}GB"
# comment if you don't want direct access to the instance's gateway from outside
sudo -u ${user_name} ipfs config Addresses.Gateway /ip4/0.0.0.0/tcp/8080
sudo -u ${user_name} ipfs id | head -n 3 | tail -n 2 > IPFS_identity.txt

echo ''
echo '          ╔══════════════════════════════════════════════════════════════╗'
echo '          ║                   Creating ipfs.service                      ║'
echo '          ╚══════════════════════════════════════════════════════════════╝'
echo ''
sleep 2
# ===================copy & paste all below =============
sudo bash -c 'cat >/etc/systemd/system/ipfs.service <<EOL
[Unit]
Description=IPFS Service
After=network.target
Before=nextcloud-web.service
[Service]
ExecStart=/usr/local/bin/ipfs daemon --enable-gc
ExecReload=/usr/local/bin/ipfs daemon --enable-gc
Restart=on-failure
User=dellmer
Group=dellmer
[Install]
WantedBy=default.target
EOL'
# =======================================================
sudo systemctl daemon-reload
sudo systemctl start ipfs.service 
sudo systemctl status ipfs.service 

#echo ''
#echo '          ╔══════════════════════════════════════════════════════════════╗'
#echo '          ║                     Installing nginx                         ║'
#echo '          ╚══════════════════════════════════════════════════════════════╝'
#echo ''

#sudo apt install nginx -y
#echo ''
#echo '          ╔══════════════════════════════════════════════════════════════╗'
#echo '          ║                  Checking nginx.service                      ║'
#echo '          ╚══════════════════════════════════════════════════════════════╝'
#echo ''
#sudo systemctl status nginx

#sudo nginx -s reload

# ipfs config Addresses.Swarm '["/ip4/0.0.0.0/tcp/4001", "/ip4/0.0.0.0/tcp/8081/ws", "/ip6/::/tcp/4001"]' --json
# try to ignore the next entry
# ipfs config --bool Swarm.EnableRelayHop false

sudo systemctl restart ipfs.service

sleep 2
echo ''
echo '          ╔══════════════════════════════════════════════════════════════╗'
echo '          ║              All done, restarting ipfs.service               ║'
echo '          ╚══════════════════════════════════════════════════════════════╝'
echo ''
sleep 3