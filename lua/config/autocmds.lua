local function augroup(name)
    return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
    group = augroup("checktime"),
    command = "checktime",
})

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
    group = augroup("highlight_yank"),
    callback = function()
        vim.highlight.on_yank()
    end,
})

-- resize splits if window got resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
    group = augroup("resize_splits"),
    callback = function()
        vim.cmd("tabdo wincmd =")
    end,
})

-- go to last loc when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
    group = augroup("last_loc"),
    callback = function()
        local mark = vim.api.nvim_buf_get_mark(0, '"')
        local lcount = vim.api.nvim_buf_line_count(0)
        if mark[1] > 0 and mark[1] <= lcount then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
})

-- close some filetypes with <q> and ctrl+c
-- To see the pattern of the current opened file, use `:set filetype?`
vim.api.nvim_create_autocmd("FileType", {
    group = augroup("close_with_q"),
    pattern = {
        "PlenaryTestPopup",
        "help",
        "lspinfo",
        "man",
        "notify",
        "OverseerList",
        "lazy",
        "qf",
        "spectre_panel",
        "startuptime",
        "tsplayground",
        "checkhealth",
        "dap-float",
        "dap-repl",
        "gitsigns.blame",
    },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
        vim.keymap.set("n", "<c-c>", "<cmd>close<cr>", { buffer = event.buf, silent = true })
    end,
})

-- wrap and check for spell in text filetypes
vim.api.nvim_create_autocmd("FileType", {
    group = augroup("wrap_spell"),
    pattern = { "gitcommit", "markdown" },
    callback = function()
        vim.opt_local.wrap = true
        vim.opt_local.spell = true
    end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    group = augroup("auto_create_dir"),
    callback = function(event)
        if event.match:match("^%w%w+://") then
            return
        end
        local file = vim.loop.fs_realpath(event.match) or event.match
        vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
    end,
})

-- this autocommands can prevent laggy when open the big file. see options.lua
vim.filetype.add({
    pattern = {
        [".*"] = {
            function(path, buf)
                return vim.bo[buf]
                    and vim.bo[buf].filetype ~= "bigfile"
                    and path
                    and vim.fn.getfsize(path) > vim.g.bigfile_size
                    and "bigfile"
                    or nil
            end,
        },
    },
})
vim.api.nvim_create_autocmd({ "FileType" }, {
    group = augroup("bigfile"),
    pattern = "bigfile",
    callback = function(ev)
        vim.b.minianimate_disable = true
        vim.schedule(function()
            vim.bo[ev.buf].syntax = vim.filetype.match({ buf = ev.buf }) or ""
        end)
    end,
})

vim.api.nvim_create_user_command("SudoWrite", function()
    local buf = vim.api.nvim_get_current_buf()
    local win = vim.api.nvim_get_current_win()
    local target = vim.api.nvim_buf_get_name(buf)

    if target == "" then
        vim.notify("当前 buffer 没有文件名", vim.log.levels.ERROR)
        return
    end

    target = vim.fn.fnamemodify(target, ":p")

    local tmp = vim.fn.tempname()
    local changedtick = vim.api.nvim_buf_get_changedtick(buf)

    -- 当前内容写入临时文件
    vim.api.nvim_buf_call(buf, function()
        vim.cmd("silent noautocmd write! " .. vim.fn.fnameescape(tmp))
    end)

    -- 写的是临时文件，所以原 buffer 仍然保持 modified
    vim.bo[buf].modified = true
    vim.cmd("botright 8new")

    local term_win = vim.api.nvim_get_current_win()
    local term_buf = vim.api.nvim_get_current_buf()

    local job = vim.fn.termopen({
        "sudo",
        "dd",
        "if=" .. tmp,
        "of=" .. target,
        "status=none",
        "conv=fsync",
    }, {
        on_exit = function(_, exit_code)
            vim.schedule(function()
                vim.fn.delete(tmp)

                if exit_code == 0 then
                    -- sudo 执行期间如果文件没再次修改，则标记为已保存
                    if vim.api.nvim_buf_is_valid(buf)
                        and vim.api.nvim_buf_get_changedtick(buf) == changedtick then
                        vim.bo[buf].modified = false
                    end

                    -- 先关闭 terminal 窗口
                    if vim.api.nvim_win_is_valid(term_win) then
                        vim.api.nvim_win_close(term_win, true)
                    end

                    -- 再彻底删除 terminal buffer
                    if vim.api.nvim_buf_is_valid(term_buf) then
                        vim.api.nvim_buf_delete(term_buf, { force = true })
                    end

                    -- 回到原来的编辑窗口
                    if vim.api.nvim_win_is_valid(win) then
                        vim.api.nvim_set_current_win(win)
                    end

                    vim.notify("sudo write: " .. target)
                else
                    vim.notify(
                        "sudo write failed: exit code " .. exit_code,
                        vim.log.levels.ERROR
                    )
                end
            end)
        end,
    })

    if job <= 0 then
        vim.fn.delete(tmp)

        if vim.api.nvim_win_is_valid(term_win) then
            vim.api.nvim_win_close(term_win, true)
        end

        if vim.api.nvim_buf_is_valid(term_buf) then
            vim.api.nvim_buf_delete(term_buf, { force = true })
        end

        vim.notify("无法启动 sudo terminal", vim.log.levels.ERROR)
        return
    end

    vim.cmd("startinsert")
end, {})

-- sudo save the file
vim.cmd([[
cnoreabbrev <expr> w!!
    \ getcmdtype() ==# ':' && getcmdline() ==# 'w!!'
    \ ? 'SudoWrite'
    \ : 'w!!'
]])

-- attach to a running c/cpp process
vim.api.nvim_create_user_command("DapAttach", function(opts)
    local dap = require("dap")
    local name = vim.trim(opts.args)

    if name == "" then
        vim.notify(
            "Usage: :DapAttach <process_name>",
            vim.log.levels.ERROR
        )
        return
    end

    -- 查找完全匹配进程名的进程
    local processes = vim.fn.systemlist({
        "pgrep",
        "-a",
        "-x",
        name,
    })

    if vim.v.shell_error ~= 0 or #processes == 0 then
        vim.notify(
            "Process not found: " .. name,
            vim.log.levels.ERROR
        )
        return
    end

    -- 获取 PID
    local pid
    if #processes == 1 then
        pid = tonumber(processes[1]:match("^(%d+)"))
    else
        local choices = { "Select process:" }
        for i, proc in ipairs(processes) do
            table.insert(
                choices,
                string.format("%d. %s", i, proc)
            )
        end
        local choice = vim.fn.inputlist(choices)
        if choice < 1 or choice > #processes then
            return
        end
        pid = tonumber(processes[choice]:match("^(%d+)"))
    end

    if not pid then
        vim.notify(
            "Failed to get PID for: " .. name,
            vim.log.levels.ERROR
        )
        return
    end

    -- CodeLLDB attach
    vim.notify(
        string.format(
            "CodeLLDB attach:\nProcess: %s\nPID: %d",
            name,
            pid
        )
    )
    dap.run({
        name = "Debug Attach: " .. name,
        type = "codelldb",
        request = "attach",
        pid = pid,
        cwd = vim.fn.getcwd(),
    })
end, {
    nargs = 1,
    desc = "Attach CodeLLDB to process by executable name",
})
