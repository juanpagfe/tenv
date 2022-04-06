" shorter commands
cnoreabbrev tree NERDTreeToggle
cabbrev vsf vert sfind

" plugs
map <Leader>p :Files<CR>
map <Leader>ag :Ag<CR>

set path+=**                                                                    
set path+=.vim 
set wildignore+=**/*.class 

" allow the . to execute once for each line of a visual selection
vnoremap . :normal .<CR>          
