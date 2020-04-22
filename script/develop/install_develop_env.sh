#!/bin/bash

set -e

OS_TYPE=$(uname -n)

function do_link() {
    target=$1
    srcdir=$2

    #if [[ -f "$target" || -d "$target" ]]; then
        rm -f $target
        ln -fs $srcdir $target
        # echo "ln -fs $srcdir $target"
    #fi
}

function do_copy() {
    target=$1
    srcdir=$2

    rm -rf $target
    cp -R $srcdir $target
}

function install_env() {
    echo "start install develop envement..."
    do_link $HOME/.bashrc             /media/xubing/Workspace/SourceForge/Linux/DevTools/linux-develop/.bashrc
    do_link $HOME/.bash_aliases       /media/xubing/Workspace/SourceForge/Linux/DevTools/linux-develop/.bash_aliases
    do_link $HOME/.xprofile           /media/xubing/Workspace/SourceForge/Linux/DevTools/linux-develop/etc/xprofile
    do_link $HOME/.xinitrc            /media/xubing/Workspace/SourceForge/Linux/DevTools/linux-develop/etc/xprofile
    do_link $HOME/.gitconfig          /media/xubing/Workspace/SourceForge/Linux/DevTools/linux-develop/.gitconfig
    do_link $HOME/.vimrc              /media/xubing/Workspace/SourceForge/Linux/DevTools/linux-develop/.vimrc
    do_link $HOME/.cargo              /media/xubing/Workspace/SourceForge/Linux/cache-repository/rust-cargo
    do_link $HOME/.rustup             /media/xubing/Workspace/SourceForge/Linux/cache-repository/rustup
    do_link $HOME/.thunderbird        /media/xubing/Workspace/SourceForge/Linux/cache-home/.thunderbird

    # do_link $HOME/.navicat64          /media/xubing/Workspace/SourceForge/Linux/cache-home/.navicat64
    # do_link $HOME/.CLion2019.2        /media/xubing/Workspace/SourceForge/Linux/cache-home/.CLion2019.2
    # do_link $HOME/.GoLand2019.3       /media/xubing/Workspace/SourceForge/Linux/cache-home/.GoLand2019.3
    # do_link $HOME/.IntelliJIdea2019.3 /media/xubing/Workspace/SourceForge/Linux/cache-home/.IntelliJIdea2019.3
    
    if [ ! -d ~/.m2 ]; then mkdir ~/.m2; fi
    do_link $HOME/.m2/settings.xml /media/xubing/Workspace/SourceForge/Linux/DevTools/linux-develop/etc/settings-linux.xml
    
    if [ ! -f /etc/profile.bak ]; then mv /etc/profile /etc/profile.bak; fi
    do_link /etc/profile 	    /media/xubing/Workspace/SourceForge/Linux/DevTools/linux-develop/etc/profile
    if [ ! -f /etc/vim/vimrc.bak ]; then mv /etc/vim/vimrc /etc/vim/vimrc.bak; fi
    do_link /etc/vim/vimrc 	/media/xubing/Workspace/SourceForge/Linux/DevTools/linux-develop/etc/vimrc
    do_link /etc/mysql/my.cnf 	/media/xubing/Workspace/SourceForge/Linux/DevTools/linux-develop/etc/mysqld.cnf
    if [ -d /var/lib/mysql ]; then chmod -R 775 /var/lib/mysql; else mkdir -m 775 -p /var/lib/mysql; fi
    do_link /var/lib/mysql/mysql.sock /var/run/mysqld/mysqld.sock	
    # do_link /etc/network/interfaces /media/xubing/Workspace/SourceForge/Linux/DevTools/linux-develop/etc/interfaces

    do_link /home/opt               /media/xubing/Workspace/SourceForge/Linux/opt
    do_link /home/dist        	    /media/xubing/Workspace/SourceForge/Linux/dist
    do_link /home/software    	    /media/xubing/Workspace/Download
    do_link /home/developWork       /media/xubing/Workspace/DevelopWork
    do_link /home/DevTools          /media/xubing/Workspace/SourceForge/Linux/DevTools
    do_link /home/cache-home        /media/xubing/Workspace/SourceForge/Linux/cache-home
    do_link /home/cache-repository  /media/xubing/Workspace/SourceForge/Linux/cache-repository
    do_link /media/xubing/Workspace/DevelopWork/DevProjects/gopath /media/xubing/Workspace/SourceForge/Linux/DevTools/linux-develop/script/develop/set_gopath.sh
}
sudo bash -c "$(declare -f do_link do_copy install_env); install_env"

function install_soft() {
    do_link /usr/local/idea      /media/xubing/Workspace/SourceForge/Linux/DevTools/IdeaIU-2020.1
    do_link /usr/local/pycharm   /media/xubing/Workspace/SourceForge/Linux/DevTools/Pycharm-2019.3
    do_link /usr/local/goland    /media/xubing/Workspace/SourceForge/Linux/DevTools/GoLand-2019.3
    do_link /usr/local/clion     /media/xubing/Workspace/SourceForge/Linux/DevTools/Clion-2019.3
    do_link /usr/local/java      /media/xubing/Workspace/SourceForge/Linux/DevTools/Jdk1.8.0_242
    do_link /usr/local/maven     /media/xubing/Workspace/SourceForge/Linux/DevTools/Apache-maven-3.6.1
    do_link /usr/local/gradle    /media/xubing/Workspace/SourceForge/Linux/DevTools/Gradle-5.5.1
    do_link /usr/local/jmeter    /media/xubing/Workspace/SourceForge/Linux/DevTools/Apache-jmeter-4.0
    do_link /usr/local/go        /media/xubing/Workspace/SourceForge/Linux/DevTools/Golang
    
    # do_link /usr/bin/java        /usr/local/java/bin/java
    # do_link /usr/bin/javac       /usr/local/java/bin/javac
}
sudo bash -c "$(declare -f do_link install_soft); install_soft"

function install_app() {
    do_link /usr/share/applications/idea.desktop      /media/xubing/Workspace/SourceForge/Linux/DevTools/linux-develop/applications/idea.desktop
    do_link /usr/share/applications/pycharm.desktop   /media/xubing/Workspace/SourceForge/Linux/DevTools/linux-develop/applications/pycharm.desktop
    do_link /usr/share/applications/goland.desktop    /media/xubing/Workspace/SourceForge/Linux/DevTools/linux-develop/applications/goland.desktop
    do_link /usr/share/applications/clion.desktop	  /media/xubing/Workspace/SourceForge/Linux/DevTools/linux-develop/applications/clion.desktop
    do_link /usr/share/applications/jmeter.desktop    /media/xubing/Workspace/SourceForge/Linux/DevTools/linux-develop/applications/jmeter.desktop
    do_link /usr/share/applications/postman.desktop	  /media/xubing/Workspace/SourceForge/Linux/DevTools/linux-develop/applications/postman.desktop
    do_link /usr/share/applications/staruml.desktop	  /media/xubing/Workspace/SourceForge/Linux/DevTools/linux-develop/applications/staruml.desktop
    do_link /usr/share/applications/navicat.desktop   /media/xubing/Workspace/SourceForge/Linux/DevTools/linux-develop/applications/navicat.desktop
    # do_link /usr/share/applications/telegram.desktop  /media/xubing/Workspace/SourceForge/Linux/DevTools/linux-develop/applications/telegram.desktop
}
sudo bash -c "$(declare -f do_link install_app); install_app"
