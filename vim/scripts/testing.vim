function! s:AlternateFile()
if s:InTestFile() | call s:SwitchToFile(s:SourceFile())
else | call s:SwitchToFile(s:TestFile())
endif
endfunction

function! s:RunTests(...)
:w " write the file

if a:0 | let test_file = a:1
elseif s:InTestFile() | let test_file = s:CurrentFile()
elseif exists("s:last_run_test") | let test_file = s:last_run_test
else | let test_file = s:TestFile()
endif

let s:last_run_test = test_file

if match(test_file, '\.feature$') != -1 | call s:RunCuke(test_file)
elseif filereadable("Gemfile") | call s:BundleExecRspec(test_file)
else | call s:RunRspec(test_file)
endif

endfunction

function! s:RunNearestTest()
call s:RunTests(expand("%") . ":" . line("."))
endfunction

function! s:RunCuke(filename)
call s:PrintAndRun("bundle exec cucumber --require features --format progress " . a:filename, a:filename)
endfunction

function! s:BundleExecRspec(filename)
call s:PrintAndRun("bundle exec rspec " . a:filename, a:filename)
endfunction

function! s:RunRspec(filename)
call s:PrintAndRun("rspec " . a:filename, a:filename)
endfunction

function! s:PrintAndRun(command, filename)
exec ':!echo "*** Running tests in ' . a:filename . ' ***" && ' . a:command
endfunction

function! s:SwitchToFile(filename)
exec ':e ' . a:filename
if !filereadable(a:filename) | call s:MakeDirectory() | endif
endfunction

function! s:TestFile()
let test_file = system("find . -name " . s:GenericPath() . "_test* -o -name " . s:GenericPath() . "_spec* | xargs basename")
if filereadable(test_file) | return test_file
elseif match(s:CurrentFile(), '\.rb$') | return s:RspecFile()
elseif match(s:CurrentFile(), '\.clj$') | return s:MidjeFile()
endif
endfunction

function! s:SourceFile()
let source_file = system("find . -name " . s:GenericPath() . " ! -name _test.* ! -name _spec.* | xargs basename")
if filereadable(source_file) | return source_file
elseif match(s:CurrentFile(), '\.rb$') | return s:RubyFile()
elseif match(s:CurrentFile(), '\.clj$') | return s:ClojureFile()
endif
endfunction

function! s:RspecFile()
return "spec/" . s:GenericPath() . "_spec.rb"
endfunction

function! s:MidjeFile()
return "test/" . s:GenericPath() . "_test.rb"
endfunction

function! s:RubyFile()
if filereadable("app/" . s:GenericPath() . ".rb")
return "app/" . s:GenericPath() . ".rb"
else
return s:GenericPath() . ".rb"
endif
endfunction

function! s:ClojureFile()
return "src/" . s:GenericPath() . ".clj"
endfunction

function! s:GenericPath()
return DoAll([
\ function("s:StripDirPrefix"),
\ function("s:StripPathSuffix"),
\ function("s:StripPathPrefix"),
\ function("s:StripExtension")],
\ expand("%"))
endfunction

function! s:InTestFile()
return match(s:CurrentFile(), 'test\|spec') != -1
endfunction

function! s:CurrentFile()
return expand("%")
endfunction

function! s:IgnoredDirs()
return 'tmp\|cache\|vendor\|target\|build\|dist'
endfunction

function! s:TestDir()
return s:StripNewline(system('find . -type d -name test -o -name spec | grep -v "' . s:IgnoredDirs() . '"' ))
endfunction

function! s:StripDirPrefix(path)
return substitute(a:path, '^\(' . system('pwd') . '\|\.\/\)', '', '')
endfunction

function! s:StripPathPrefix(path)
return substitute(a:path, '^\(app\|src\|spec\|test\)\/', '', '')
endfunction

function! s:StripPathSuffix(path)
return substitute(a:path, '_*\(test\|spec\)\.\w*$', '', '')
endfunction

function! s:StripNewline(str)
return substitute(a:str, '\n', '', '')
endfunction

function! s:StripExtension(str)
return substitute(a:str, '\.[^\.]*$', '', '')
endfunction

function! s:MakeDirectory()
call system('mkdir -p ' . expand('%:p:h') )
if v:shell_error != 0
echo "Make Directory did not return successfully"
endif
endfunction

autocmd VimEnter,BufRead,BufNewFile *.rb,*.feature call RubySetup()
function RubySetup()
map <leader>, :call s:AlternateFile()<cr>
map <leader>t :call s:RunTests()<cr>
map <leader>T :call s:RunNearestTest()<cr>
map <leader>c :!bundle exec cucumber<cr>
endfunction
