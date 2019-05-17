" alternate.vim
"
" MIT license applies, see LICENSE for licensing details.
if exists('g:loaded_alternate')
    finish
endif
let g:loaded_alternate = 1

command! Alternate :call <SID>FindAlternate()

function! s:InitVariable(var, value)
    if !exists(a:var)
        exec 'let ' . a:var . ' = ' . string(a:value)
    endif
endfunction

call s:InitVariable('g:AlternateExtensionMappings', [{'.cpp' : '.h', '.h' : '.hpp', '.hpp' : '.cpp'}, {'.c': '.h', '.h' : '.c'}])
call s:InitVariable('g:AlternatePaths', ['.', '../itf', '../include', '../src'])

function! s:FindAlternate()
    let file_extension = '.' . expand("%:e")

    let is_alternate_defined = 0
    for alternate_extension_mapping in g:AlternateExtensionMappings
        if !has_key(alternate_extension_mapping, file_extension)
            let is_alternate_defined = 1
            continue
        endif

        let file_path = expand("%:p:h")
        let filename_without_extension = expand("%:t:r")

        let alternate_extension = alternate_extension_mapping[file_extension]
        while !empty(alternate_extension) && alternate_extension != file_extension
            for alternate_path in g:AlternatePaths
                let alternate_file_path = file_path . '/' . alternate_path . '/' . filename_without_extension . alternate_extension
                if filereadable(alternate_file_path)
                    " Switch to the alternate file, modify the file path to be as
                    " short as possible, without any dot dot entries.
                    exe 'e ' . fnamemodify(alternate_file_path, ":p:.")
                    return
                endif
            endfor
            let alternate_extension = alternate_extension_mapping[alternate_extension]
        endwhile
    endfor

    if !is_alternate_defined
        call s:AlternateWarning('no alternate extension configured for extension ' . file_extension)
    else
        call s:AlternateWarning('no alternate file found')
    endif
endfun

function! s:AlternateWarning(msg)
    echohl WarningMsg
    echomsg 'vim-alternate: ' . a:msg
    echohl None
endfun
