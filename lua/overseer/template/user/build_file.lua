return {
    name = "build file(c/c++)",
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
            lang_args = { "-C", project_root, "-s", "-j6" }
        elseif build_root ~= nil and vim.loop.fs_stat(build_root .. "build/Makefile") ~= nil then
            -- It is a cmake project. the makefile is in the /build dir
            lang_cmd = { "make" }
            lang_args = { "-C", build_root .. "/build/", "-s", "-j6" }
        else
            -- It is singal file. no makefile. just use the gcc/g++ to compile
            local ft = vim.bo.filetype
            local out_path = current_path .. "/build/"

            if ft == "c" then
                -- 'gcc -g' means debug support
                vim.cmd("silent !mkdir -p " .. out_path)
                lang_cmd = { "gcc" }
                lang_args = { "-g", file, "-o", out_path .. "demo" }
            elseif ft == "cpp" then
                vim.cmd("silent !mkdir -p " .. out_path)
                lang_cmd = { "g++" }
                lang_args = { "-g", "-std=c++11", file, "-o", out_path .. "demo" }
            end
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
