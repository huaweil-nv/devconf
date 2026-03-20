


lua<<EOF

-- You dont need to set any of these options. These are the default ones. Only
-- the loading is important
require('telescope').setup {}
-- To get fzf loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function

EOF

" Telescope 快捷键 (使用 <leader> 前缀)
nnoremap <silent><leader>` :Telescope<CR>
nnoremap <silent><leader>co :Telescope colorscheme<cr>
nnoremap <silent><leader>r  :Telescope live_grep<cr>
nnoremap <silent><leader>m :Telescope marks<cr>
nnoremap <silent><leader>k :Telescope keymaps<cr>
nnoremap <silent><leader>H :Telescope help_tags<cr>
nnoremap <silent><leader>t :Telescope tags<cr>
nnoremap <silent><leader>fF :Telescope find_files<CR>
nnoremap <silent><leader>ff :Telescope git_files<CR>
nnoremap <silent><leader>gs :Telescope git_status<CR>
nnoremap <silent><leader>b :Telescope buffers<CR>
nnoremap <silent><leader>l :Telescope current_buffer_fuzzy_find<CR>
nnoremap <silent><leader>h :Telescope oldfiles<CR>
nnoremap <silent><leader>: :Telescope command_history<CR>
nnoremap <silent><leader>/ :Telescope search_history<CR>
nnoremap <silent><leader>gc :Telescope git_bcommits<CR>
nnoremap <silent><leader>gC :Telescope git_commits<CR>
nnoremap <silent><leader>x :Telescope commands<CR>
nnoremap <silent><leader>G :Telescope grep_string<CR>
" LSP 符号导航（替代 tagbar）
nnoremap <silent><leader>o :Telescope lsp_document_symbols<CR>
nnoremap <silent><leader>O :Telescope lsp_workspace_symbols<CR>
