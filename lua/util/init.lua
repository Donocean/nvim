local Util = require("lazy.core.util")

local M = {}

M.root_patterns = { ".git", "lua" }

---@param on_attach fun(client, buffer)
function M.on_attach(on_attach)
    vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
            local buffer = args.buf
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            on_attach(client, buffer)
        end,
    })
end

---@param name string
-- used by lsp/init.lua on_attach
function M.opts(name)
    local plugin = require("lazy.core.config").plugins[name]
    if not plugin then
        return {}
    end
    local Plugin = require("lazy.core.plugin")
    return Plugin.values(plugin, "opts", false)
end

---@param opts? lsp.Client.filter
-- used by lsp/init.lua on_attach
function M.get_clients(opts)
    local ret = {} ---@type lsp.Client[]
    if vim.lsp.get_clients then
        ret = vim.lsp.get_clients(opts)
    else
        ---@diagnostic disable-next-line: deprecated
        ret = vim.lsp.get_active_clients(opts)
        if opts and opts.method then
            ---@param client lsp.Client
            ret = vim.tbl_filter(function(client)
                return client.supports_method(opts.method, { bufnr = opts.bufnr })
            end, ret)
        end
    end
    return opts and opts.filter and vim.tbl_filter(opts.filter, ret) or ret
end

---@param plugin string
function M.has(plugin)
    return require("lazy.core.config").plugins[plugin] ~= nil
end

function M.fg(name)
    ---@type {foreground?:number}?
    local hl = vim.api.nvim_get_hl and vim.api.nvim_get_hl(0, { name = name }) or vim.api.nvim_get_hl_by_name(name, true)
    local fg = hl and hl.fg or hl.foreground
    return fg and { fg = string.format("#%06x", fg) }
end

-- returns the root directory based on:
-- * lsp workspace folders
-- * lsp root_dir
-- * root pattern of filename of the current buffer
-- * root pattern of cwd
---@return string
function M.get_root()
    ---@type string?
    local path = vim.api.nvim_buf_get_name(0)
    path = path ~= "" and vim.loop.fs_realpath(path) or nil
    ---@type string[]
    local roots = {}
    if path then
        for _, client in pairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
            local workspace = client.config.workspace_folders
            local paths = workspace and vim.tbl_map(function(ws)
                return vim.uri_to_fname(ws.uri)
            end, workspace) or client.config.root_dir and { client.config.root_dir } or {}
            for _, p in ipairs(paths) do
                local r = vim.loop.fs_realpath(p)
                if path:find(r, 1, true) then
                    roots[#roots + 1] = r
                end
            end
        end
    end

    table.sort(roots, function(a, b)
        return #a > #b
    end)

    ---@type string?
    local root = roots[1]
    if not root then
        path = path and vim.fs.dirname(path) or vim.loop.cwd()
        ---@type string?
        root = vim.fs.find(M.root_patterns, { path = path, upward = true })[1]
        root = root and vim.fs.dirname(root) or vim.loop.cwd()
    end
    ---@cast root string
    return root
end

-- this will return a function that calls telescope.
-- cwd will default to lazyvim.util.get_root
-- for `files`, git_files or find_files will be chosen depending on .git
function M.telescope(builtin, opts)
    local params = { builtin = builtin, opts = opts }
    return function()
        builtin = params.builtin
        opts = params.opts
        opts = vim.tbl_deep_extend("force", { cwd = M.get_root() }, opts or {})
        if builtin == "files" then
            opts.find_command = { "rg", "--files", "--glob", "!**/build/*" }
            builtin = "find_files"
        end
        if opts.cwd and opts.cwd ~= vim.loop.cwd() then
            opts.attach_mappings = function(_, map)
                map("i", "<a-c>", function()
                    local action_state = require("telescope.actions.state")
                    local line = action_state.get_current_line()
                    M.telescope(
                        params.builtin,
                        vim.tbl_deep_extend("force", {}, params.opts or {}, { cwd = false, default_text = line })
                    )()
                end)
                return true
            end
        end

        require("telescope.builtin")[builtin](opts)
    end
end

-- Opens a floating terminal (interactive by default)
---@param cmd? string[]|string
---@param opts? LazyCmdOptions|{interactive?:boolean, esc_esc?:false}
function M.float_term(cmd, opts)
    opts = vim.tbl_deep_extend("force", {
        size = { width = 0.9, height = 0.9 },
    }, opts or {})
    local float = require("lazy.util").float_term(cmd, opts)
    if opts.esc_esc == false then
        vim.keymap.set("t", "<esc>", "<esc>", { buffer = float.buf, nowait = true })
    end
end

---@param silent boolean?
---@param values? {[1]:any, [2]:any}
function M.toggle(option, silent, values)
    if values then
        if vim.opt_local[option]:get() == values[1] then
            vim.opt_local[option] = values[2]
        else
            vim.opt_local[option] = values[1]
        end
        return Util.info("Set " .. option .. " to " .. vim.opt_local[option]:get(), { title = "Option" })
    end
    vim.opt_local[option] = not vim.opt_local[option]:get()
    if not silent then
        if vim.opt_local[option]:get() then
            Util.info("Enabled " .. option, { title = "Option" })
        else
            Util.warn("Disabled " .. option, { title = "Option" })
        end
    end
end

M.autoformat = false
function M.toggle_format()
    local Util = require("lazy.core.util")

    if vim.b.autoformat == false then
        vim.b.autoformat = nil
        M.autoformat = true
    else
        M.autoformat = not M.autoformat
    end

    if M.autoformat then
        vim.cmd("GuardEnable")
        vim.cmd("GuardFmt")
        Util.info("Enabled format on save")
    else
        vim.cmd("GuardDisable")
        Util.warn("Disabled format on save")
    end
end

local diagnostics_enabled = false
function M.toggle_diagnostics()
    diagnostics_enabled = not diagnostics_enabled
    if diagnostics_enabled then
        vim.diagnostic.enable()
        Util.info("Enabled diagnostics")
    else
        vim.diagnostic.disable()
        Util.warn("Disabled diagnostics")
    end
end

-- Recursive parent directory of [dir] to find directories containing pattern
function M.find_path_on_pattern(dir, pattern)
    local home_dir = vim.env.HOME
    local current_dir = dir

    local function normalize_path(path)
        return path:gsub("//", "/"):gsub("/$", "")
    end

    while true do
        local target = normalize_path(current_dir .. pattern)

        if vim.fn.filereadable(target) == 1 or vim.fn.isdirectory(target) == 1 then
            break
        end

        local parent_dir = normalize_path(vim.fn.fnamemodify(current_dir, ":h"))

        if parent_dir == home_dir or parent_dir == current_dir then
            current_dir = nil
            break
        end

        current_dir = parent_dir
    end

    return current_dir
end

return M
