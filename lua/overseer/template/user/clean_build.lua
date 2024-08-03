return {
    name = "clean build(c/c++)",
    builder = function()
        local lang_cmd = {}
        local lang_args = {}

        local function file_exists(filepath)
            local stat = vim.loop.fs_stat(filepath)
            return stat ~= nil
        end

        local current_path = vim.fn.getcwd()
        local current_makefile_path = current_path .. "/Makefile"
        local build_makefile_path = current_path .. "/build/Makefile"
        if file_exists(current_makefile_path) then
            -- It is makefile project. the makefile is in current path
            lang_cmd = { "make" }
            lang_args = { "clean" }
        elseif file_exists(build_makefile_path) then
            -- It is cmake project. the makefile is in the ./build
            lang_cmd = { "make" }
            lang_args = { "clean", "-C", current_path .. "/build/", "-s" }
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
        filetype = { "c", "cpp" },
    },
}
