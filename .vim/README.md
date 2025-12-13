## Custom session filetype handling with VialRun

```vim
augroup SessionCommands
  autocmd!
  au FileType javascript let b:vial_run_cwd = 'wadwise/web'
  au FileType javascript nnoremap <buffer> <leader>l :VialQFRun npx eslint --cache -f unix<cr>
  au FileType javascript nnoremap <buffer> <leader>la :VialQFRun npx eslint -f unix<cr>
  au FileType javascript nnoremap <buffer> <silent> <leader>k :VialRun npx prettier --write %<cr>

  au FileType python nnoremap <buffer> <leader>l :VialQFRun mypy %<cr>
  au FileType python nnoremap <buffer> <leader>la :VialQFRun mypy<cr>
  au FileType python nnoremap <buffer> <silent> <leader>k :VialRun ruff format %<cr>
augroup END

doautocmd FileType
```
