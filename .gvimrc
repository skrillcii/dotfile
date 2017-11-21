
if has("mac")
    set guifont=Ubuntu\ Mono\ derivative\ Powerline\ Bold:h13
    set guioptions-=T

elseif has("unix")
    set guifont=Monospace\ Bold\ 9
    set guioptions-=T

elseif has("win32")
    set guifont=Ubuntu_Mono_derivative_Powerlin:h12:b
    set guioptions-=T
endif

