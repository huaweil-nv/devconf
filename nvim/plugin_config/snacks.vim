" snacks.nvim configuration

lua << EOF
-- 尝试加载 snacks，如果失败则静默
local status_ok, snacks = pcall(require, "snacks")
if not status_ok then
  return
end

snacks.setup({
  bigfile = { enabled = true },
  dashboard = { enabled = false },
  indent = { enabled = true },      -- 缩进线显示
  input = { enabled = true },
  notifier = { enabled = true },
  quickfile = { enabled = true },
  scroll = { enabled = true },      -- 平滑滚动（替代 SmoothCursor）
  statuscolumn = { enabled = false },
  words = { enabled = true },       -- 光标下单词自动高亮
  terminal = { enabled = true },    -- 启用 terminal 模块以支持 claudecode.nvim
  scratch = { enabled = true },     -- 替代 scratch.vim
})
EOF
