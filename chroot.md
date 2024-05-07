Schroot Setup

## Package caching (optional)

Install the caching proxy

```bash
sudo apt-get -y install apt-cacher-ng
```

Add an override for configuration

```bash
sudo tee /etc/apt-cacher-ng/zz_override.conf  >/dev/null <<EOF
Port:3142
BindAddress: 127.0.0.1
ExThreshold: 7
PassThroughPattern: .*
EOF
```

Enable the proxy

```bash
if [ -z ${WSL_DISTRO_NAME} ]; then
    sudo update-rc.d -f apt-cacher-ng defaults
    sudo update-rc.d -f apt-cacher-ng enable
else
    sudo sed -zi '/\[boot\]/!s/$/\n\[boot\]\n/' /etc/wsl.conf
    sudo sed -i '/\[boot\]/acommand=\"/etc/init.d/apt-cacher-ng restart;\"\n' /etc/wsl.conf
fi
```

Start the daemon

```bash
sudo /etc/init.d/apt-cacher-ng start
sudo /etc/init.d/apt-cacher-ng status
```

# Bootstrap filesystem

## Install

```bash
sudo apt-get install debootstrap
```

## Prebuild tasks

Some recent updates have removed numerous links from the deployment package.  We can add those back before we build our environment.

```bash
cd /usr/share/debootstrap/scripts
for DISTRO in artful bionic cosmic disco eoan focal groovy hardy hirsute impish intrepid jammy jaunty karmic kinetic lucid lunar mantic maverick natty noble oneiric precise quantal raring saucy utopic vivid wily xenial yakkety zesty
do
    if [ ! -L ${DISTRO} ]; then
        sudo ln -v -s gutsy ${DISTRO}
    else
        echo "'${DISTRO}' already exists"
    fi
done
for DISTRO in bookworm bullseye buster jessie squeeze stretch trixie trusty wheezy
do
    if [ ! -L ${DISTRO} ]; then
        sudo ln -v -s sid ${DISTRO}
    else
        echo "'${DISTRO}' already exists"
    fi
done
for DISTRO in lenny
do
    if [ ! -L ${DISTRO} ]; then
        sudo ln -v -s etch ${DISTRO}
    else
        echo "'${DISTRO}' already exists"
    fi
done
cd ~
```

## Building filesystem

If you have set up the caching proxy, make sure you have the environment variables set before running the bootstrap.

```bash
export DEBOOTSTRAP_PROXY="http://localhost:3142/"
export http_proxy="http://localhost:3142"
export ftp_proxy="http://localhost:3142"
```

Build the bootstrap file system.  It must be run using with the "-E" parameter to make sure that the proxy variables are passed correctly.  This is not required if it is being run from a script.

```bash
sudo mkdir -pv /chroot/
```

```bash
sudo -E debootstrap \
    --arch=amd64 \
    --variant=minbase \
    --include=ubuntu-minimal,build-essential,git \
    focal \
    /chroot/focal-amd64/
```

The required files should be download and installed in the correct location.

# ## chroot access

Install the schroot command to help manage access to the bootstrapped environment 

```bash
sudo apt-get -y install schroot
```

Create a configuration file for the new environment

```bash
sudo vi /etc/schroot/chroot.d/focal-amd64.conf
```

```bash
[focal-amd64]
aliases=focal64
description=Ubuntu Focal (20.04)
profile=default
type=directory
directory=/chroot/focal-amd64
message-verbosity=normal
users=ubuntu
groups=adm
root-users=ubuntu
root-groups=adm
personality=linux
preserve-environment=false
#command-prefix=eatmydata
```

## Post-Build tasks

```bash
schroot -c focal-amd64 -u root -- <<EOF
if [ ! -f /etc/profile.d/05-environment.sh ]; then
cat >> /etc/profile.d/05-environment.sh << SCRIPT
    export http_proxy='http://localhost:3142'
    export HTTP_PROXY='http://localhost:3142'
    export https_proxy='http://localhost:3142'
    export HTTPS_PROXY='http://localhost:3142'
    export ftp_proxy='http://localhost:3142'
    export FTP_PROXY='http://localhost:3142'
    export no_proxy='localhost,127.0.0.1'
    export NO_PROXY='localhost,127.0.0.1'
SCRIPT
fi
EOF
```

install additional packages like git, vim

```bash
schroot -c focal-amd64 -u root -- <<EOF
    sudo apt update
    apt-get -y \
        --no-install-recommends \
        --no-install-suggests \
        install software-properties-common 2>/dev/null
    echo '' > /etc/apt/sources.list
    add-apt-repository --no-update --yes \
        "deb http://gb.archive.ubuntu.com/ubuntu/ \$(lsb_release -sc) \
        main restricted universe multiverse" 2>/dev/null
    add-apt-repository --no-update --yes \
        "deb http://gb.archive.ubuntu.com/ubuntu/ \$(lsb_release -sc)-updates \
        main restricted universe multiverse" 2>/dev/null
    add-apt-repository --no-update --yes \
        "deb http://gb.archive.ubuntu.com/ubuntu/ \$(lsb_release -sc)-backports \
        main restricted universe multiverse" 2>/dev/null
    add-apt-repository --no-update --yes \
        "deb http://gb.archive.ubuntu.com/ubuntu/ \$(lsb_release -sc)-security \
        main restricted universe multiverse" 2>/dev/null
    echo
    cat /etc/apt/sources.list
    echo
    apt-get update
EOF
```

If this chroot is to be used for compiling and packaging then enable the source repositories is recomended

```bash
schroot -c focal-amd64 -u root -- <<EOF
    sed -i '/deb-src/s/^# //' /etc/apt/sources.list
    echo
    cat /etc/apt/sources.list
    echo
    apt-get update
EOF
```

Install any missing or required packages

```bash
schroot -c focal-amd64 -u root -- <<EOF
    apt-get update 
    apt-get -y install vim ssh wget curl
    apt-get -y --fix-broken install
EOF
```

Bring the system up to the latest patch level

```bash
schroot -c focal-amd64 -u root -- <<EOF
    apt-get clean
    apt-get update
    apt-get -y dist-upgrade
    apt-get -y purge
    apt-get -y --purge autoremove
EOF
```

More stuff goes here....
