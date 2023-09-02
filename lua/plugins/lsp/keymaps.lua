local M = {}

M._keys = nil

---@return (LazyKeys|{has?:string})[]
function M.get()
  if not M._keys then
  ---@class PluginLspKeys
    -- stylua: ignore
    M._keys = {
      { "<leader>cd", vim.diagnostic.open_float, desc = "Line Diagnostics" },
      { "<leader>cl", "<cmd>LspInfo<cr>", desc = "Lsp Info" },
      { "gd", "<cmd>Telescope lsp_definitions<cr>", desc = "Goto Definition", has = "definition" },
      { "gr", "<cmd>Telescope lsp_references<cr>", desc = "References" },
      { "gD", vim.lsp.buf.declaration, desc = "Goto Declaration" },
      { "gI", "<cmd>Telescope lsp_implementations<cr>", desc = "Goto Implementation" },
      { "gy", "<cmd>Telescope lsp_type_definitions<cr>", desc = "Goto T[y]pe Definition" },
      { "K", vim.lsp.buf.hover, desc = "Hover" },
      { "gK", vim.lsp.buf.signature_help, desc = "Signature Help", has = "signatureHelp" },
      { "<c-k>", vim.lsp.buf.signature_help, mode = "i", desc = "Signature Help", has = "signatureHelp" },
      { "]d", M.diagnostic_goto(true), desc = "Next Diagnostic" },
      { "[d", M.diagnostic_goto(false), desc = "Prev Diagnostic" },
      { "]e", M.diagnostic_goto(true, "ERROR"), desc = "Next Error" },
      { "[e", M.diagnostic_goto(false, "ERROR"), desc = "Prev Error" },
      { "]w", M.diagnostic_goto(true, "WARN"), desc = "Next Warning" },
      { "[w", M.diagnostic_goto(false, "WARN"), desc = "Prev Warning" },
      { "<leader>cf","<cmd>GuardFmt<cr>", desc = "Format File/Range", mode = {"n", "v"}},
      { "<leader>ca", "<cmd>Lspsaga code_action<cr>", desc = "Code Action", has = "codeAction" },
      { "<leader>cr", "<cmd>:Lspsaga rename<cr>", desc = "Rename", has = "rename" },
      { "<leader>k", "<cmd>Lspsaga peek_definition<cr>", desc = "Peek Definition"},
      { "<leader>o", "<cmd>Lspsaga outline<cr>", desc = "Outline"},
    }
  end
  return M._keys
end

function M.on_attach(client, buffer)
  local Keys = require("lazy.core.handler.keys")
  local keymaps = {} ---@type table<string,LazyKeys|{has?:string}>

  for _, value in ipairs(M.get()) do
    local keys = Keys.parse(value)
    if keys[2] == vim.NIL or keys[2] == false then
      keymaps[keys.id] = nil
    else
      keymaps[keys.id] = keys
    end
  end

  for _, keys in pairs(keymaps) do
    if not keys.has or client.server_capabilities[keys.has .. "Provider"] then
      local opts = Keys.opts(keys)
      ---@diagnostic disable-next-line: no-unknown
      opts.has = nil
      opts.silent = opts.silent ~= false
      opts.buffer = buffer
      vim.keymap.set(keys.mode or "n", keys[1], keys[2], opts)
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

M.autoformat = true
function M.togglefmt()
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

return M
