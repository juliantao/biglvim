-- General
vim.opt.termguicolors = true
lvim.colorscheme = "gruvbox-material"
vim.opt.relativenumber = true
vim.api.nvim_command("set nofoldenable")
vim.api.nvim_command("set conceallevel=0")
vim.diagnostic.config({ virtual_text = false })
lvim.format_on_save = true
lvim.log.level = "warn"
lvim.lint_on_save = true
vim.g.python3_host_prog = "/usr/bin/python3"
-- vim.cmd("colorscheme gruvbox-material")

-- Keymappings
lvim.leader = "space"
vim.g.maplocalleader = ","
lvim.keys.insert_mode["jk"] = "<ESC>"
lvim.keys.insert_mode["jf"] = " |> "
lvim.keys.insert_mode["jl"] = " <- "
lvim.keys.insert_mode["<M-t>"] = "<Esc>:TOC<CR>"
lvim.keys.normal_mode["<M-t>"] = ":TOC<CR>"
lvim.keys.normal_mode["<C-t>"] = ":ToggleTerm<CR>"
lvim.keys.insert_mode["<C-B>"] = "<c-g>u<Esc>[s1z=]a<c-g>u"
lvim.keys.insert_mode["<C-z>"] = "<C-r>=ZoteroCite()<CR>"
lvim.keys.insert_mode["<Localleader>da"] = "<C-r>=strftime('%F')<CR>"
lvim.keys.insert_mode["<Localleader>tm"] = "<C-r>=strftime('%F', localtime() + 86400)<CR>"
lvim.keys.normal_mode["<Localleader>mm"] = "i <++>"
lvim.keys.normal_mode["<Localleader>,"] = "/<++><CR>c4l"
lvim.keys.normal_mode["<localleader>z"] = '"=ZoteroCite()<CR>p'
lvim.keys.normal_mode["<leader>ii"] = ":PasteImg<CR>"
lvim.keys.normal_mode["<S-l>"] = ":BufferLineCycleNext<CR>"
lvim.keys.normal_mode["<S-h>"] = ":BufferLineCyclePrev<CR>"
lvim.builtin.which_key.mappings["tr"] = { "<cmd>RnvimrToggle<cr>", "Ranger" }

-- Plugins
lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.terminal.active = true

