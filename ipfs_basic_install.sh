#!/bin/bash
echo ''
read -p 'Please, type your current username: ' user_name
echo ''
read -p 'Change max storage capacity in GB: ' max_storage
# echo ''
# But, you might want to skip this one if allowing people to access files through your gateway makes you nervous##
read -p 'Enable as a public gateway? y/n: ' public_access

echo ''
echo '          ╔══════════════════════════════════════════════════════════════╗'
echo '          ║                      Dowloading IPFS                         ║'
echo '          ╚══════════════════════════════════════════════════════════════╝'
echo ''

#wget https://dist.ipfs.tech/kubo/v0.26.0/kubo_v0.26.0_linux-amd64.tar.gz
wget -qO- "https://dist.ipfs.tech/kubo/versions" > versions.txt
versions="versions.txt"
#line=$(grep -- "-rc1" "$versions" | tail -n 1)
#latest=$(grep -B 1 "$line" "$versions" | head -n 1)
latest=$(wget -qO- "https://dist.ipfs.tech/kubo/versions" | grep -- "-rc1" | tail -n 1 | xargs -I {} grep -B 1 {} versions.txt | head -n 1)
wget "https://dist.ipfs.tech/kubo/${latest}/kubo_${latest}_linux-amd64.tar.gz"
rm versions.txt

echo '          ╔══════════════════════════════════════════════════════════════╗'
echo '          ║                      Installing IPFS                         ║'
echo '          ╚══════════════════════════════════════════════════════════════╝'
echo ''

tar -xvzf "kubo_${latest}_linux-amd64.tar.gz"
rm "kubo_${latest}_linux-amd64.tar.gz"
cd kubo 
sudo bash install.sh
cd .. 
rm -rf kubo
#ipfs --version 

# echo 'export IPFS_PATH=/data/ipfs' >>~/.bashrc
# source ~/.bashrc
# sudo mkdir -p $IPFS_PATH
# sudo chown $user:$user $IPFS_PATH

echo ''
echo '          ╔══════════════════════════════════════════════════════════════╗'
echo '          ║                   Initiating repository                      ║'
echo '          ╚══════════════════════════════════════════════════════════════╝'
echo ''

# sudo -u ${user_name} ipfs init
sudo -u ${user_name} ipfs init --profile server
sudo -u ${user_name} ipfs config Datastore.StorageMax "${max_storage}GB"
# comment the line below if you don't want direct access to the instance's gateway from outside


#if [ "$public_access" = "y" ]; then
#   ipfs config Addresses.Gateway /ip4/0.0.0.0/tcp/8080
#   echo "Public gateway enabled."
#else
#    ipfs config Addresses.Gateway /ip4/127.0.0.1/tcp/8080
#    echo "Public gateway disabled."
#fi

sudo -u ${user_name} ipfs id | head -n 3 | tail -n 2 > IPFS_identity.txt

echo ''
echo '          ╔══════════════════════════════════════════════════════════════╗'
echo '          ║                   Creating ipfs.service                      ║'
echo '          ╚══════════════════════════════════════════════════════════════╝'
echo ''

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
User='"$user_name"'
Group='"$user_name"'
[Install]
WantedBy=default.target
EOL'
# =======================================================
sudo systemctl daemon-reload
# sudo systemctl enable ipfs.service
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

echo ''
echo '          ╔══════════════════════════════════════════════════════════════╗'
echo '          ║              All done, restarting ipfs.service               ║'
echo '          ╚══════════════════════════════════════════════════════════════╝'
echo ''
