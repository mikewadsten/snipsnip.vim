function! snipsnip#python#make_dunder_all_list()
  " Scan downward in the file for any top-level `def` or `class` declarations,
  " or top-level variable declarations such as `THING = 1`.
  " Return a string containing a tuple of the names associated with the
  " decls that are found.
  " This string is suitable for use as the __all__ variable.

  let decls = []
  let startpos = getpos('.')
  while v:true
    let match_lineno = search('\v^(class .*[(:]|(async )?def .*\(|\S+\s*\=)', 'W')
    if match_lineno > 0
      let matchline = getline('.')
      if match(matchline, '\v^\S+\s*\=') != -1
        " Looks like a variable.
        if match(matchline, '^\s*@') == -1
          " Doesn't look like a decorator.
          let decl = substitute(matchline, '\v^(\S+)\s*\=.*', '\1', '')
        else
          let decl = ''
        endif
      else
        " class or def.
        let decl = substitute(getline('.'), '\v(class|def|async def)\s+(.{-})[(:].*', '\2', '')
      endif

      if strlen(decl) > 0 && decl[0] != '_'
        " Only record this declaration if it's not underscore-prefixed
        " (private).
        call add(decls, decl)
      endif
    else
      break
    endif
  endwhile
  call setpos('.', startpos)

  return "('" . join(decls, "', '") . "', )"
endfunction
