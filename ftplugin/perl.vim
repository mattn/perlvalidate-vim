function! s:package_name()
  let mx = '^\s*package\s\+\([^ ;]\+\)'
  for line in getline(1, 5)
    if line =~ mx
      return substitute(matchstr(line, mx), mx, '\1', '')
    endif
  endfor
  return ""
endfunction

function! s:use_package(name)
  for line in getline(1, 20)
    if line =~ '^use '.a:name.'[; ]'
      return 1
    endif
  endfor
  return 0
endfunction

function! s:validate_package_name()
  let path = expand('%:p:gs!\!/!')
  let name = substitute(s:package_name(), '::', '/', 'g') . '.pm'
  if path[-len(name):] != name && !v:cmdbang
    echohl WarningMsg
    echomsg 'A filename is not match as package name, it should be fixed, maybe.'
    echohl None
  endif
endfunction

function! s:validate_fileformat_unix()
  if &fileformat != 'unix'
    echohl WarningMsg
    echomsg 'A fileformat is not "unix", it should be fixed, maybe.'
    echohl None
  endif
endfunction

function! s:validate_encoding_utf8()
  if s:use_package('utf8') && &fileencoding != 'utf-8'
    let text = join(getline(1, "$"))
    let all = strlen(text)
    let eng = strlen(substitute(text, '[^\t -~]', '', 'g'))
    if all != eng
      echohl WarningMsg
      echomsg 'You use utf8 package, but the file encoding is not utf-8, it should be fixd, maybe.'
      echohl None
    endif
  endif
endfunction

augroup perlvalidate
  autocmd!
  au BufWritePost *.pm call s:validate_package_name()
  au BufWritePost *.pl,*.pm call s:validate_encoding_utf8()
  au BufWritePost *.pl,*.pm call s:validate_fileformat_unix()
augroup END

" vim:set et:
