#!/bin/bash

curr_dir=`pwd`

echo "start install input method ..."
# apt install -y fcitx fcitx-config-gtk fcitx-sunpinyin fcitx-frontend-qt5 fcitx-ui-classic fcitx-libs fcitx-frontend-gtk3
if [ -f "~/.xprofile" ]; then
rm -f ~/.xprofile
cat << EOF > ~/.xprofile
# fcitx
export XIM="fcitx"
export XIM_PROGRAM="fcitx"
export XMODIFIERS="@im=fcitx"
export GTK_IM_MODULE="fcitx"
export QT_IM_MODULE="fcitx"
EOF
fi

echo "start remove old font ..."
apt-get remove --purge -y fonts-droid-fallback fonts-arphic-ukai fonts-arphic-uming

echo "start install windows font ..."
LINUX_FONT_DIR=/usr/share/fonts
SHARE_FONT_DIR=/media/xubing/Workspace/SourceForge/Linux/DevTools/linux-develop/fonts
#WIN_FONTS=/media/xubing/Windows/Windows/Fonts
#if [ -d "${WIN_FONTS}" ]; then
#    ln -fs ${WIN_FONTS} ${LINUX_FONT_DIR}/win_fonts
#else
    if [ -d "${SHARE_FONT_DIR}" ]; then 
        rm -f ${LINUX_FONT_DIR}/chinese
        ln -fs ${SHARE_FONT_DIR} ${LINUX_FONT_DIR}/chinese
    fi
#fi
cd ${LINUX_FONT_DIR}
# mkfontscale
# mkfontdir
fc-cache -f
fc-list |egrep "(chinese|win_fonts)"

cd ${curr_dir}
echo "finished ..."
