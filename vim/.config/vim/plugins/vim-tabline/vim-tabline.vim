if (exists("g:loaded_tabline_vim") && g:loaded_tabline_vim) || &cp
    finish
endif
let g:loaded_tabline_vim = 1

function! Tabline()
    let s = ''
    let d = expand('%:~:h')
    let d = pathshorten(d)
    for i in range(tabpagenr('$'))
        let tab         = i + 1
        let winnr       = tabpagewinnr(tab)
        let buflist     = tabpagebuflist(tab)
        let bufnr       = buflist[winnr - 1]
        let bufname     = bufname(bufnr)
        let bufmodified = getbufvar(bufnr, "&mod")

        let s .= '%' . tab . 'T'
        let s .= (tab == tabpagenr() ? '%#TabLineNumSel#' : '%#TabLineNum#')
        let s .= ' ' . tab . ' '
        let s .= (tab == tabpagenr() ? '%#TabLineSel#' : '%#TabLine#')
        let s .= ' '
        let s .= (bufname != '' ? fnamemodify(bufname, ':t') . ' ' : '[No Name] ')

        if bufmodified
            let s .= '[+] '
        endif

        let s .= '%#TabLineFill# '
    endfor

    let s .= '%=%999%'
    let s .= '%#TabLineSep#'
    let s .= ''
    let s .= '%#TabLineDir#'
    let s .= ' ' . d . ' '

    return s
endfunction
set tabline=%!Tabline()
