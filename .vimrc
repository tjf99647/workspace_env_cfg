set nocompatible
set ttyscroll=20000
set backspace=indent,eol,start
set history=50
set showcmd
set nu
set showmatch
set ruler
set autochdir
" Use spaces instead of tabs
set expandtab
set ignorecase

" Be smart when using tabs
set smarttab

autocmd BufNewFile * exec ":retab!"
"autocmd BufWrite,BufRead,BufEnter * exec ":retab!"
autocmd BufNewFile,BufWrite,BufRead,BufEnter * set expandtab

set noswapfile
set nowb
set nobackup

set tabstop=2
set softtabstop=2
set shiftwidth=2
set autoindent
set cinoptions={0,1s,t0,n-2,p2s,(03s,=.5s,>1s,=1s,:1s
set tag=tags;
set clipboard+=unnamed

"Install Plugin via PATHOGEN
execute pathogen#infect()
syntax on
filetype plugin indent on

"call plug#begin('~/.vim/bundle/')
"Plug 'verilog_systemverilog.vim'
"call plug#end()


if &t_Co > 2 || has("gui_running")
set hlsearch
endif
""au BufRead,BufNewFile *.inc,*.tc,*.v,*.vh,*.sv,*.svh,*.sva set filetype = verilog

""Define setTitle function
autocmd BufNewFile *.py,*.cpp,*.sh,*.java,*.pl,*.pm,*.sv,*.svi,*.svh exec ":call SetTitle()"
func SetTitle()
    if &filetype == 'sh'
        call setline(1,"\#!/bin/bash")
        call append(line("."), "# Author: tangjunfeng")
        call append(line(".")+1, "# Created Time: ".strftime("%c"))
        call append(line(".")+2, "")
    elseif &filetype == 'cpp'
        call setline(1,"// File Name: ".expand("%"))
        call append(line("."), "// Author: tangjunfeng")
        call append(line(".")+1, "// Created Time: ".strftime("%c"))
        call append(line(".")+2, "")
        call append(line(".")+3, "#include<iostream>")
        call append(line(".")+4, "#include<string>")
        call append(line(".")+5, "#include<algorithm>")
        call append(line(".")+6, "#include<cstdlib>")
        call append(line(".")+7, "using namespace std;")
        call append(line(".")+8, "int main(){")
        call append(line(".")+9, "")
        call append(line(".")+10, "    return 0")
        call append(line(".")+11,"}")
    elseif &filetype == 'python'
        call setline(1,"\#!/usr/bin/env python")
        call append(line("."), "# Author: tangjunfeng")
        call append(line(".")+1, "# Created Time: ".strftime("%c"))
        call append(line(".")+2, "")
    elseif &filetype == 'perl'
        call setline(1,"\#!/usr/bin/perl")
        call append(line("."), "# Author: tangjunfeng")
        call append(line(".")+1, "# Created Time: ".strftime("%c"))
        call append(line(".")+2, "# Copyright (C): ".strftime("%Y")." ALL rights reserved.")
        call append(line(".")+3, "")
        call append(line(".")+4, "use strict;")
        call append(line(".")+5, "use warnings;")
        call append(line(".")+6, "")
    else ""&filetype == 'verilog_systemverilog'
        call setline(1,          "// ****************************************************************")
        call append(line("."),   "// * Copyright (C) 2017                                           *")
        call append(line(".")+1, "// *                                                              *")
        call append(line(".")+2, "// * This source file may be used and distributed without         *")
        call append(line(".")+3, "// * restriction provided that this copyright statement is not    *")
        call append(line(".")+4, "// * removed from the file and that any derivative work contains  *")
        call append(line(".")+5, "// * the original copyright notice and the associated disclaimer  *")
        call append(line(".")+6, "// *                                                              *")
        call append(line(".")+7, "// ****************************************************************")
        call append(line(".")+8, "// * Author       : Rossi Tang")
        call append(line(".")+9, "// * Email        : 330838595@qq.com")
        call append(line(".")+10,"// * Created Time : ".strftime("%c"))
        call append(line(".")+11,"// * FileName     : ".expand("%"))
        call append(line(".")+12,"// * Desc         :")
        call append(line(".")+13,"// **************************************************************** //")
    endif
    "autocmd BufNewFile * normal G
endfunc "SetTitle

syntax enable
set background=dark
if has("gui_running")
"solarized koehler desert jellybeans kellys leo mirodark oceanblack blackdust monokai neodark
    colorscheme blackdust

    winpos 90 105
    set lines=95 columns=111
    "colo peachpuff
    set autoindent
    set guifont=Monospace\ 10
"    set guifont = Monospace:h10
else
    colorscheme neodark "solarized
endif

nmap <2-LeftMouse> <nop>
nmap <2-LeftMouse>  g<C-]>
nmap <2-RIGHTMouse> <nop>
nmap <2-RIGHTMouse> <C-T>

""=============================""
"" Key Mapping Configuration "
""=============================""
let mapleader = ","
let g:mapleader = ","

" Fast saveing
nmap <leader>w :e#<cr>
nmap <C-s> <leader>m:w!<cr><C-o>/Sazabi<cr>
imap <C-s> <Esc><leader>m:w!<cr><C-o>/Sazabi<cr>
nmap <leader>m :%s/\s*$//g<cr>

" select files in Buffer
nmap <leader>e :bp<cr>
nmap <leader>q :bn<cr>

" Fast search
nmap <Space> /

" Fast close
nmap <C-w> :q!<cr>
imap <C-w> <Esc>:q!<cr>

" Fast split
nmap <leader>v :set columns=306<cr>:vsp<cr>
"nmap <leader>v :call Resize_vsplit()<cr>
nmap <leader>s :sp<cr>

" Smart way to move between windows
noremap <C-j> <C-W>j
noremap <C-k> <C-W>k
noremap <C-h> <C-W>h
noremap <C-l> <C-W>l

" Useful mappings for managing tabs
noremap <tab>o :tabnew<cr>
noremap <tab>e :tabclose<cr>
noremap <tab>w :tabonly<cr>
noremap <C-tab> :tabn<cr>
inoremap <C-tab> <Esc>:tabn<cr>
noremap <S-tab> :tabp<cr>
inoremap <S-tab> <Esc>:tabp<cr>
noremap <leader>1 :tabn 1<cr>
noremap <leader>2 :tabn 2<cr>
noremap <leader>3 :tabn 3<cr>
noremap <leader>4 :tabn 4<cr>
noremap <leader>5 :tabn 5<cr>
noremap <leader>6 :tabn 6<cr>
noremap <leader>7 :tabn 7<cr>
noremap <leader>8 :tabn 8<cr>
noremap <leader>9 :tabn 9<cr>

" Map for No ignore case
nmap <leader>n :set noignorecase<cr>
nmap <leader>i :set ignorecase<cr>

" Select all
map <C-A> ggVG
map! <C-A> <Esc>ggVGY
vmap <C-c> "+y

" Fast realoading vimrc configs
noremap <leader>` :e ~/.vimrc<cr>

" normal mode, alt+j,k,h,l adjust win size
nnoremap <M-j> :resize +5<cr>
nnoremap <M-k> :resize -5<cr>
nnoremap <M-h> :vertical resize -5<cr>
nnoremap <M-l> :vertical resize +5<cr>

" insert mode,  cursor position
inoremap <M-j> <Down>
inoremap <M-k> <Up>
inoremap <M-h> <left>
inoremap <M-l> <Right>

" Command for aligning different rows
" .,50s/\(.*\)\s*;/\=printf("%-30s ;", submatch(1))/

" Function {{{
" Remove trailing whitespace when writing a buffer, but not for diff files.
" From: Vigil
" @see http://blog.bs2.to/post/EdwardLee/17961
function! RemoveTrailingWhitespace()
    if &ft != "diff"
        let b:curcol = col(".")
        let b:curline = line(".")
        silent! %s/\s\+$//
        silent! %s/\(\s*\n\)\+\%$//
        call cursor(b:curline, b:curcol)
    endif
endfunction
"autocmd BufWritePre * call RemoveTrailingWhitespace()
"
" }}}
"
"
"============================================================="
" Extensions configuration
"============================================================="

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Nerd Tree
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:NERDTreeWinPos = "left"
let NERDTreeShowHidden=0
let NERDTreeIgnore = ['\.pyc$', '__pycache__']
let g:NERDTreeWinSize=35
map <F2> :NERDTreeMirror<cr>
map <F2> :NERDTreeToggle<cr>
""map <leader>nb :NERDTreeFromBookmark<Space>
""map <leader>nf :NERDTreeFind<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => CTAGS
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set tags=~/tags_m/tags_uvm
set tags+=/$WORKSPACE/tags_uvmf
set tags+=/$WORKSPACE/tags_cpp

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => systemverilog
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"let g:verilog_syntax_fold_lst = ""
"let g:verilog_syntax_fold_lst = "function,task"
"set foldmethod=syntax
"
