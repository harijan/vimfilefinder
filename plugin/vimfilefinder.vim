" test

let s:all_files = split(globpath('.', '**'),"\n")

function! FindFiles(searchstring,displayinput)
    let l:results = ['Files:']
    let l:nresults = ['Files:']
    let l:count = 1
    for i in s:all_files
        if i =~? a:searchstring
            call add(l:results, i)
            call add(l:nresults, string(l:count) . " " . i)
            let l:count = l:count + 1
        endif
    endfor

    if a:displayinput
        let l:selected = inputlist(nresults)
    else
        let l:shown = 0
        for i in l:results
            if l:shown > 20
                break
            endif

            echom i

            let l:shown = l:shown + 1
        endfor
    endif

    if a:displayinput
        if l:selected != 0
            execute "e ". l:results[l:selected]
        endif
    endif
endfunction

function! StartSearch()
    let l:waitforcommands = 1
    let l:string = ""
    let l:runfirst = 0
    while l:waitforcommands
        echo "\nStart search\n"
        let l:char = getchar()
        echom l:char
        if l:char == "\<BS>"
            redraw!
            let l:string = strpart(l:string,0,strlen(l:string)-1)
            echom "Searching for [" l:string "]"
            call FindFiles(l:string,0)
            continue
        endif

        let l:char = nr2char(l:char)
        if l:char =~ "[a-zA-Z0-9\.]"
            let l:string = l:string . l:char
            if l:runfirst == 0
                let l:runfirst = 1
            else
                redraw!
            endif
            echom "Searching for [" l:string "]"
            call FindFiles(l:string,0)
        elseif l:char == ""
            if strlen(l:string) == 0
                break
            endif
            echom "hit enter"
            call FindFiles(l:string,1)
            let l:waitforcommands = 0
            continue
        elseif
            echom l:char
            let l:waitforcommands = 0
        endif
    endwhile
endfunction
