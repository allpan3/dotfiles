function! myspacevim#before() abort
    let g:neomake_c_enabled_makers = ['clang']
    " you can defined mappings in bootstrap function
    " for example, use kj to exit insert mode.
    cnoremap <C-a>  <Home>
    cnoremap <C-e>  <End>
    imap <C-e> <C-o>$
    imap <C-a> <C-o>0
    nmap <C-a> ^
    nmap <C-e> $
endfunction

function! myspacevim#after() abort
    " you can remove key binding in bootstrap_after function
endfunction
