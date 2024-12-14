return {
    name = "build file(c/c++)",
    builder = function()
        local lang_cmd = {}
        local lang_args = {}

        local function file_exists(filepath)
            local stat = vim.loop.fs_stat(filepath)
            return stat ~= nil
        end

        local work_path = vim.fn.getcwd()                   -- get current work directory path
        local file = vim.api.nvim_buf_get_name(0)           -- get full path of current file
        local current_path = vim.fn.fnamemodify(file, ":h") -- no file name, only need abs path
        local current_makefile_path = current_path .. "/Makefile"
        local build_makefile_path = current_path .. "/build/Makefile"
        local work_makefile_path = work_path .. "/build/Makefile"

        if file_exists(current_makefile_path) then
            -- It is makefile project. the makefile is in current path
            lang_cmd = { "make" }
            lang_args = { "-j6" }
        elseif file_exists(build_makefile_path) or file_exists(work_makefile_path) then
            -- It is cmake project. the makefile is in the ./build
            lang_cmd = { "make" }

            if file_exists(build_makefile_path) then
                lang_args = { "-C", current_path .. "/build/", "-s", "-j6" }
            else
                lang_args = { "-C", work_path .. "/build/", "-s", "-j6" }
            end
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
        filetype = { "c", "cpp" },
    },
}
