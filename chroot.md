Schroot Setup

## Package caching (optional)

sudo apt-get install apt-cacher-ng

Enable and start the proxy service

sudo update-rc.d -f apt-cacher-ng defaults

sudo update-rc.d -f apt-cacher-ng enable

sudo /etc/init.d/apt-cacher-ng start

sudo /etc/init.d/apt-cacher-ng status

Replace any missing sylinks dropped in recent updates:

cd /usr/share/debootstrap/scripts

for DISTRO in artful bionic cosmic disco eoan focal groovy hardy hirsute impish intrepid jammy jaunty karmic kinetic lucid lunar mantic maverick natty noble oneiric precise quantal raring saucy utopic vivid wily xenial yakkety zesty

do

    if [ ! -L {DISTRO} ]; then

    sudo ln -v -s gutsy {DISTRO}

    else

    echo "'${DISTRO}' already exists"

 fi

done

for DISTRO in bookworm bullseye buster jessie squeeze stretch trixie trusty wheezy

do

if [ ! -L {DISTRO} ]; then

sudo ln -v -s sid {DISTRO}

else

echo "'${DISTRO}' already exists"

fi

done

for DISTRO in lenny

do

if [ ! -L {DISTRO} ]; then

sudo ln -v -s etch {DISTRO}

else

echo "'${DISTRO}' already exists"

fi

done

Download the bootstrap file system



export DEBOOTSTRAP_PROXY="http://localhost:3142/"

export http_proxy="http://localhost:3142"

export ftp_proxy="http://localhost:3142"



`sudo -E debootstrap \
--arch=amd64 \
--variant=minbase \
--components=main,universe,restricted,multiverse \
--include=ubuntu-minimal,build-essential,git \
focal \
/chroot/focal-amd64/ \
http://archive.ubuntu.com/ubuntu/`



te




