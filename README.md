# IPFS Command Installer

[![Build Status](https://travis-ci.org/joemccann/dillinger.svg?branch=master)](https://travis-ci.org/joemccann/dillinger)

This automated script simplifies the installation process for IPFS (InterPlanetary File System) commands on your system. With just a few simple steps, you can have IPFS commands up and running quickly and efficiently.

## Features

- Ease of use, this script automates the process, saving you time and effort.
- Flexible installation, choose how to run the installation script, online or offline.

## Installation
ipfs-auto-installer requires any Debian distro Linux based. Follow the on-screen prompts to customize installation options as needed, sit back and relax while the installer takes care of the rest.

### Online:
Open a Linux terminal to download and execute a bash script directly from GitHub.
```sh
curl -s https://raw.githubusercontent.com/AndyDevla/ipfs-auto-installer/main/ipfs_basic_install.sh | sudo bash
```
#### or 
```sh
wget -O - https://raw.githubusercontent.com/AndyDevla/ipfs-auto-installer/main/ipfs_basic_install.sh | sudo bash
bash <(wget -qO- https://raw.githubusercontent.com/AndyDevla/ipfs-auto-installer/main/ipfs_basic_install.sh)
sudo su -c "bash <(wget -qO- https://raw.githubusercontent.com/AndyDevla/ipfs-auto-installer/main/ipfs_basic_install.sh)" root
```
### Offline:
Clone this repository to your local machine and execute the script as "sudo" user.
```sh
git clone https://github.com/AndyDevla/ipfs-auto-installer.git
cd ipfs-auto-installer
sudo bash ipfs-auto-installer.sh
```

## Usage:
After installation, you can start using IPFS commands right away. Simply open your terminal or command prompt and type the desired IPFS command.

## License

GNU General Public License v3.0
