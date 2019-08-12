function! s:LoadOffsets()
  let l:left_offset = ((winwidth('%')-80)/2)
  if l:left_offset > 22
    let l:left_offset = 22
  endif
  if l:left_offset <= 10
    let s:numberwidth_offset = l:left_offset
    let s:foldcolumn_offset = 0
  else
    let s:numberwidth_offset = 10
    let s:foldcolumn_offset = l:left_offset - 10
  endif
  let &columns = &columns - l:left_offset
  let &colorcolumn = 0
endfunction


" Retrieves the color for a provided scope and swatch in the current context
function! s:LoadColor(scope, swatch)
  let l:scopeColor = synIDattr(hlID(a:scope), a:swatch, 'cterm')
  return l:scopeColor < 0 ? 'none' : l:scopeColor
endfunction


" Generates a highlight command for the provided scope, foreground, and
" background
function! s:Highlight(scope, fg, bg)
  return 'highlight ' . a:scope . ' ctermfg=' . a:fg . ' ctermbg=' . a:bg
endfunction


" Generate a highlight string that hides the given scope by setting its
" foreground and background to match the normal background
function! s:Hide(scope)
  return s:Highlight(a:scope, s:NormalBG, s:NormalBG)
endfunction


" Generate a highlight string that restores the given scope to its original
" foreground and background values
function! s:Restore(scope)
  return s:Highlight(a:scope, s:[a:scope . 'FG'], s:[a:scope . 'BG'])
endfunction


" Execute the given command within each window that is not ignored
function! s:ForEachWindow(cmd)
  let l:initialWindow = winnr()
  execute 'windo ' . a:cmd
  execute l:initialWindow . 'wincmd w'
endfunction


" Load all necessary colors and assign them to script-wide variables
function! s:LoadDFMColors()
  let s:LineNrFG            = s:LoadColor('LineNr', 'fg')
  let s:LineNrBG            = s:LoadColor('LineNr', 'bg')
  let s:CursorLineNrFG      = s:LoadColor('CursorLineNr', 'fg')
  let s:CursorLineNrBG      = s:LoadColor('CursorLineNr', 'bg')
  let s:NonTextFG           = s:LoadColor('NonText', 'fg')
  let s:NonTextBG           = s:LoadColor('NonText', 'bg')
  let s:FoldColumnFG        = s:LoadColor('FoldColumn', 'fg')
  let s:FoldColumnBG        = s:LoadColor('FoldColumn', 'bg')
  let s:TabLineFillFG       = s:LoadColor('TabLineFill', 'fg')
  let s:TabLineFillBG       = s:LoadColor('TabLineFill', 'bg')

  " Allow users to manually specify the color used to hide UI elements
  let s:NormalBG = get(g:, 'lite_dfm_normal_bg_cterm', '0')
endfunction


" Function to enter DFM
function! LiteDFM()

  " Remember user's default values.
  let s:number_default      = &number
  let s:laststatus_default  = &laststatus
  let s:tabline_default     = &tabline
  let s:showtabline_default = &showtabline
  let s:colorcolumn_default = &colorcolumn
  let s:foldcolumn_default  = &foldcolumn
  let s:numberwidth_default = &numberwidth

  if !get(s:, 'lite_dfm_on', 0)
    call s:LoadDFMColors()
  endif
  call s:LoadOffsets()
  let s:lite_dfm_on = 1

  set number
  set laststatus=0
  set showtabline=2
  set tabline=\ 
  call s:ForEachWindow('set numberwidth=' . s:numberwidth_offset . ' foldcolumn=' . s:foldcolumn_offset)

  execute s:Hide('LineNr')
  execute s:Hide('CursorLineNr')
  execute s:Hide('NonText')
  execute s:Hide('FoldColumn')
  execute s:Hide('TabLineFill')

endfunction


" Function to close DFM
function! LiteDFMClose()
  let s:lite_dfm_on = 0

  let &number       = s:number_default
  let &laststatus   = s:laststatus_default
  let &tabline      = s:tabline_default
  let &showtabline  = s:showtabline_default
  let &colorcolumn  = s:colorcolumn_default
  let &columns      = system('tput cols')

  call s:ForEachWindow('set numberwidth=' . s:numberwidth_default . ' foldcolumn=' . s:foldcolumn_default)

  try
    execute s:Restore('LineNr')
    execute s:Restore('CursorLineNr')
    execute s:Restore('NonText')
    execute s:Restore('FoldColumn')
    execute s:Restore('TabLineFill')
  catch /.*/
    " swallow the exception
  endtry

endfunction


" Function to toggle DFM
function! LiteDFMToggle()
  if get(s:, 'lite_dfm_on', 0)
    call LiteDFMClose()
  else
    call LiteDFM()
  endif
endfunction


" Map function calls to commands
command! LiteDFM call LiteDFM()
command! LiteDFMClose call LiteDFMClose()
command! LiteDFMToggle call LiteDFMToggle()
