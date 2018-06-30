function! snipsnip#python#make_dunder_all_list()
  " Scan downward in the file for any top-level `def` or `class` declarations.
  " Return a string containing a tuple of the names associated with the
  " decls that are found.
  " This string is suitable for use as the __all__ variable.
  " TODO: Pick up top-level variables?

  let decls = []
  let startpos = getpos('.')
  while v:true
    let match_lineno = search('\v^(class .*[(:]|def .*\()', 'W')
    if match_lineno > 0
      let decl = substitute(getline('.'), '\v(class|def)\s+(.{-})[(:].*', '\2', '')
      if strlen(decl) > 0 && decl[0] != '_'
        call add(decls, decl)
      endif
    else
      break
    endif
  endwhile
  call setpos('.', startpos)

  return "('" . join(decls, "', '") . "')"
endfunction
