
lua << EOF
	require('mini.ai').setup()
	require('mini.align').setup()
	require('mini.bufremove').setup()
	require('mini.fuzzy').setup()
	require('mini.misc').setup()
	require('mini.pairs').setup()
	require('mini.tabline').setup()
	require('mini.trailspace').setup()
EOF
nnoremap <silent> <leader>z :lua MiniMisc.zoom()<cr>
