#!/bin/bash

mv /etc/apt/sources.list /etc/apt/sources.list.backup

cat > /etc/apt/sources.list <<END
deb http://ftp.us.debian.org/debian lenny main contrib non-free
deb http://ftp.debian.org/debian lenny main contrib non-free
deb http://volatile.debian.org/debian-volatile lenny/volatile main contrib non-free
deb http://security.debian.org/ lenny/updates main contrib non-free
deb http://packages.dotdeb.org stable all
deb-src http://packages.dotdeb.org stable all
END

gpg --keyserver keys.gnupg.net --recv-key 89DF5277
gpg -a --export 89DF5277 | apt-key add -

apt-get update

wget http://github.com/lowendbox/lowendscript/raw/master/setup-debian.sh

bash setup-debian.sh system

bash setup-debian.sh exim4

bash setup-debian.sh nginx

bash setup-debian.sh mysql

bash setup-debian.sh php

cat > ./restart.sh <<END
#!/bin/bash
invoke-rc.d nginx restart
invoke-rc.d php-cgi restart
invoke-rc.d mysql restart
END

invoke-rc.d nginx stop

cat >> /etc/apt/sources.list <<END
deb http://ftp.us.debian.org/debian sid main
END

apt-get update

apt-get -y install nginx

bash ./restart.sh

sed -i '$d' /etc/apt/sources.list

apt-get update

apt-get -y upgrade

# Optional operation
cat >> /etc/apt/sources.list <<END
#deb http://ftp.us.debian.org/debian sid main
END

echo 'Install complete'
