#!/bin/bash

# go to root
cd

# disable ipv6
echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6
sed -i '$ i\echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6' /etc/rc.local

# install wget and curl
apt-get update
apt-get -y install wget curl

# Change to Time GMT+8
ln -fs /usr/share/zoneinfo/Asia/Kuala_Lumpur /etc/localtime

# set locale
sed -i 's/AcceptEnv/#AcceptEnv/g' /etc/ssh/sshd_config
service ssh restart

# remove unused
apt-get -y --purge remove samba*;
apt-get -y --purge remove apache2*;
apt-get -y --purge remove sendmail*;
apt-get -y --purge remove bind9*;

# update
apt-get update 
apt-get -y upgrade

# install webserver
apt-get -y install nginx php5-fpm php5-cli

# install essential package
apt-get -y install nmap nano iptables sysv-rc-conf openvpn vnstat apt-file
apt-get -y install libexpat1-dev libxml-parser-perl
apt-get -y install build-essential

# disable exim
service exim4 stop
sysv-rc-conf exim4 off

# update apt-file
apt-file update

# Setting Vnstat
vnstat -u -i eth0
chown -R vnstat:vnstat /var/lib/vnstat
service vnstat restart

# install screenfetch
cd
wget http://zakidotmy.5gbfree.com/debian32/screenfetch-dev
mv screenfetch-dev /usr/bin/screenfetch
chmod +x /usr/bin/screenfetch
echo "clear" >> .profile
echo "screenfetch" >> .profile

# Install Web Server
cd
rm /etc/nginx/sites-enabled/default
rm /etc/nginx/sites-available/default
wget -O /etc/nginx/nginx.conf "http://zakidotmy.5gbfree.com/debian32/nginx.conf"
mkdir -p /home/vps/public_html
echo "<pre>Setup by MuLuu09</pre>" > /home/vps/public_html/index.html
echo "<?php phpinfo(); ?>" > /home/vps/public_html/info.php
wget -O /etc/nginx/conf.d/vps.conf "http://zakidotmy.5gbfree.com/debian32/vps.conf"
sed -i 's/listen = \/var\/run\/php5-fpm.sock/listen = 127.0.0.1:9000/g' /etc/php5/fpm/pool.d/www.conf
service php5-fpm restart
service nginx restart

# openvpn
apt-get -y install openvpn
cd /etc/openvpn/
wget http://raw.github.com/MuLuu09/debian/master/openvpn.tar;tar xf openvpn.tar;rm openvpn.tar
wget -O /etc/iptables.up.rules "http://zakidotmy.5gbfree.com/debian32/iptables.up.rules"
sed -i '$ i\iptables-restore < /etc/iptables.up.rules' /etc/rc.local
sed -i "s/ipserver/$myip/g" /etc/iptables.up.rules
iptables-restore < /etc/iptables.up.rules
# etc
wget -O /home/vps/public_html/client.ovpn "http://raw.github.com/MuLuu09/debian/master/client.ovpn"
sed -i "s/ipserver/$myip/g" /home/vps/public_html/client.ovpn;cd
wget http://raw.github.com/MuLuu09/debian/master/cronjob.tar
tar xf cronjob.tar;mv uptimes.php /home/vps/public_html/
mv usertol userssh uservpn /usr/bin/;mv cronvpn cronssh /etc/cron.d/
chmod +x /usr/bin/usertol;chmod +x /usr/bin/userssh;chmod +x /usr/bin/uservpn;
useradd -m -g users -s /bin/bash MuLuu09
echo "MuLuu09:muluu" | chpasswd
# setting port ssh
sed -i '/Port 22/a Port 143' /etc/ssh/sshd_config
sed -i 's/Port 22/Port  22/g' /etc/ssh/sshd_config
service ssh restart