-- Additional Plugins
lvim.plugins = {
	-- colorscheme
	{ "sainnhe/gruvbox-material" },

	-- tpope
	{
		"tpope/vim-surround",
		keys = { "c", "d", "y" },
	},
	{ "tpope/vim-repeat" },

	-- pandoc, quarto, latex, rmarkdown, wiki
	{ "vim-pandoc/vim-pandoc" },
	{
		"vim-pandoc/vim-pandoc-syntax",
		init = function()
			-- vim.g["pandoc#syntax#codeblocks#embeds#langs"] = { "python", "r", "cpp", "bash=sh", "latex=tex" }
			vim.g["pandoc#syntax#conceal#use"] = 0
		end,
	},
	{ "quarto-dev/quarto-vim" },

	-- NEW: Quarto ecosystem plugins
	{
		"quarto-dev/quarto-nvim",
		ft = { "quarto", "markdown" },
		config = function()
			require("quarto").setup({
				debug = false,
				closePreviewOnExit = true,
				lspFeatures = {
					enabled = true,
					languages = { "r", "python", "julia", "bash", "html" },
					chunks = "curly", -- 'curly' or 'all'
					diagnostics = {
						enabled = true,
						triggers = { "BufWritePost" },
					},
					completion = {
						enabled = true,
					},
				},
				codeRunner = {
					enabled = false, -- using your existing terminal setup
					default_method = nil,
				},
			})
		end,
		dependencies = {
			"jmbuhr/otter.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
	},
	{
		"jmbuhr/otter.nvim",
		ft = { "quarto", "markdown", "rmd" },
		config = function()
			require("otter").setup({
				lsp = {
					hover = {
						border = "rounded",
					},
				},
				buffers = {
					set_filetype = true,
					write_to_disk = false,
				},
				strip_wrapping_quote_characters = { '"', "'", "`" },
				handle_leading_whitespace = true,
			})
		end,
	},
	{
		"jmbuhr/cmp-pandoc-references",
		ft = { "markdown", "quarto", "rmarkdown", "rmd", "pandoc" },
		config = function()
			-- This will be configured in the CMP setup below
		end,
	},
	{
		"jmbuhr/telescope-zotero.nvim",
		dependencies = {
			"nvim-telescope/telescope.nvim",
			"nvim-lua/plenary.nvim",
			"kkharji/sqlite.lua",
		},
		config = function()
			-- Only load if sqlite is available
			local ok, _ = pcall(require, "sqlite")
			if ok then
				require("telescope").load_extension("zotero")
			else
				vim.notify("telescope-zotero requires sqlite.lua - please install it", vim.log.levels.WARN)
			end
		end,
	},

	{ "mracos/mermaid.vim" },
	{
		"chrisbra/csv.vim",
		init = function()
			vim.g.csv_nomap_cr = 1
			vim.g.csv_nomap_s_h = 1
			vim.g.csv_nomap_s_l = 1
			vim.g.csv_nomap_leader = 1
			vim.g.csv_nomap_space = 1
		end,
	},
	{
		"lervag/vimtex",
		init = function()
			vim.g.vimtex_view_method = "zathura"
			vim.g.vimtex_fold_enabled = 0
			vim.g.vimtex_view_forward_search_on_start = 1
			vim.g.vimtex_quickfix_open_on_warning = 0
			vim.g.vimtex_quickfix_autoclose_after_keystrokes = 3
			vim.g.vimtex_imaps_enabled = 1
			vim.g.vimtex_complete_bib = {
				simple = 1,
				menu_fmt = "@year, @author_short, @title",
			}
			vim.g.vimtex_echo_verbose_input = 0
			vim.cmd([[
        augroup vimtex_event_1
            au!
            au User VimtexEventQuit    VimtexClean
            " au User VimtexEventInitPost VimtexCompile
        augroup END
        ]])
			vim.cmd([[
        function! CloseViewers()
          if executable('xdotool')
                \ && exists('b:vimtex.viewer.xwin_id')
                \ && b:vimtex.viewer.xwin_id > 0
            call system('xdotool windowclose '. b:vimtex.viewer.xwin_id)
          endif
        endfunction

        augroup vimtex_event_2
          au!
          au User VimtexEventQuit call CloseViewers()
        augroup END
        ]])
		end,
	},
	{
		"vimwiki/vimwiki",
		branch = "dev",
		init = function()
			vim.g.vimwiki_list = {
				{
					path = "~/Dropbox (ASU)/wiki",
					syntax = "markdown",
					diary_header = "Journal",
					auto_diary_index = 1,
					auto_generate_links = 1,
					auto_generate_tags = 1,
					ext = ".qmd",
				},
			}
			vim.g.vimwiki_commentstring = "<!--%s-->"
			vim.g.vimwiki_folding = ""
			vim.g.vimwiki_conceallevel = 0
			vim.g.vimwiki_markdown_link_ext = 1
			vim.g.vimwiki_filetypes = { "quarto" }
			vim.g.vimwiki_key_mappings = { table_mappings = 0, lists_return = 1 }
			vim.g.vimwiki_global_ext = 0
		end,
	},
	{
		"jalvesaq/Nvim-R",
		init = function()
			vim.g.R_openpdf = 1
			vim.g.Rout_more_colors = 1
			vim.g.R_set_omnifunc = {}
			vim.g.R_auto_omni = {}
			vim.g.markdown_fenced_languages = { "r", "python", "bash", "css", "html", "cpp", "latex" }
			vim.g.rmd_fenced_languages = { "r", "python", "bash", "css", "html", "cpp", "latex" }
			vim.g.R_filetypes = { "r", "rmd", "rrst", "rnoweb", "rhelp" }
		end,
	},
	{
		"folke/todo-comments.nvim",
		event = "BufRead",
		init = function()
			require("todo-comments").setup()
		end,
	},
	{
		"JoosepAlviste/nvim-ts-context-commentstring",
		inti = function()
			require("ts_context_commenting").setup()
			vim.g.skip_ts_context_commentstring_module = true
		end,
	},
	-- prose writing
	{ "reedes/vim-wordy" },
	{
		"juliantao/clipboard-image.nvim",
		init = function()
			require("clipboard-image").setup({
				default = {
					img_name = function()
						vim.fn.inputsave()
						local name = vim.fn.input("Name: ")
						vim.fn.inputrestore()
						return name
					end,
					affix = "![](%s)",
				},
			})
		end,
	},
	{ "godlygeek/tabular" },
	{
		"dhruvasagar/vim-table-mode",
		init = function()
			vim.g.table_mode_corner = "|"
		end,
	},
	{
		"junegunn/vim-easy-align",
		init = function()
			vim.api.nvim_set_keymap("x", "ga", "<Plug>(EasyAlign)", { noremap = false, silent = true })
		end,
		keys = "<Plug>(EasyAlign)",
	},
	{
		"jackMort/ChatGPT.nvim",
		event = "VeryLazy",
		config = function()
			require("chatgpt").setup()
		end,
		dependencies = {
			"MunifTanjim/nui.nvim",
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
		},
	},

	-- lsp
	{ "ray-x/lsp_signature.nvim" },

	-- general interface
	{
		"norcalli/nvim-colorizer.lua",
		init = function()
			require("colorizer").setup({ "*" }, {
				RGB = true, -- #RGB hex codes
				RRGGBB = true, -- #RRGGBB hex codes
				RRGGBBAA = true, -- #RRGGBBAA hex codes
				rgb_fn = true, -- CSS rgb() and rgba() functions
				hsl_fn = true, -- CSS hsl() and hsla() functions
				css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
				css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
			})
		end,
	},
	{
		"ethanholz/nvim-lastplace",
		event = "BufRead",
		init = function()
			require("nvim-lastplace").setup({
				lastplace_ignore_buftype = { "quickfix", "nofile", "help" },
				lastplace_ignore_filetype = {
					"gitcommit",
					"gitrebase",
					"svn",
					"hgcommit",
				},
				lastplace_open_folds = true,
			})
		end,
	},
	{
		"itchyny/calendar.vim",
		init = function()
			vim.g.calendar_google_calendar = 1
			vim.g.calendar_google_task = 1
		end,
	},
	{
		"kevinhwang91/rnvimr",
		cmd = "RnvimrToggle",
		init = function()
			vim.g.rnvimr_draw_border = 1
			vim.g.rnvimr_pick_enable = 1
			vim.g.rnvimr_bw_enable = 1
		end,
	},
	{ "sindrets/diffview.nvim" },
	{
		"pwntester/octo.nvim",
		init = function()
			require("octo").setup()
		end,
	},

	-- languages
	{ "sirtaj/vim-openscad" },
	{ "lambdalisue/vim-suda" },
}

--Builtin Plugins
require("nvim-web-devicons").set_icon({
	zsh = {
		icon = "",
		color = "#428850",
		name = "Zsh",
	},
	qmd = {
		icon = "",
		color = "#519aba",
		name = "qmd",
	},
	dot = {
		icon = "ﰟ",
		color = "#FFB13B",
		name = "dot",
	},
	bib = {
		icon = "ﭨ",
		color = "#3D6117",
		name = "bib",
	},
	cls = {
		icon = "ﭨ",
		color = "#3D6117",
		name = "cls",
	},
	bst = {
		icon = "ﭨ",
		color = "#3D6117",
		name = "bst",
	},
	csl = {
		icon = "謹",
		color = "#e37933",
		cterm_color = "173",
		name = "csl",
	},
	docx = {
		icon = "",
		color = "#2b579a",
		name = "docx",
	},
	pptx = {
		icon = "蠟",
		color = "#d24726",
		name = "pptx",
	},
	xlsx = {
		icon = "",
		color = "#217346",
		name = "xlsx",
	},
})

-- treesitter
lvim.builtin.treesitter.ensure_installed = {}
lvim.builtin.treesitter.highlight.disable = { "markdown" }

-- LSP
require("lspconfig").r_language_server.setup({ filetypes = { "r", "rmd", "quarto" } })
require("lspconfig").lua_ls.setup({})
require("lspconfig").dotls.setup({})
require("lspconfig").pyright.setup({})
require("lspconfig").cssls.setup({})
require("lspconfig").arduino_language_server.setup({})

-- require("lspconfig").ltex.setup({ filetypes = { "rmd", "bib", "tex", "quarto", "markdown" } })
-- require("lspconfig").grammarly.setup({ filetypes = { "rmd", "tex", "qmd", "markdown", "vimwiki" } })

-- Enhanced CMP setup for pandoc references
lvim.builtin.cmp.sources = vim.list_extend(lvim.builtin.cmp.sources or {}, {
	{ name = "pandoc_references" },
	{ name = "otter" },
})

-- Snippet
require("luasnip.loaders.from_vscode").load({ paths = { "~/.config/lvim/snips" } })

-- Autocommands
vim.api.nvim_create_autocmd("BufWinEnter", {
	pattern = { "*.qmd" },
	command = "set ft=pandoc.quarto",
})

vim.api.nvim_create_autocmd("BufNewFile", {
	pattern = { "*.qmd" },
	command = "set ft=pandoc.quarto",
})

vim.api.nvim_create_autocmd("BufRead", {
	pattern = { "*.qmd" },
	command = "set ft=pandoc.quarto",
})

-- Enhanced Quarto autocommands
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "quarto" },
	callback = function()
		-- Activate otter for embedded language support
		require("otter").activate({ "r", "python", "julia", "bash", "html" })
	end,
})

