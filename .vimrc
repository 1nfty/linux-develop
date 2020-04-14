autocmd BufWritePost $MYVIMRC source $MYVIMRC   " 让配置变更立即生效

set nocompatible
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#rc()
filetype on                 "允许文件类型  
filetype indent on          "针对不同的文件类型采用不同的缩进格式  
filetype plugin on          "允许插件  
filetype plugin indent on   "开启插件

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 显示相关  
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
syntax on               " 语法高亮
set history=50          " 历史纪录数
set nowrap
" set number              " 显示行号
" set foldenable          " 允许折叠  
set foldmethod=manual   " 手动折叠
set hlsearch            " 搜索高亮显示
set showmatch           " 高亮显示对应的括号

set guicursor=n-v-c:hor20
set fencs=utf-8,gb2312,gbk,cp936
set termencoding=utf-8
set encoding=utf-8
set fileencodings=ucs-bom,utf-8,utf-16,gbk,big5,gb18030,latin1,gb2312,cp936
set fileencoding=utf-8
set t_Co=256

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 键盘命令
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" 定义快捷键的前缀<leader>
let mapleader=','
let g:mapleader = ","
nmap <leader>q :q!<CR>  "快捷关闭当前窗口
nmap <leader>w :w!<CR>  " 定义快捷键保存当前窗口
nmap <leader>x :x<CR>   " 定义快捷键保存并退出当前窗口
map <C-A> ggVG          " 映射全选 ctrl+a"

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 文本格式和排版 
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set autoindent       " 继承前一行的缩进方式，特别适用于多行注释 
set expandtab        " 制表符替换为空格
set tabstop=4        " 制表符为4
set softtabstop=4    " 统一缩进为4
set shiftwidth=4
set autowrite        " 自动保存

" 定义函数AutoSetFileHead，自动插入文件头，编写脚本时就不用自己写文件头了
autocmd BufNewFile *.sh,*.py exec ":call AutoSetFileHead()"
function! AutoSetFileHead()
    "如果文件类型为.sh文件
    if &filetype == 'sh'
        call setline(1, "\#!/bin/bash")
    endif

    "如果文件类型为python
    if &filetype == 'python'
        call setline(1, "\#!/usr/bin/env python")
        call append(1, "\# encoding: utf-8")
    endif

    normal G
    normal o
    normal o
endfunc


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 实用插件设置
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" vim插件管理器
Bundle 'gmarik/Vundle.vim'

""" 自动补全单引号，双引号等  
Bundle 'Raimondi/delimitMate'

""" NERDTree设置
Bundle 'scrooloose/nerdtree'
map <leader>n :NERDTreeToggle<CR>   " 打开/关闭快捷键
let NERDTreeWinSize=32              " 设置NERDTree子窗口宽度
let NERDTreeWinPos="left"           " 设置NERDTree子窗口位置
let NERDTreeShowHidden=1            " 显示隐藏文件
let NERDTreeMinimalUI=1             " NERDTree子窗口中不显示冗余帮助信息
let NERDTreeAutoDeleteBuffer=1      " 删除文件时自动删除文件对应 buffer
let NERDTreeIgnore=['\.pyc$', '\~$', 'node_modules'] " NERDTree不显示这些文件

""" NERDTree-git-plugin设置
Bundle 'Xuyuanp/nerdtree-git-plugin'
let g:NERDTreeIndicatorMapCustom = {
    \ "Modified"  : "✹",
    \ "Staged"    : "✚",
    \ "Untracked" : "✭",
    \ "Renamed"   : "➜",
    \ "Unmerged"  : "═",
    \ "Deleted"   : "✖",
    \ "Dirty"     : "✗",
    \ "Clean"     : "✔︎",
    \ "Unknown"   : "?"
\ }

""" BufExplorer设置
Bundle 'bufexplorer.zip'
let g:bufExplorerDefaultHelp=0       " Do not show default help.
let g:bufExplorerShowRelativePath=1  " Show relative paths.
let g:bufExplorerSortBy='mru'        " Sort by most recently used.

""" 全局搜索
Bundle 'kien/ctrlp.vim'
let g:ctrlp_working_path_mode = 'ra'
set wildignore+=*/tmp/*,*/node_modules/*,*.so,*.swp,*.zip
let g:ctrlp_custom_ignore = {'dir':  '\v[\/]\.(git|hg|svn)$', 'file': '\v\.(exe|so|dll)$'}

""" 状态栏信息
Bundle 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'}
set laststatus=2
"let g:Powerline_symbols='fancy'
"set guifont=Inconsolata\ for\ Powerline:h15
set fillchars+=stl:\ ,stlnc:\
set term=xterm-256color

