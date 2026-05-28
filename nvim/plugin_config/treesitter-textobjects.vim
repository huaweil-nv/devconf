lua <<EOF
local legacy_ok, legacy_configs = pcall(require, "nvim-treesitter.configs")

if legacy_ok then
    legacy_configs.setup {
        textobjects = {
            select = {
                enable = true,

                -- Automatically jump forward to textobj, similar to targets.vim
                lookahead = true,

                keymaps = {
                    -- You can use the capture groups defined in textobjects.scm
                    ["af"] = "@function.outer",
                    ["if"] = "@function.inner",
                    ["ac"] = "@class.outer",
                    ["ic"] = "@class.inner",
                    ["aa"] = "@parameter.outer",
                    ["ia"] = "@parameter.inner",
                    ["ab"] = "@block.outer",
                    ["ib"] = "@block.inner",
                },
                -- You can choose the select mode (default is charwise 'v')
                --
                -- Can also be a function which gets passed a table with the keys
                -- * query_string: eg '@function.inner'
                -- * method: eg 'v' or 'o'
                -- and should return the mode ('v', 'V', or '<c-v>') or a table
                -- mapping query_strings to modes.
                selection_modes = {
                    ['@parameter.outer'] = 'v',
                    ['@parameter.inner'] = 'v',
                    ['@block.outer'] = 'v',
                    ['@block.inner'] = 'v',
                    ['@function.inner'] = 'V',
                    ['@function.outer'] = 'V',
                    ['@class.inner'] = 'V',
                    ['@class.outer'] = 'V',
                },
                -- If you set this to `true` (default is `false`) then any textobject is
                -- extended to include preceding or succeeding whitespace. Succeeding
                -- whitespace has priority in order to act similarly to eg the built-in
                -- `ap`.
                --
                -- Can also be a function which gets passed a table with the keys
                -- * query_string: eg '@function.inner'
                -- * selection_mode: eg 'v'
                -- and should return true of false
                include_surrounding_whitespace = false,
            },
            swap = {
                enable = true,
                swap_next = {
                    -- ["<leader>a"] = "@parameter.inner",
                },
                swap_previous = {
                    -- ["<leader>A"] = "@parameter.inner",
                },
            },
            move = {
                enable = true,
                set_jumps = true, -- whether to set jumps in the jumplist
                goto_next_end = {
                    ["]f"] = "@function.outer",
                    -- ["]c"] = "@class.outer",
                    ["]a"] = "@parameter.outer",
                    ["]b"] = "@block.outer",
                },
                goto_next_start = {
                    ["]F"] = "@function.outer",
                    -- ["]C"] = "@class.outer",
                    ["]A"] = "@parameter.outer",
                    ["]B"] = "@block.outer",
                },
                goto_previous_start = {
                    ["[f"] = "@function.outer",
                    -- ["[c"] = "@class.outer",
                    ["[a"] = "@parameter.outer",
                    ["[b"] = "@block.outer",
                },
                goto_previous_end = {
                    ["[F"] = "@function.outer",
                    -- ["[C"] = "@class.outer",
                    ["[A"] = "@parameter.outer",
                    ["[A"] = "@block.outer",
                },
            },
            lsp_interop = {
                enable = true,
                border = 'none',
                floating_preview_opts = {},
                peek_definition_code = {
                    ["<leader>df"] = "@function.outer",
                    ["<leader>dc"] = "@class.outer",
                },
            },
        },
    }
else
    local ok, textobjects = pcall(require, "nvim-treesitter-textobjects")
    if ok then
        textobjects.setup {
            select = {
                lookahead = true,
                selection_modes = {
                    ['@parameter.outer'] = 'v',
                    ['@parameter.inner'] = 'v',
                    ['@block.outer'] = 'v',
                    ['@block.inner'] = 'v',
                    ['@function.inner'] = 'V',
                    ['@function.outer'] = 'V',
                    ['@class.inner'] = 'V',
                    ['@class.outer'] = 'V',
                },
                include_surrounding_whitespace = false,
            },
            move = {
                set_jumps = true,
            },
        }

        local opts = { silent = true }
        local function select_textobject(query)
            return function()
                require("nvim-treesitter-textobjects.select").select_textobject(query, "textobjects")
            end
        end
        local function move_textobject(method, query)
            return function()
                require("nvim-treesitter-textobjects.move")[method](query, "textobjects")
            end
        end

        vim.keymap.set({ "x", "o" }, "af", select_textobject("@function.outer"), opts)
        vim.keymap.set({ "x", "o" }, "if", select_textobject("@function.inner"), opts)
        vim.keymap.set({ "x", "o" }, "ac", select_textobject("@class.outer"), opts)
        vim.keymap.set({ "x", "o" }, "ic", select_textobject("@class.inner"), opts)
        vim.keymap.set({ "x", "o" }, "aa", select_textobject("@parameter.outer"), opts)
        vim.keymap.set({ "x", "o" }, "ia", select_textobject("@parameter.inner"), opts)
        vim.keymap.set({ "x", "o" }, "ab", select_textobject("@block.outer"), opts)
        vim.keymap.set({ "x", "o" }, "ib", select_textobject("@block.inner"), opts)

        vim.keymap.set({ "n", "x", "o" }, "]f", move_textobject("goto_next_end", "@function.outer"), opts)
        vim.keymap.set({ "n", "x", "o" }, "]a", move_textobject("goto_next_end", "@parameter.outer"), opts)
        vim.keymap.set({ "n", "x", "o" }, "]b", move_textobject("goto_next_end", "@block.outer"), opts)
        vim.keymap.set({ "n", "x", "o" }, "]F", move_textobject("goto_next_start", "@function.outer"), opts)
        vim.keymap.set({ "n", "x", "o" }, "]A", move_textobject("goto_next_start", "@parameter.outer"), opts)
        vim.keymap.set({ "n", "x", "o" }, "]B", move_textobject("goto_next_start", "@block.outer"), opts)
        vim.keymap.set({ "n", "x", "o" }, "[f", move_textobject("goto_previous_start", "@function.outer"), opts)
        vim.keymap.set({ "n", "x", "o" }, "[a", move_textobject("goto_previous_start", "@parameter.outer"), opts)
        vim.keymap.set({ "n", "x", "o" }, "[b", move_textobject("goto_previous_start", "@block.outer"), opts)
        vim.keymap.set({ "n", "x", "o" }, "[F", move_textobject("goto_previous_end", "@function.outer"), opts)
        vim.keymap.set({ "n", "x", "o" }, "[A", move_textobject("goto_previous_end", "@block.outer"), opts)
    end
end

EOF
