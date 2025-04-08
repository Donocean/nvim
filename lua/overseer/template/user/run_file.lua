return {
    name = "run file(c/c++/py)",
    builder = function()
        local lang_cmd = {}
        local lang_args = {}
        local ft = vim.bo.filetype

        local file = vim.api.nvim_buf_get_name(0)  -- get full path of current file
        if ft == "c" or ft == "cpp" then
            local Util = require("util")
            local current_path = vim.fn.fnamemodify(file, ":h")  -- no file name, only need abs path
            local build_root = Util.find_path_on_pattern(current_path, "/build")

            if build_root ~= nil then
                -- vim.fn.input("Path to executable: ", build_path .. "/", "file")
                lang_cmd = build_root .. "/build/demo"
            else
                -- vim.fn.input("Path to executable: ", current_path .. "/", "file")
                lang_cmd = current_path .. "/demo"
            end
        elseif ft == "python" then
            lang_cmd = { "python3" }
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
