-- lvim.lang.python.formatters = { { exe = "black" } }
-- lvim.lang.python.linters = {
-- 	{ exe = "flake8", args = { "--ignore", "E501, E266, E265" } },
-- }

local formatters = require("lvim.lsp.null-ls.formatters")
formatters.setup({
	{ exe = "black" },
})

local linters = require("lvim.lsp.null-ls.linters")

linters.setup({
	{
		exe = "flake8",
		args = { "--ignore", "E501, E266, E265" },
	},
})
