return {
    name = "cmake .. --debug",
    builder = function()
        local file = vim.api.nvim_buf_get_name(0)  -- get full path of current file
        local path = vim.fn.fnamemodify(file, ":h")  -- no file name, only need abs path
        return {
            cmd = { "cmake" },
            args = { "-S", path, "-B", path .. "/build", "-D", "CMAKE_BUILD_TYPE=Debug" },
            components = { { "on_output_quickfix", open = true }, "default" },
        }
    end,
    condition = {
        filetype = { "c", "cpp" },
    },
}
