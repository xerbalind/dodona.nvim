if !has('nvim-0.5')
  echoerr 'You need neovim version >= 0.5 to run this plugin'
  finish
endif

command! DodonaSubmit lua require'dodona'.submit()
command! DodonaInitActivities lua require'dodona'.initActivities()
