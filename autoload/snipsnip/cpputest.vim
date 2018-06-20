function! snipsnip#cpputest#find_test_group()
  " Search backward in the file for TEST_GROUP(, but don't move the cursor.
  let [l:line_no, l:col_no] = searchpos('TEST_GROUP(', 'bn')

  let l:nothing = '/* TODO */'
  if l:line_no > 0
    " Found TEST_GROUP.
    " Check it's not commented out or in an if-0 block.
    let l:synid = synIDtrans(synID(l:line_no, l:col_no, 0))
    if synIDattr(l:synid, "name") == "Comment"
      " TEST_GROUP is inside a comment or if-0 block.
      " TODO: Keep searching? Or is it correct to just give up here.
      return l:nothing
    endif

    return substitute(getline(l:line_no),
          \           'TEST_GROUP(\(.*\)).*',
          \           '\1', '')
  else
    " No TEST_GROUP found above the cursor.
    return l:nothing
  endif
endfunction
