syntax on

" Prepares a log entry in the end of the file
let @e=':%s/\n\{3,}/\r\r/e100%o:r! dateo- ' 
function! Logtask()
	normal :%s/\n\{3,}/\r\r/e100%o:r! dateo-  A
endfunction
