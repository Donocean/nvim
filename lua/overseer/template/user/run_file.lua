return {
    name = "run file(c/c++/py)",
    builder = function()
        local ft = vim.bo.filetype

        local lang_cmd = {}
        local lang_args = {}

        local function directory_exists(dir)
            local stat = vim.loop.fs_stat(dir)
            return stat and stat.type == 'directory'
        end

        if ft == "c" or ft == "cpp" then
            local current_path = vim.fn.getcwd()
            local build_path = current_path .. "/build"

            if directory_exists(build_path) then
                -- vim.fn.input("Path to executable: ", build_path .. "/", "file")
                lang_cmd = build_path .. "/demo"
            else
                -- vim.fn.input("Path to executable: ", current_path .. "/", "file")
                lang_cmd = current_path .. "/demo"
            end
        elseif ft == "python" then
            local file = vim.api.nvim_buf_get_name(0)
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
        filetype = { "c", "cpp", "python" },
    },
}
