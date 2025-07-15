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
lvim.keys.insert_mode["<C-B>"] = "<c-g>u<Esc>[s1z=`]a<c-g>u"
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
	-- { "jmbuhr/otter.nvim" },
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
	-- {
	-- 	"tools-life/taskwiki",
	-- 	init = function()
	-- 		-- vim.g.taskwiki_disable = true
	-- 		vim.g.taskwiki_dont_preserve_folds = "yes"
	-- 		vim.g.taskwiki_disable_concealcursor = "yes"
	-- 		vim.g.taskwiki_sort_order = "project+,due+,id+,priority-"
	-- 		vim.g.taskwiki_maplocalleader = ",t"
	-- 	end,
	-- },
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
	-- {
	-- 	"metakirby5/codi.vim",
	-- 	cmd = "Codi",
	-- },
	{ "sirtaj/vim-openscad" },
	{ "lambdalisue/vim-suda" },
}

--Builtin Plugins
require("nvim-web-devicons").set_icon({
	zsh = {
		icon = "",
		color = "#428850",
		name = "Zsh",
	},
	qmd = {
		icon = "",
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
		icon = "謹",
		color = "#e37933",
		cterm_color = "173",
		name = "csl",
	},
	docx = {
		icon = "",
		color = "#2b579a",
		name = "docx",
	},
	pptx = {
		icon = "蠟",
		color = "#d24726",
		name = "pptx",
	},
	xlsx = {
		icon = "",
		color = "#217346",
		name = "xlsx",
	},
})

-- treesitter
lvim.builtin.treesitter.ensure_installed = {}
lvim.builtin.treesitter.highlight.disable = { "markdown" }

-- LSP
require("lspconfig").r_language_server.setup({ filetypes = { "r", "rmd" } })
require("lspconfig").lua_ls.setup({})
require("lspconfig").dotls.setup({})
require("lspconfig").pyright.setup({})
require("lspconfig").cssls.setup({})
require("lspconfig").arduino_language_server.setup({})

-- require("lspconfig").ltex.setup({ filetypes = { "rmd", "bib", "tex", "quarto", "markdown" } })
-- require("lspconfig").grammarly.setup({ filetypes = { "rmd", "tex", "qmd", "markdown", "vimwiki" } })

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
--Utilies

vim.cmd("source " .. "$HOME/.config/lvim/utilis.vim")
