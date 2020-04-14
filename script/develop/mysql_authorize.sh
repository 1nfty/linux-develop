#!/bin/bash

# set -x
# USERPWD=1pTVg0ld@1909
USERPWD=Energy@123456

checkInstalled=$(dpkg -l |grep mysql-server |awk '{print $2}' |head -1)
if [ "${checkInstalled}" == "" ]; then
    sudo apt-get install -y mysql-server
fi

function update_password() {
mysql -u root << EOF
SET PASSWORD FOR 'root'@'localhost' = PASSWORD("${USERPWD}");
EOF
sudo service mysql restart
echo "update password success."
}

function remote_authorize() {
mysql -u root << EOF
use mysql;
create user 'root'@'%' identified by "${USERPWD}";
grant all on *.* to root@'%' identified by "${USERPWD}" with grant option;
flush privileges;
delete from user where User='root' and Host = 'localhost';
select host,user from user;
EOF
sudo service mysql restart
echo "remote authorize success."
}

# main function
function main() {
    update_password
    remote_authorize
}
main
