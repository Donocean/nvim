return {

	-- gruvbox
	{
		"morhetz/gruvbox",
		lazy = false,
        priority = 1000
	},

    --  everforest
    {
        "neanias/everforest-nvim",
        version = false,
        lazy = false,
        -- make sure to load this before all the other start plugins, this is a file
        priority = 1000,
        -- Optional; default configuration will be used if setup isn't called.
        config = function()
            require("everforest").setup({
                -- Your config here
            })
        end,
    },
}
