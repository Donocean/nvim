local M = {}

M._keys = nil

---@return (LazyKeys|{has?:string})[]
function M.get()
  if not M._keys then
  ---@class PluginLspKeys
    -- stylua: ignore
    M._keys = {
      { "<leader>cw", vim.diagnostic.open_float, desc = "Line Diagnostics" },
      { "<leader>cl", "<cmd>LspInfo<cr>", desc = "Lsp Info" },
      { "gd", "<cmd>Telescope lsp_definitions<cr>", desc = "Goto Definition", has = "definition" },
      { "gD", vim.lsp.buf.declaration, desc = "Goto Declaration" },
      { "gr", "<cmd>Telescope lsp_references<cr>", desc = "References" },
      { "gI", "<cmd>Telescope lsp_implementations<cr>", desc = "Goto Implementation" },
      { "gy", "<cmd>Telescope lsp_type_definitions<cr>", desc = "Goto T[y]pe Definition" },
      { "K", vim.lsp.buf.hover, desc = "Hover" },
      { "]d", M.diagnostic_goto(true), desc = "Next Diagnostic" },
      { "[d", M.diagnostic_goto(false), desc = "Prev Diagnostic" },
      { "]e", M.diagnostic_goto(true, "ERROR"), desc = "Next Error" },
      { "[e", M.diagnostic_goto(false, "ERROR"), desc = "Prev Error" },
      { "]w", M.diagnostic_goto(true, "WARN"), desc = "Next Warning" },
      { "[w", M.diagnostic_goto(false, "WARN"), desc = "Prev Warning" },
      { "<leader>cf","<cmd>GuardFmt<cr>", desc = "Format File"},
      { "+", "=<cmd>GuardFmt<cr>", desc = "Format Range", mode = "v"},
      { "<leader>a", "<cmd>Lspsaga code_action<cr>", desc = "Code Action", has = "codeAction" },
      { "<leader>cr", "<cmd>:Lspsaga rename<cr>", desc = "Rename", has = "rename" },
      { "<leader>k", "<cmd>Lspsaga peek_definition<cr>", desc = "Peek Definition"},
      { "<leader>o", "<cmd>Lspsaga outline<cr>", desc = "Outline"},
    }
  end
  return M._keys
end


---@return (LazyKeys|{has?:string})[]
-- used by lsp/init.lua on_attach
function M.resolve(buffer)
    local Keys = require("lazy.core.handler.keys")
    if not Keys.resolve then
        return {}
    end
    local spec = M.get()
    local opts = require("util").opts("nvim-lspconfig")
    local clients = require("util").get_clients({ bufnr = buffer })
    for _, client in ipairs(clients) do
        local maps = opts.servers[client.name] and opts.servers[client.name].keys or {}
        vim.list_extend(spec, maps)
    end
    return Keys.resolve(spec)
end

---@param method string
-- used by lsp/init.lua on_attach
function M.has(buffer, method)
    method = method:find("/") and method or "textDocument/" .. method
    local clients = require("util").get_clients({ bufnr = buffer })
    for _, client in ipairs(clients) do
        if client.supports_method(method) then
            return true
        end
    end
    return false
end

function M.on_attach(_, buffer)
    local Keys = require("lazy.core.handler.keys")
    local keymaps = M.resolve(buffer)

    for _, keys in pairs(keymaps) do
        if not keys.has or M.has(buffer, keys.has) then
            local opts = Keys.opts(keys)
            opts.has = nil
            opts.silent = opts.silent ~= false
            opts.buffer = buffer
            vim.keymap.set(keys.mode or "n", keys.lhs, keys.rhs, opts)
        end
    end
end

function M.diagnostic_goto(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go({ severity = severity })
  end
end

return M
