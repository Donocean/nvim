return {
    name = "clean build(c/c++)",
    builder = function()
        local lang_cmd = {}
        local lang_args = {}

        local Util = require("util")
        local file = vim.api.nvim_buf_get_name(0)           -- get full path of current file
        local current_path = vim.fn.fnamemodify(file, ":h") -- no file name, only need abs path
        local project_root = Util.find_path_on_pattern(current_path, "/Makefile")
        local build_root = Util.find_path_on_pattern(current_path, "/build")

        if project_root ~= nil then
            -- It is a makefile project.
            lang_cmd = { "make" }
            lang_args = { "-C", project_root, "clean" }
        elseif build_root ~= nil then
            -- It is a cmake project. the makefile is in the /build dir
            lang_cmd = { "make" }
            lang_args = { "-C", build_root .. "/build/", "clean" }
        else
            -- It is singal file. no makefile.
            local out_path = current_path .. "/build/"
            lang_cmd = { "rm" }
            lang_args = { "-r", out_path }
        end

        return {
            cmd = lang_cmd,
            args = lang_args,
            components = { { "on_output_quickfix", open = true }, "default" },
        }
    end,
    condition = {
        filetype = { "c", "cpp", "make" },
    },
}
