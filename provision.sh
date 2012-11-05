#!/bin/sh

perl -pi -e "s/br/us/" /etc/apt/sources.list

apt-get update
apt-get upgrade -y

apt-get install -y nfdump

apt-get install -y libapache2-mod-php5   librrds-perl libmailtools-perl libsocket6-perl rrdtool whois

if [ ! -e /etc/apache2/mods-enabled/rewrite.load ] ; then
    a2enmod rewrite
    service apache2 restart
fi


if [ ! -e nfsen-1.3.6p1.tar.gz ] ; then
    wget http://iweb.dl.sourceforge.net/project/nfsen/stable/nfsen-1.3.6p1/nfsen-1.3.6p1.tar.gz
    tar xvzf nfsen-1.3.6p1.tar.gz
fi

mkdir -p /data/nfsen

if [ ! -e /var/www/nfsen ] ; then 
    cd nfsen-1.3.6p1/
    yes ''| ./install.pl /vagrant_data/nfsen.conf
    cd /var/www/nfsen
    ln -s nfsen.php index.php
fi

/data/nfsen/bin/nfsen stop
/data/nfsen/bin/nfsen start

#setup fprobe

echo "fprobe fprobe/collector string localhost:9995" | debconf-set-selections
echo "fprobe fprobe/interface string eth0" | debconf-set-selections

DEBIAN_FRONTEND=noninteractive apt-get -y install fprobe
