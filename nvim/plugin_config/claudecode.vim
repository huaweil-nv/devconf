" claudecode.nvim configuration

lua << EOF
-- Claude CLI 需要代理才能访问
vim.env.http_proxy = vim.env.http_proxy or "http://127.0.0.1:8118"
vim.env.https_proxy = vim.env.https_proxy or "http://127.0.0.1:8118"

-- 尝试加载 claudecode，如果失败则静默
local status_ok, claudecode = pcall(require, "claudecode")
if not status_ok then
  vim.notify("claudecode.nvim not found", vim.log.levels.WARN)
  return
end

claudecode.setup({
  terminal = {},
})
EOF

" 手动定义快捷键映射 (vim-plug 不支持 lazy.nvim 的 keys 格式)
" cg: 打开/切换 Claude Code
nnoremap <leader>cg <cmd>ClaudeCode<cr>

" cO: 聚焦 Claude 窗口
nnoremap <leader>cO <cmd>ClaudeCodeFocus<cr>

" ck: 发送代码到 Claude (可视模式和普通模式)
vnoremap <leader>ck <cmd>ClaudeCodeSend<cr>
nnoremap <leader>ck <cmd>ClaudeCodeSend<cr>

" cr/cc: 恢复/继续会话
nnoremap <leader>cr <cmd>ClaudeCode --resume<cr>
nnoremap <leader>cc <cmd>ClaudeCode --continue<cr>

" cb: 添加当前 buffer
nnoremap <leader>cb <cmd>ClaudeCodeAdd %<cr>

" Diff 管理
nnoremap <leader>ca <cmd>ClaudeCodeDiffAccept<cr>
nnoremap <leader>cd <cmd>ClaudeCodeDiffDeny<cr>

" 终端模式快捷键：保留 Ctrl-h/j/k/l 给终端程序，窗口切换改用 Alt-h/j/k/l
silent! tunmap <C-h>
silent! tunmap <C-j>
silent! tunmap <C-k>
silent! tunmap <C-l>
tnoremap <A-h> <C-\><C-n><C-w>h
tnoremap <A-j> <C-\><C-n><C-w>j
tnoremap <A-k> <C-\><C-n><C-w>k
tnoremap <A-l> <C-\><C-n><C-w>l