vim.api.nvim_create_autocmd("Filetype", {
	pattern = { "python" },
	command = "map <buffer> <leader>bb :TermExec cmd='python3 %:S'<CR> <C-j>",
})
vim.api.nvim_create_autocmd("Filetype", {
	pattern = { "mermaid" },
	command = "map <buffer> <leader>bb :TermExec cmd='mmdc -i %:S -o $(basename %:S .mmd).pdf -f\\|gopen $(basename %:S .mmd).pdf'<CR> <C-t>",
})
vim.api.nvim_create_autocmd("Filetype", {
	pattern = { "quarto", "rmd", "Rmd", "qmd", "rmarkdown", "markdown", "md", "ipynb", "vimwiki" },
	command = "cd .",
})
vim.api.nvim_create_autocmd("Filetype", {
	pattern = { "quarto", "rmd", "Rmd", "qmd", "rmarkdown", "markdown", "md", "ipynb", "vimwiki" },
	command = "map <buffer> <leader>bb :TermExec cmd='quarto render %:S'<CR> <C-j>",
})
vim.api.nvim_create_autocmd("Filetype", {
	pattern = { "quarto", "rmd", "Rmd", "qmd", "rmarkdown", "markdown", "md", "ipynb", "vimwiki" },
	command = "map <buffer> <leader>qq :TermExec cmd='quarto preview %:S'<CR> <C-j>",
})
vim.api.nvim_create_autocmd("Filetype", {
	pattern = { "quarto", "rmd", "Rmd", "qmd", "rmarkdown", "markdown", "md", "ipynb", "vimwiki" },
	command = "map <buffer> <localleader>ll :TermExec cmd='quarto preview --profile local %:S'<CR> <C-j>",
})

