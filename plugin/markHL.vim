"  Name        - markHL.vim
"  Description - Vim simple global plugin for easy line marking and jumping
"  Last Change - 8 Jan 2011
"  Creator     - Nacho <pkbrister@gmail.com>
"
"  Inspired by Kate 'bookmarks' and other scripts herein, I devised a convenient way to mark lines and highlight mark lines.
"  The idea is to mark lines and then jump from one to the other, in an easier way than the one Vim provides.
"  Also lines are highlighted, which is convenient to know where the mark is.
"  So, hopefully, one does not need to remember which markers are already in use and which are free anymore, just 'add mark' and 'remove mark'
"  
"  USAGE:
"  <F1>		Turn on highlight on all lines with markers on them
"  <F2>		Turn off the highlighting on marked lines
"  <SHIFT-F2>	Erase all markers [a-z]
"  <F5>		Add a mark on the current line (and highlight)
"  <SHIFT-F5>	Remove the mark on the current line
"
"  Jump from one mark to the next using the classic [' and ]' jumps
"  
"  Try it! it's nice!
"  
"  NOTE:
"  Of course, the highlight group I define ("Marks") should be tweaked to one's taste, and the same applies to the keyboard mappings.
"  
"  OTHER NOTE:
"  The code works with marks from 'a' to 'z', and it is intended to override the usual marking method (ie. typing 'ma', 'mb', 'mc'...).
"  If someone would like to use both methods at the same time, I suggest to adjust the code and wherever char2nr('a') appears, substitute for char2nr('e') or whatever, so that marks from 'a' to 'd' (or whatever) are available for classic use. 


hi Marks term=reverse ctermfg=0 ctermbg=4

function! HLMarks(group)
  call clearmatches()
  let index = char2nr('a')
  while index < char2nr('z')
    call matchadd( a:group, '\%'.line( "'".nr2char(index)).'l')
    let index = index + 1
  endwhile
endfunction


function! AddHLMark(group)
  if !exists("g:dynMarkCount")
    let g:dynMarkCount = char2nr('a')
  endif
  if g:dynMarkCount != char2nr('z')
    exe 'normal m'.nr2char(g:dynMarkCount)
    let g:dynMarkCount = g:dynMarkCount + 1
    call HLMarks(a:group)
  endif
endfunction


function! DelHLMark(group)
  if exists("g:dynMarkCount") && g:dynMarkCount >= char2nr('a')
    let index = char2nr('a')
    while index < char2nr('z')
      if line(".") == line("'".nr2char(index))
	let g:dynMarkCount = g:dynMarkCount - 1
	exe 'delmarks '.nr2char(index)
	exe line("'".nr2char(g:dynMarkCount)).'mark '.nr2char(index)
	exe 'delmarks '.nr2char(g:dynMarkCount)
	let index = char2nr('z')
      endif
      let index = index + 1
    endwhile
    call HLMarks(a:group)
  endif
endfunction

nmap <F1> :call HLMarks("Marks")<CR>
nmap <F2> :call clearmatches()<CR>
nmap <S-F2> :call clearmatches()\|:delmarks a-z\|:let g:dynMarkCount=char2nr('a')<CR>
nmap <F5> :call AddHLMark("Marks")<CR>
nmap <S-F5> :call DelHLMark("Marks")<CR>