""" 注释、反注释
Bundle 'scrooloose/nerdcommenter'
let g:NERDSpaceDelims=1
let g:NERDCommentEmptyLines=1

""" 代码折叠
Bundle 'tmhedberg/SimpylFold'
set foldmethod=indent           " 基于缩进indent, 基于语法syntax
set foldlevelstart=99           " 打开文件是默认不折叠代码
"au BufWinLeave * silent mkview  " 保存文件的折叠状态
"au BufRead * silent loadview    " 恢复文件的折叠状态
nnoremap <space> za             " 用空格来切换折叠状态

""" 编程语言自动提示
Bundle 'Valloric/YouCompleteMe'  
let g:ycm_complete_in_comments=1  "在注释输入中也能补全
let g:ycm_complete_in_strings=1   "在字符串输入中也能补全
let g:ycm_collect_identifiers_from_comments_and_strings=1 "注释和字符串中的文字也会被收入补全
let g:ycm_collect_identifiers_from_tags_files=1
let g:ycm_goto_buffer_command='horizontal-split'          " 跳转到定义处, 分屏打开
" nnoremap <leader>jd :YcmCompleter GoToDefinition<CR>
nnoremap <leader>ed :YcmCompleter GoToDefinitionElseDeclaration<CR>
nnoremap <leader>hd :YcmCompleter GoToDeclaration<CR>
if !empty(glob("~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py"))  
    let g:ycm_global_ycm_extra_conf = "~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py"  
endif

""" 多语言语法检查
Bundle 'scrooloose/syntastic'
let g:syntastic_error_symbol='>>'
let g:syntastic_warning_symbol='>'
let g:syntastic_check_on_open=1
let g:syntastic_check_on_wq=0
let g:syntastic_enable_highlighting=1
let g:syntastic_quiet_messages = { "regex": "main redeclared" }
highlight SyntasticErrorSign guifg=white guibg=black    "修改高亮的背景颜色，适应主题

""" 多光标选中编辑
Bundle 'terryma/vim-multiple-cursors'
let g:multi_cursor_use_default_mapping=0
let g:multi_cursor_next_key='<C-m>'
let g:multi_cursor_prev_key='<C-p>'
let g:multi_cursor_skip_key='<C-x>'
let g:multi_cursor_quit_key='<Esc'

""" vim的Elixir环境
Bundle 'elixir-lang/vim-elixir'
au BufNewFile,BufRead *.exs set ft=elixir

""" vim的golang环境
Bundle 'fatih/vim-go'
"Bundle 'cespare/vim-golang'
autocmd BufWritePre *.go :Fmt
let g:go_fmt_command = "goimports"
"let g:go_fmt_autosave = 1
au FileType go nmap <leader>r <Plug>(go-run)
au FileType go nmap <leader>b <Plug>(go-build)
au FileType go nmap <leader>t <Plug>(go-test)
au FileType go nmap <leader>i <Plug>(go-install)
au FileType go nmap <leader>gd <Plug>(go-def)
au FileType go nmap <leader>gc <Plug>(go-doc)


" """ vim-godef设置
Bundle 'dgryski/vim-godef'
Bundle 'nsf/gocode', {'rtp': 'vim/'}
let g:godef_split=3                     "打开新窗口的时候左右split
let g:godef_same_file_in_same_window=1  "函数在同一个文件中时不需要打开新窗口

""" Golang的gocode  
Bundle 'Blackrush/vim-gocode'

"""" tagbar配置
Bundle 'majutsushi/tagbar'
nmap <F8> :TagbarToggle<CR>
let g:tagbar_type_go = {
    \ 'ctagstype' : 'go',
    \ 'kinds'     : [
        \ 'p:package',
        \ 'i:imports:1',
        \ 'c:constants',
        \ 'v:variables',
        \ 't:types',
        \ 'n:interfaces',
        \ 'w:fields',
        \ 'e:embedded',
        \ 'm:methods',
        \ 'r:constructor',
        \ 'f:functions'
    \ ],
    \ 'sro' : '.',
    \ 'kind2scope' : {
        \ 't' : 'ctype',
        \ 'n' : 'ntype'
    \ },
    \ 'scope2kind' : {
        \ 'ctype' : 't',
        \ 'ntype' : 'n'
    \ },
    \ 'ctagsbin'  : 'gotags',
    \ 'ctagsargs' : '-sort -silent'
\ }

""" 项目内全局搜索
Bundle 'grep.vim'

""" 主题 solarized
Bundle 'altercation/vim-colors-solarized'
let g:solarized_termtrans=1
let g:solarized_contrast="normal"
let g:solarized_visibility="normal"

""" theme主题
set background=dark
colorscheme solarized
