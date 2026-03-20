lua << EOF
require("auto-save").setup {
    enabled = true,
    execution_message = {
        message = "",
        dim = 0.18,
        cleaning_interval = 1250,
    },
    -- VSCode 风格：失焦、切换buffer、离开insert模式时自动保存
    trigger_events = {"FocusLost", "BufLeave", "InsertLeave", "TextChanged"},
    condition = function(buf)
        local fn = vim.fn
        local utils = require("auto-save.utils.data")

        if not (fn.getbufvar(buf, "&modifiable") == 1 and
            utils.not_in(fn.getbufvar(buf, "&filetype"), {})) then
            return false
        end

        -- 排除 claudecode diff buffer
        local bufname = vim.api.nvim_buf_get_name(buf)
        if bufname:match("%(proposed%)") or
           bufname:match("%(NEW FILE %- proposed%)") or
           bufname:match("%(New%)") then
          return false
        end

        if vim.b[buf].claudecode_diff_tab_name or
           vim.b[buf].claudecode_diff_new_win or
           vim.b[buf].claudecode_diff_target_win then
          return false
        end

        local buftype = fn.getbufvar(buf, "&buftype")
        if buftype ~= "" then
          return false
        end

        return true
    end,
    write_all_buffers = false,
    debounce_delay = 1000,
}
EOF
