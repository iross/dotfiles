runtime autoload/functionator.vim
call pathogen#infect()
set laststatus=2

set background=light
colorscheme solarized
inoremap ^? ^H
set backspace=indent,eol,start
set t_kb=
fixdel

set expandtab 

nnoremap <F5> :GundoToggle<CR>

let mapleader = ","

:imap jk <ESC> 
:imap :w <ESC>:w<CR> 
set wildignore=*.swp,*.bak,*.pyc,*.pdf,*.png,*.so,*.o,*.obj,*.root,CVS

set hlsearch "highlight all matches of searched term

map <C-g> <ESC>:! bash %<CR>
map <C-s> <ESC>:! scramv1 b<CR>
map <S-l> <ESC>:FufBuffer<CR>
map <C-t> <ESC>:edit 
"open from same directory as current file
map <C-e> <ESC>:edit <C-R>=expand("%:p:h").'/'<CR>

"insert and remove comments in visual and normal mode
vmap ,c :s/^/#/g<CR>:let @/ = ""<CR>
map  ,c :s/^/#/g<CR>:let @/ = ""<CR>
vmap ,cc :s/^#//g<CR>:let @/ = ""<CR>
map  ,cc :s/^#//g<CR>:let @/ = ""<CR>
vmap ,C :s/^/\/\//g<CR>:let @/ = ""<CR>
map  ,C :s/^/\/\//g<CR>:let @/ = ""<CR>
vmap ,CC :s/^\/\///g<CR>:let @/ = ""<CR>
map  ,CC :s/^\/\///g<CR>:let @/ = ""<CR>

map ,' ciw'<C-R>"'<ESC>
map ," ciw"<C-R>""<ESC>
map ,( ciw(<C-R>")<ESC>

map cn <ESC>:cn<CR>
map cp <ESC>:cp<CR>

map ,v :set paste<CR>
map ,vv :set nopaste<CR>

set makeprg=scram\ b 

" Always show line numbers, but only in current window.
set number
":au WinEnter * :setlocal number
":au WinLeave * :setlocal nonumber

" tab navigation mapped to tl and th
map <c-l> :tabnext<cr>
map <c-h> :tabprev<cr>

"set mouse=a
set mouse=vr " mouse support

:set tabstop=4
:set shiftwidth=4
" Enable syntax highlighting
syntax on
filetype plugin indent on

hi StatColor guibg=#95e454 guifg=black ctermbg=lightgreen ctermfg=black
hi Modified guibg=orange guifg=black ctermbg=lightred ctermfg=black

set history=50		" keep 50 lines of command line history
set undolevels=50 " keep 50 levels of undo
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching
set autoindent		" always set autoindenting on
set cursorline "highlight cursor line
set cursorcolumn "highlight cursor column

" clear search with ,/
nmap <silent> ,/ :nohlsearch<CR> 

"function! MyStatusLine(mode)
"    let statusline=""
"    if a:mode == 'Enter'
"        let statusline.="%#StatColor#"
"    endif
"    let statusline.="\(%n\)\ %f\ "
"    if a:mode == 'Enter'
"        let statusline.="%*"
"    endif
"    let statusline.="%#Modified#%m"
"    if a:mode == 'Leave'
"        let statusline.="%*%r"
"    elseif a:mode == 'Enter'
"        let statusline.="%r%*"
"    endif
"    let statusline .= "\ (%l/%L,\ %c)\ %P%=%h%w\ %y\ [%{&encoding}:%{&fileformat}]\ \ "
"    return statusline
"endfunction

"au WinEnter * setlocal statusline=%!MyStatusLine('Enter')
"au WinLeave * setlocal statusline=%!MyStatusLine('Leave')

au FileType c,cpp setlocal comments-=:// comments+=f://
au FileType py,sh setlocal comments-=:# comments+=f:#

set statusline=%!MyStatusLine('Enter')

" Source the vimrc file after saving it
if has("autocmd")
	autocmd bufwritepost .vimrc source $MYVIMRC
endif

hi StatusLine cterm=NONE ctermbg=237  ctermfg=39

"highlight Pmenu ctermfg=1 ctermbg=4 guibg=grey30

function! InsertStatuslineColor(mode)
  if a:mode == 'i'
    hi StatColor guibg=orange ctermbg=lightred
  elseif a:mode == 'r'
    hi StatColor guibg=#e454ba ctermbg=magenta
  elseif a:mode == 'v'
    hi StatColor guibg=#e454ba ctermbg=magenta
  else
    hi StatColor guibg=red ctermbg=red
  endif
endfunction 

au InsertEnter * call InsertStatuslineColor(v:insertmode)
au InsertLeave * hi StatColor guibg=#95e454 guifg=black ctermbg=lightgreen ctermfg=black

set laststatus=2 " always show status line
set statusline=%<%f%<%{FileTime()}%<%h%m%r%=%-20.(line=%03l,col=%02c%V,totlin=%L%)\%h%m%r%=%-30(,%Y%)\%P\*%=%{CurTime()}
set rulerformat=%15(%c%V\ %p%%%)
"set rulerformat=%<%f%<%{FileTime()}%<%h%m%r%=%-20.(line=%03l,col=%02c%V,totlin=%L%)\%h%m%r%=%-30(,BfNm=%n%Y%)\%P\*%=%{CurTime()}

fun! FileTime()
  let ext=tolower(expand("%:e"))
  let fname=tolower(expand('%<'))
  let filename=fname . '.' . ext
  let msg=""
  let msg=msg." ".strftime("(Modified %b,%d %y %H:%M:%S)",getftime(filename))
  return msg
endf

fun! CurTime()
  let ftime=""
  let ftime=ftime." ".strftime("%b,%d %y %H:%M:%S")
  return ftime
endf

