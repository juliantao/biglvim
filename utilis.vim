
" Make files starting with # executable.
function! s:auto_chmod()
  let first_line = getline(1)
  if first_line =~ '^#!'
    silent !chmod +x %
  endif
endfunction

" Zotero vim integration 

function! ZoteroCite()
  " The citation format to use is determined either via a magic comment
  " containing cayw=format on the first line, or via the filetype.
  "
  " LaTeX citation format cheatsheet:
  "
  " latex = natbib (citep is parenthetical, citet is textual, and there
  " are other variations for omitting parts of the citation (e.g.
  " citeyearpar is only the year in parens, for when the text already
  " contains the author's name)
  "
  " biblatex = biblatex (cite, parencite, autocite etc.)
  let matches = matchlist(getline(1), 'cayw=\(\S\+\)')
  if len(matches) > 1
    let format = matches[1]
  else
    let format = &filetype =~ '.*tex' ? 'biblatex' : 'pandoc'
  endif
  let api_call = 'http://localhost:23119/better-bibtex/cayw?format='.format.'&brackets=1'
  let ref = system('curl -s '.shellescape(api_call))
  return ref
endfunction

" autocmd  BufWinEnter,BufNewFile,BufRead *.qmd set ft=rmd

source ~/.cache/calendar.vim/credentials.vim

" readonly options
cnoremap sw!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!


" vim:fdm=marker
