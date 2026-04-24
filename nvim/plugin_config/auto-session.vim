lua<<EOF

vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal"

require("auto-session").setup {
  -- log_level = "debug",
  -- 带文件参数启动时也保存 session（否则 nvim file.py 不会保存/恢复 session）
  args_allow_files_auto_save = true,
  args_allow_single_directory = true,

  session_lens = {
    load_on_setup = true,
    previewer = false,
    mappings = {
      delete_session = { "i", "<C-D>" },
      alternate_session = { "i", "<C-S>" },
      copy_session = { "i", "<C-Y>" },
    },
    theme_conf = {
      border = true,
    },
  },
}

EOF


command! SS :SessionSave

noremap <silent> <leader>s :SessionSearch<CR>
