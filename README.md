<a name="readme-top"></a>

# linuxbox

Build Linux kernel in docker container


## Prerequisite

* Install Docker
  ```sh
  sudo apt update && sudo apt -y upgrade

  sudo apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release

  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/  keyrings/docker-archive-keyring.gpg

  echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.  docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list   > /dev/null

  sudo apt update

  sudo apt install docker-ce

  sudo usermod -aG docker ${USER}
  ```
* If you are operating behind corporate firewall, setup the proxy settings before continue. Add the followings command to Dockerfile
  ```sh
  git config --global http.proxy <proxy server>:<port>
  git config --global https.proxy <proxy server>:<port>
  ```

<p align="right">(<a href="#readme-top">back to top</a>)</p>


## Quick Start

```sh
git clone https://github.com/huichuno/linuxbox.git

make help

make

make install
```

<p align="right">(<a href="#readme-top">back to top</a>)</p>


## Configuration

*REPO_URL*, *BRANCH*, *CONFIG_URL* and *LOCAL_VERSION* parameters in ***conf*** file are consumed by Linux kernel building process. *GRUB_CMDLINE*, *LOAD_MODULES*, *PRE_RUN* and *POST_RUN* parameters are used by the installation process

Example:

```sh
REPO_URL=https://github.com/intel/linux-intel-lts.git

BRANCH=lts-v5.15.44-adl-linux-220616T112508Z

CONFIG_URL=kernel-config/x86_64_defconfig

LOCAL_VERSION=-lts2022

GRUB_CMDLINE="i915.enable_guc=0x7 udmabuf.list_limit=8192 intel_iommu=on i915.force_probe=* console=ttyS0,115200n8"

LOAD_MODULES="vfio-pci i2c-algo-bit"

PRE_RUN="misc/download_adl_firmware.sh"

POST_RUN=
```

<p align="right">(<a href="#readme-top">back to top</a>)</p>


## Patches (optional)

Patch files dropped into *patches/* folder will be applied to target as part of the build process.
File format: *.patch

<p align="right">(<a href="#readme-top">back to top</a>)</p>


## Makefile

"make all" (default)

- Run check, build and clean

"make check"

- Check docker is installed

"make build"

- Build Linux kernel in container

"make clean"

- Cleanup

"make install"

- Execute install.sh script to install artifacts from build/ folder and perform other operations. Look at install.sh for details.

"make help"

- Print make options

<p align="right">(<a href="#readme-top">back to top</a>)</p>


## Debugging

make build

docker run -it linux_box:latest bash

<p align="right">(<a href="#readme-top">back to top</a>)</p>