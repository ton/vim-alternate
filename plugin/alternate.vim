" alternate.vim
"
" BSD-2 license applies, see LICENSE for licensing details.
if exists('g:loaded_alternate')
    finish
endif
let g:loaded_alternate = 1

command! Alternate :call <SID>Alternate()

function! s:InitVariable(var, value)
    if !exists(a:var)
        exec 'let ' . a:var . ' = ' . string(a:value)
    endif
endfunction

call s:InitVariable('g:AlternateExtensionMappings', [{'.cpp' : '.h', '.h' : '.hpp', '.hpp' : '.cpp'}, {'.c': '.h', '.h' : '.c'}])
call s:InitVariable('g:AlternatePaths', ['.', '../itf', '../include', '../src'])

function! s:Alternate()
    let filename = expand("%:t")
    let file_path = expand("%:p:h")
    let is_alternate_defined = 0
    let alternate_file_path = v:null
    let best_alternate_extension_length = 0

    for alternate_extension_mapping in g:AlternateExtensionMappings
        for extension in keys(alternate_extension_mapping)
            let extension_length = len(extension)
            if filename[-extension_length:] == extension
                let filename_without_extension = filename[:-1 - extension_length]
                let is_alternate_defined = 1
                let alternate_extension = alternate_extension_mapping[extension]
                while !empty(alternate_extension) && alternate_extension != extension
                    let alternate_extension_length = len(alternate_extension)
                    if best_alternate_extension_length < alternate_extension_length
                        for alternate_path in g:AlternatePaths
                            let candidate_alternate_file_path = file_path . '/' . alternate_path . '/' . filename_without_extension . alternate_extension
                            if filereadable(candidate_alternate_file_path)
                                let alternate_file_path = candidate_alternate_file_path
                                let best_alternate_extension_length = alternate_extension_length
                            endif
                        endfor
                    endif
                    let alternate_extension = get(alternate_extension_mapping, alternate_extension, extension)
                endwhile
            endif
        endfor
    endfor

    if alternate_file_path isnot v:null
        " Switch to the alternate file, modify the file path to be as
        " short as possible, without any dot dot entries.
        exe 'e ' . fnamemodify(alternate_file_path, ":p:.")
    elseif !is_alternate_defined
        call s:AlternateWarning('no alternate extension configured for ' . filename[max([stridx(filename, "."), 0]):])
    else
        call s:AlternateWarning('no alternate file found')
    endif
endfun

function! s:AlternateWarning(msg)
    echohl WarningMsg
    echomsg 'vim-alternate: ' . a:msg
    echohl None
endfun
