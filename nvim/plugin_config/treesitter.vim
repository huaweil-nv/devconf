
"  treesitter

lua << EOF
local parser_names = {
    "c",
    "lua",
    "cpp",
    "go",
    "bash",
    "make",
    "json",
    "json5",
    "yaml",
    "jsonc",
    "vim",
    "javascript",
    "cmake",
    "python",
}

for _, ext in pairs(vim.g.treesitter_config_table or {}) do
    table.insert(parser_names, ext)
end

local function apply_github_proxy()
    local proxy = vim.g.github_proxy or ""
    if proxy == "" then
        return
    end

    local ok, parsers = pcall(require, "nvim-treesitter.parsers")
    if not ok then
        return
    end

    local configs = parsers
    if type(parsers.get_parser_configs) == "function" then
        configs = parsers.get_parser_configs()
    end

    for _, config in pairs(configs) do
        if config.install_info and config.install_info.url then
            config.install_info.url = config.install_info.url:gsub("https://github.com/", proxy .. "https://github.com/")
        end
    end
end

local autocmd_group = vim.api.nvim_create_augroup("UserTreesitterConfig", { clear = true })
vim.api.nvim_create_autocmd("User", {
    group = autocmd_group,
    pattern = "TSUpdate",
    callback = apply_github_proxy,
})
apply_github_proxy()

local legacy_ok, legacy_configs = pcall(require, "nvim-treesitter.configs")
if legacy_ok then
    local install_ok, install = pcall(require, "nvim-treesitter.install")
    if install_ok then
        install.prefer_git = true
    end

    legacy_configs.setup {
        ensure_installed = parser_names,
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
        },
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = "<cr>",
                node_incremental = "<cr>",
                scope_incremental = "<cr>",
                node_decremental = "<bs>",
            },
        },
    }
else
    local ok, treesitter = pcall(require, "nvim-treesitter")
    if ok then
        treesitter.setup()

        if vim.fn.executable("tree-sitter") == 1 then
            treesitter.install(parser_names)
        end

        vim.api.nvim_create_autocmd("FileType", {
            group = autocmd_group,
            callback = function(args)
                local started = pcall(vim.treesitter.start, args.buf)
                if started then
                    vim.wo.foldmethod = "expr"
                    vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
                end
            end,
        })
    end
end
EOF
set foldmethod=expr
if has('nvim-0.12')
    set foldexpr=v:lua.vim.treesitter.foldexpr()
else
    set foldexpr=nvim_treesitter#foldexpr()
endif