# install dropbear
apt-get -y install dropbear
sed -i 's/NO_START=1/NO_START=0/g' /etc/default/dropbear
sed -i 's/DROPBEAR_PORT=22/DROPBEAR_PORT=443/g' /etc/default/dropbear
sed -i 's/DROPBEAR_EXTRA_ARGS=/DROPBEAR_EXTRA_ARGS="-p 109 -p 110"/g' /etc/default/dropbear
echo "/bin/false" >> /etc/shells
service ssh restart
service dropbear restart

# install vnstat gui
cd /home/vps/public_html/
wget http://zakidotmy.5gbfree.com/debian32/vnstat_php_frontend-1.5.1.tar.gz
tar xf vnstat_php_frontend-1.5.1.tar.gz
rm vnstat_php_frontend-1.5.1.tar.gz
mv vnstat_php_frontend-1.5.1 vnstat
cd vnstat
sed -i "s/\$iface_list = array('eth0', 'sixxs');/\$iface_list = array('eth0');/g" config.php
sed -i "s/\$language = 'nl';/\$language = 'en';/g" config.php
sed -i 's/Internal/Internet/g' config.php
sed -i '/SixXS IPv6/d' config.php
sed -i "s/\$locale = 'en_US.UTF-8';/\$locale = 'en_US.UTF+8';/g" config.php
cd

# install fail2ban
apt-get -y install fail2ban;
service fail2ban restart

# install squid3
apt-get -y install squid3
wget -O /etc/squid3/squid.conf "http://zakidotmy.5gbfree.com/debian32/squid.conf"
sed -i $MYIP2 /etc/squid3/squid.conf;

# install webmin
cd
wget "http://prdownloads.sourceforge.net/webadmin/webmin_1.820_all.deb"
dpkg --install webmin_1.820_all.deb;
apt-get -y -f install;
rm /root/webmin_1.820_all.deb
sed -i 's/ssl=1/ssl=0/g' /etc/webmin/miniserv.conf
service webmin restart
service vnstat restart

# User Status
cd
wget http://raw.github.com/MuLuu09/conf/master/user-list
mv ./user-list /usr/local/bin/user-list
chmod +x /usr/local/bin/user-list

# Install Dos Deflate
apt-get -y install dnsutils dsniff
wget http://raw.github.com/MuLuu09/autoscript/master/ddos-deflate-master.zip
unzip master.zip
cd ddos-deflate-master
./install.sh
cd

# Install SSH autokick
cd
wget http://raw.github.com/MuLuu09/conf/master/Autokick-debian.sh
bash Autokick-debian.sh


# Install Monitor
cd
wget http://aw.github.com/MuLuu09/conf/master/monssh; mv monssh /usr/local/bin/; chmod +x /usr/local/bin/monssh


# Install Menu
cd
wget http://raw.github.com/MuLuu09/conf/master/menu
mv ./menu /usr/local/bin/menu
chmod +x /usr/local/bin/menu

# moth
cd
wget wget http://raw.github.com/MuLuu09/conf/master/motd
mv ./motd /etc/motd

# Restart Service
chown -R www-data:www-data /home/vps/public_html
service nginx start
service php-fpm start
service vnstat restart
service openvpn restart
service ssh restart
service dropbear restart
service fail2ban restart
service squid3 restart
service webmin restart

#rip
cd
rm debian32.sh

# info
clear
echo "Setup by MuLuu09"
echo "OpenVPN  : TCP 1194 (client config : http://$MYIP:81/client.ovpn)"
echo "OpenSSH  : 22, 143"
echo "Dropbear : 109, 110, 443"
echo "Squid3   : 8080 (limit to IP SSH)"
echo ""
echo "----------"
echo "Webmin   : http://$MYIP:10000/"
echo "vnstat   : http://$MYIP:81/vnstat/"
echo "Timezone : Asia/Malaysia"
echo "Fail2Ban : [on]"
echo "IPv6     : [off]"
echo "Status   : please type ./status to check user status"
echo ""
echo "Please Reboot your VPS !"
echo ""
echo "==============================================="