-- Additional Quarto/Zotero keymaps (only if zotero extension is loaded)
vim.api.nvim_create_autocmd("User", {
	pattern = "TelescopePreviewerLoaded",
	callback = function()
		local ok, _ = pcall(require, "telescope._extensions.zotero")
		if ok then
			lvim.builtin.which_key.mappings["z"] = {
				name = "Zotero",
				z = { "<cmd>Telescope zotero<cr>", "Search Zotero" },
				i = { "<cmd>lua require('telescope').extensions.zotero.insert_citation()<cr>", "Insert Citation" },
			}
		end
	end,
})

-- Otter-specific keymaps for embedded code
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "quarto", "markdown", "rmd" },
	callback = function()
		vim.keymap.set(
			"n",
			"<localleader>op",
			require("otter").ask_type_definition,
			{ desc = "Type definition (otter)" }
		)
		vim.keymap.set("n", "<localleader>oh", require("otter").ask_hover, { desc = "Hover (otter)" })
		vim.keymap.set("n", "<localleader>od", require("otter").ask_definition, { desc = "Definition (otter)" })
		vim.keymap.set("n", "<localleader>or", require("otter").ask_references, { desc = "References (otter)" })
		vim.keymap.set("n", "<localleader>orn", require("otter").ask_rename, { desc = "Rename (otter)" })
		vim.keymap.set("n", "<localleader>of", require("otter").ask_format, { desc = "Format (otter)" })
	end,
})

vim.api.nvim_create_user_command("ResponsePattern", function(opts)
	local count = tonumber(opts.args) or 10 -- Default to 10 if no argument is provided
	local lines = {}
	for i = 1, count do
		table.insert(lines, "### Comment " .. i)
		table.insert(lines, "")
		table.insert(lines, "[Response " .. i .. "]{.highlight}")
		table.insert(lines, "")
	end
	vim.api.nvim_buf_set_lines(0, -1, -1, false, lines)
end, {
	nargs = "?",
}) -- Optional argument for number of repetitions

--Utilies
vim.cmd("source " .. "$HOME/.config/lvim/utilis.vim")
