#!/bin/sh

perl -pi -e "s/br/us/" /etc/apt/sources.list

apt-get update
apt-get upgrade -y

apt-get install -y nfdump

apt-get install -y libapache2-mod-php5   librrds-perl libmailtools-perl rrdtool whois

if [ ! -e /etc/apache2/mods-enabled/rewrite.load ] ; then
    a2enmod rewrite
fi

service apache2 restart
