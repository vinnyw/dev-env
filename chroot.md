Schroot Setup

## Package caching (optional)

sudo apt-get install apt-cacher-ng

Enable and start the proxy service

sudo update-rc.d -f apt-cacher-ng defaults

sudo update-rc.d -f apt-cacher-ng enable

sudo /etc/init.d/apt-cacher-ng start

sudo /etc/init.d/apt-cacher-ng status

Replace any missing sylinks dropped in recent updates:

# Bootstrap filesystem

## Install

```
sudo apt-get install debbootstrap
```

## Prebuild tasks

Some recent updates have removed numerous links from the deployment package.  We can add those back before we build our environment.

```
cd /usr/share/debootstrap/scripts
```

```bash
for DISTRO in artful bionic cosmic disco eoan focal groovy hardy hirsute impish intrepid jammy jaunty karmic kinetic lucid lunar mantic maverick natty noble oneiric precise quantal raring saucy utopic vivid wily xenial yakkety zesty
do
    if [ ! -L ${DISTRO} ]; then
        sudo ln -v -s gutsy ${DISTRO}
    else
        echo "'${DISTRO}' already exists"
    fi
done
```

```bash
for DISTRO in bookworm bullseye buster jessie squeeze stretch trixie trusty wheezy
do
    if [ ! -L ${DISTRO} ]; then
        sudo ln -v -s sid {DISTRO}
    else
        echo "'${DISTRO}' already exists"
    fi
done
```

```bash
for DISTRO in lenny
do
    if [ ! -L ${DISTRO} ]; then
        sudo ln -v -s etch ${DISTRO}
    else
        echo "'${DISTRO}' already exists"
    fi
done
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
sudo -E debootstrap \
--arch=amd64 \
--variant=minbase \
--include=ubuntu-minimal,build-essential,git \
focal \
/chroot/focal-amd64/
```

The required file should be download and installed in the correct location.

## Post-Build tasks



add proxy settings to envitoment of chroot 



install additional pacakges like git, vim





sudo apt-get -y --no-install-recommends --no-install-suggests install software-properties-common

```bash
sudo add-apt-repository -n -y \
    "deb http://gb.archive.ubuntu.com/ubuntu/ $(lsb_release -sc) \
    main restricted universe multiverse"
sudo add-apt-repository -n -y \
    "deb http://gb.archive.ubuntu.com/ubuntu/ $(lsb_release -sc)-updates \
    main restricted universe multiverse"
sudo add-apt-repository -n -y 
    "deb http://gb.archive.ubuntu.com/ubuntu/ $(lsb_release -sc)-backports \
    main restricted universe multiverse"
sudo add-apt-repository -n -y \
    "deb http://gb.archive.ubuntu.com/ubuntu/ $(lsb_release -sc)-security \
    main restricted universe multiverse"
```

```bash
schroot -c focal-amd64 -u root -- <<EOF
   apt-get clean
    apt-get update
    apt-get -y dist-upgrade
    apt-get -y purge
    apt-get -y --purge autoremove
EOF
```
