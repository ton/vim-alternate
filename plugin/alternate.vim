" alternate.vim
"
" BSD-2 license applies, see LICENSE for licensing details.
if exists('g:loaded_alternate')
    finish
endif
let g:loaded_alternate = 1

command! Alternate :call <SID>Alternate()

let g:AlternateAutoCreate = get(g:, 'AlternateAutoCreate', v:false)
let g:AlternateCommand = get(g:, 'AlternateCommand', 'e')
let g:AlternateExtensionMappings = get(g:, 'AlternateExtensionMappings', [{'.cpp' : '.h', '.h' : '.hpp', '.hpp' : '.cpp'}, {'.c': '.h', '.h' : '.c'}])
let g:AlternatePaths = get(g:, 'AlternatePaths', ['.', '../itf', '../include', '../src'])

function! s:Alternate()
    let l:filename = expand("%:t")
    let l:file_path = expand("%:p:h")
    let l:is_alternate_defined = 0
    let l:alternate_file_path = v:null
    let l:longest_extension_length = 0
    let l:auto_create_file_path = v:null

    for l:alternate_extension_mapping in g:AlternateExtensionMappings
        for l:extension in keys(l:alternate_extension_mapping)
            let l:extension_length = len(l:extension)
            if l:longest_extension_length < l:extension_length
                if l:filename[-l:extension_length:] == l:extension
                    let l:filename_without_extension = l:filename[:-1 - l:extension_length]
                    let l:is_alternate_defined = 1
                    let l:alternate_extension = l:alternate_extension_mapping[l:extension]
                    while !empty(l:alternate_extension) && l:alternate_extension != l:extension
                        let l:alternate_extension_length = len(l:alternate_extension)
                        for l:alternate_path in g:AlternatePaths
                            let l:candidate_alternate_file_path = l:file_path . '/' . l:alternate_path . '/' . l:filename_without_extension . l:alternate_extension
                            if filereadable(l:candidate_alternate_file_path)
                                let l:alternate_file_path = l:candidate_alternate_file_path
                                let l:longest_extension_length = l:extension_length
                            elseif l:auto_create_file_path is v:null
                                let l:auto_create_file_path = l:candidate_alternate_file_path
                            endif
                        endfor
                        let l:alternate_extension = get(l:alternate_extension_mapping, l:alternate_extension, l:extension)
                    endwhile
                endif
            endif
        endfor
    endfor

    " In case no alternate file was found, and `g:AlternateAutoCreate` is set,
    " create the alternate file (and possibly the directory of the alternate
    " file).
    if g:AlternateAutoCreate && l:alternate_file_path is v:null && l:auto_create_file_path isnot v:null
        let l:maybe_missing_directory = fnamemodify(l:auto_create_file_path, ':h:.')
        if !isdirectory(l:maybe_missing_directory)
            call mkdir(l:maybe_missing_directory, 'p')
        endif
        let l:alternate_file_path = fnamemodify(l:auto_create_file_path, ':p:.')
        call system('touch ' . l:alternate_file_path)
    endif

    if l:alternate_file_path isnot v:null
        " Switch to the alternate file, modify the file path to be as
        " short as possible, without any dot dot entries.
        exe g:AlternateCommand . ' ' . fnamemodify(l:alternate_file_path, ":p:.")
    elseif !is_alternate_defined
        call s:AlternateWarning('no alternate extension configured for ' . l:filename[max([stridx(l:filename, "."), 0]):])
    else
        call s:AlternateWarning('no alternate file found')
    endif
endfun

function! s:AlternateWarning(msg)
    echohl WarningMsg
    echomsg 'vim-alternate: ' . a:msg
    echohl None
endfun
