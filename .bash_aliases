## 系统相关命令别名
alias ll='ls -l'
alias ls='ls --color=auto'
alias vi='vim'
alias clean='/media/xubing/Workspace/SourceForge/Linux/DevTools/linux-develop/script/clean.sh'

## docker 相关操作别名
alias dockerstop='docker ps -a -q |xargs -ti docker stop {}'
alias dockercleanc='docker ps -a -q |xargs -ti docker rm -f {}'

alias dockercleani="docker images -a |grep 'dev\|none\|test-vp\|peer[0-9]-' |awk '{print \$3}' |xargs -ti docker rmi -f {}"
alias dockervolume="docker volume ls -qf dangling=true |xargs -ti docker volume rm {}"
alias dockerclean='dockerstop && dockercleanc && dockercleani && dockervolume'

## alias docker images process command
alias dockerpull='/media/sf_code/github.com/linux-develop/script/others/docker_images.sh -t pull'
alias dockerpush='/media/sf_code/github.com/linux-develop/script/others/docker_images.sh -t push'
alias dockerpullall='/media/sf_code/github.com/linux-develop/script/others/docker_images.sh -t pullall'
alias dockerpushall='/media/sf_code/github.com/linux-develop/script/others/docker_images.sh -t pushall'
