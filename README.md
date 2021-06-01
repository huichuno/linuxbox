# linuxbox
Build Linux kernel in docker container

# Prerequisite
Install Docker
--------------
sudo apt update && sudo apt -y upgrade

sudo apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  
sudo apt update

sudo apt install docker-ce

sudo usermod -aG docker ${USER}

# Quick Start
git clone https://github.com/huichuno/linuxbox.git

make help

make

sudo make install

# Config
Update REPO_URL, BRANCH, CONFIG_URL, APPEND_VER and REVISION parameters in 'conf' file to the desired value. Refer to 'conf.bionic' and 'conf.focal' files for example.

Example:

REPO_URL=git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git

BRANCH=v5.4.65

CONFIG_URL=https://kernel.ubuntu.com/~kernel-ppa/config/bionic/linux-hwe-5.4/5.4.0-54.60~18.04.1/amd64-config.flavour.generic

APPEND_VER=-gvt

REVISION=3.0.0

# Patches (optional)
Patch files dropped into 'patches/' folder will be applied to target as part of the build process.
File format: *.patch

# Makefile
"make all" (default)

- Run check, build and clean

"make check"

- Check docker is installed

"make build"

- Build qemu artifacts through docker build process

"make clean"

- Delete docker image

"sudo make install"

- Execute install.sh script to install artifacts from build/ folder and perform other operations. Look at install.sh for details.

"make help"

- Print make options

# Debug
make build

docker run -it linux_box:latest bash
