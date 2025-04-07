return {
    name = "cmake .. --debug",
    builder = function()
        local Util = require("util")
        local file = vim.api.nvim_buf_get_name(0)   -- get full path of current file
        local path = vim.fn.fnamemodify(file, ":h") -- no file name, only need abs path
        local project_root = Util.find_path_on_pattern(path, "/CMakeLists.txt")

        project_root = project_root or current_dir

        return {
            cmd = { "cmake" },
            args = { "-S", project_root, "-B", project_root .. "/build", "-D", "CMAKE_BUILD_TYPE=Debug" },
            components = { { "on_output_quickfix", open = true }, "default" },
        }
    end,
    condition = {
        filetype = { "c", "cpp", "cmake" },
    },
}
