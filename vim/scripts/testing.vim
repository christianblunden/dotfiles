
n! Testing::AlternateFile()
  if Testing::InTestFile() | call Testing::SwitchToFile(Testing::SourceFile())
  else                     | call Testing::SwitchToFile(Testing::TestFile())
 endif
endfunction

function! Testing::RunTests(...)
  :w " write the file

  if a:0                           | let test_file = a:1
  elseif Testing::InTestFile()     | let test_file = Testing::CurrentFile()
  elseif exists("s:last_run_test") | let test_file = s:last_run_test
  else                             | let test_file = Testing::TestFile()
  endif

  let s:last_run_test = test_file

  if match(test_file, '\.feature$') != -1 | call Testing::RunCuke(test_file)
  elseif filereadable("Gemfile")          | call Testing::BundleExecRspec(test_file)
  else                                    | call Testing::RunRspec(test_file)
  endif

endfunction

function! Testing::RunNearestTest()
  call Testing::RunTests(expand("%") . ":" . line("."))
endfunction

function! Testing::RunCuke(filename)
  call Testing::PrintAndRun("bundle exec cucumber --require features --format progress " . a:filename, a:filename)
endfunction

function! Testing::BundleExecRspec(filename)
  call Testing::PrintAndRun("bundle exec rspec " . a:filename, a:filename)
endfunction

function! Testing::RunRspec(filename)
  call Testing::PrintAndRun("rspec " . a:filename, a:filename)
endfunction

function! Testing::PrintAndRun(command, filename)
  exec ':!echo "*** Running tests in ' . a:filename . ' ***" && ' . a:command
endfunction

function! Testing::SwitchToFile(filename)
  exec ':e ' . a:filename
  if !filereadable(a:filename) | call Testing::MakeDirectory() | endif
endfunction

function! Testing::TestFile()
  let test_file = system("find . -name " . Testing::GenericPath() . "_test* -o -name " . Testing::GenericPath() . "_spec* | xargs basename")
  if     filereadable(test_file) | return test_file
  elseif match(Testing::CurrentFile(), '\.rb$')  | return Testing::RspecFile()
  elseif match(Testing::CurrentFile(), '\.clj$') | return Testing::MidjeFile()
  endif
endfunction

function! Testing::SourceFile()
  let source_file = system("find . -name " . Testing::GenericPath() . " ! -name _test.* ! -name _spec.* | xargs basename")
  if     filereadable(source_file) | return source_file
  elseif match(Testing::CurrentFile(), '\.rb$')  | return Testing::RubyFile()
  elseif match(Testing::CurrentFile(), '\.clj$') | return Testing::ClojureFile()
  endif
endfunction

function! Testing::RspecFile()
  return "spec/" . Testing::GenericPath() . "_spec.rb"
endfunction

function! Testing::MidjeFile()
  return "test/" . Testing::GenericPath() . "_test.rb"
endfunction

function! Testing::RubyFile()
  if filereadable("app/" . Testing::GenericPath() . ".rb")
    return "app/" . Testing::GenericPath() . ".rb"
  else
    return Testing::GenericPath() . ".rb"
  endif
endfunction

function! Testing::ClojureFile()
  return "src/" . Testing::GenericPath() . ".clj"
endfunction

function! Testing::GenericPath()
  return DoAll([
\     function("Testing::StripDirPrefix"),
\     function("Testing::StripPathSuffix"),
\     function("Testing::StripPathPrefix"),
\     function("Testing::StripExtension")],
\   expand("%"))
endfunction

function! Testing::InTestFile()
  return match(Testing::CurrentFile(), 'test\|spec') != -1
endfunction

function! Testing::CurrentFile()
  return expand("%")
endfunction

function! Testing::IgnoredDirs()
  return 'tmp\|cache\|vendor\|target\|build\|dist'
endfunction

function! Testing::TestDir()
  return Testing::StripNewline(system('find . -type d -name test -o -name spec | grep -v "' . Testing::IgnoredDirs() . '"' ))
endfunction

function! Testing::StripDirPrefix(path)
  return substitute(a:path, '^\(' . system('pwd') . '\|\.\/\)', '', '')
endfunction

function! Testing::StripPathPrefix(path)
  return substitute(a:path, '^\(app\|src\|spec\|test\)\/', '', '')
endfunction

function! Testing::StripPathSuffix(path)
  return substitute(a:path, '_*\(test\|spec\)\.\w*$', '', '')
endfunction

function! Testing::StripNewline(str)
  return substitute(a:str, '\n', '', '')
endfunction

function! Testing::StripExtension(str)
  return substitute(a:str, '\.[^\.]*$', '', '')
endfunction

function! Testing::MakeDirectory()
  call system('mkdir -p ' . expand('%:p:h') )
  if v:shell_error != 0
    echo "Make Directory did not return successfully"
  endif
endfunction

