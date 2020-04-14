#!/bin/bash

curr_dir=`pwd`
echo "start bcompare right-client after installed bcompare ..."
src_lib=/usr/lib/beyondcompare/ext/bcompare-ext-nemo.amd64.so
if [ -f ${src_lib} ]; then
    cp ${src_lib} /usr/lib/x86_64-linux-gnu/nemo/extensions-3.0/.
fi

# include Vundle for vim
apt-get remove --purge -y vi
apt-get install -y vim
git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall
vim +PluginUpdate +qall

cd ${curr_dir}
echo "finished ..."
