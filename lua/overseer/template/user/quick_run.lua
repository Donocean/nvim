return {
    name = "quick run",
    builder = function()
        local ft = vim.bo.filetype
        local file = vim.api.nvim_buf_get_name(0)
        -- get file dir path
        local file_dir = vim.fn.fnamemodify(file, ":h")

        local lang_cmd = {}
        local lang_args = {}

        if ft == "c" then
            -- 'gcc -g' means debug support
            local out_path = file_dir .. "/build/"
            vim.cmd("silent !mkdir -p " .. out_path)
            lang_cmd = { "gcc" }
            lang_args = { "-g", file, "-o", out_path .. "demo.elf" }
        elseif ft == "cpp" then
            local out_path = file_dir .. "/build/"
            vim.cmd("silent !mkdir -p " .. out_path)
            lang_cmd = {"g++"}
            lang_args = { "-g", file, "-o", out_path .. "demo.elf" }
        elseif ft == "lua" then
            lang_cmd = "lua"
            lang_args = { file }
        elseif ft == "python" then
            lang_cmd = "python3"
            lang_args = { file }
        end

        return {
            cmd = lang_cmd,
            args = lang_args,
            components = { { "on_output_quickfix", open = true }, "default" },
        }
    end,
    condition = {
        filetype = { "c", "cpp", "lua", "python" },
    },
}
