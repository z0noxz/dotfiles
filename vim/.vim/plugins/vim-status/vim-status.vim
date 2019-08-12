set laststatus=2

if !exists('g:status_color_dark')
    \ | let g:status_color_dark = 'ctermfg=6 ctermbg=5'
    \ | endif
if !exists('g:status_color_light')
    \ | let g:status_color_light = 'ctermfg=5 ctermbg=6'
    \ | endif
if !exists('g:status_color_git')
    \ | let g:status_color_git = 'ctermfg=3 ctermbg=5'
    \ | endif

function! SetStatusColorscheme()
    exec 'hi User1 ' . g:status_color_dark
    exec 'hi User2 ' . g:status_color_light
    exec 'hi User3 ' . g:status_color_git
endfunc

function! SetGitStatusLine()
    let g:status_git_status = ""
    if expand("%") == ""
        return
    endif
    let isgit = system("git -C '" . expand("%:h")
        \ . "' rev-parse")[:-2]
    let istracked = system("git -C '" . expand("%:h")
        \ . "' ls-files " . expand("%:t"))[:-2]

    if isgit == "" && istracked == expand("%:t")
        let stats = system("git -C '" . expand("%:h")
            \ . "' diff --numstat -- " . expand("%:t")
            \ . " | awk '{printf \"+%d -%d\", $1, $2}'")
        let branch = system("git -C '" . expand("%:h")
            \ . "' branch | grep \\* | awk '{printf \"%s\", $2}'")
        let g:status_git_status = ((stats == "" ? "+0 -0" : stats)
            \ . "  "  . branch . "  ")
    endif
endfunction

if has('statusline')
    call SetStatusColorscheme()
    call SetGitStatusLine()

    function! SetStatusLineStyle()
        let &stl  = ""
        let &stl .= "%1* %n"
        let &stl .= " %2* "
        let &stl .= "%<%F"
        let &stl .= "%( [%R%M]%)"
        let &stl .= " %1*%1* "
        let &stl .= "%3*%{g:status_git_status}"
        let &stl .= "%= "
        let &stl .= "%1*  "
        let &stl .= "%1*%{&fileformat}"
        let &stl .= "%1*  "
        let &stl .= "%1*%(%{(&fenc!=''?&fenc:&enc)}%)"
        let &stl .= "%1*  "
        let &stl .= "%1*%(%{&filetype}%)"
        let &stl .= " %1*%2* "
        let &stl .= "%2*%4.l/%-4.L\ "
        let &stl .= "(%-3.p%%)"
        let &stl .= "%2* | %-4.c"
        let &stl .= "%2*[0x%04B] "
    endfunc

    au BufWritePost         * call SetGitStatusLine()
    au ColorScheme          * call SetStatusColorscheme()
    au ColorScheme,VimEnter * call SetStatusLineStyle()
    nmap _ds :call SetStatusLineStyle()<CR>
    call SetStatusLineStyle()
endif
