-- General
lvim.format_on_save = true
lvim.lint_on_save = true
lvim.colorscheme = "gruvbox-material"
vim.opt.relativenumber = true

-- Keymappings
lvim.leader = "space"
vim.g.maplocalleader = ","
lvim.keys.insert_mode["<C-l>"] = "<c-g>u<Esc>[s1z=`]a<c-g>u"
lvim.keys.normal_mode["<Localleader>mm"] = "i <++>"
lvim.keys.normal_mode["<Localleader>,"] = "/<++><CR>c4l"
lvim.keys.normal_mode["<localleader>z"] = '"=ZoteroCite()<CR>p'
lvim.keys.insert_mode["<C-z>"] = "<C-r>=ZoteroCite()<CR>"
lvim.builtin.which_key.mappings["gd"] = { "<cmd>DiffviewOpen HEAD~1<cr>", "Diff" }
lvim.builtin.which_key.mappings["tr"] = { "<cmd>RnvimrToggle<cr>", "Ranger" }

-- Plugins
lvim.builtin.dashboard.active = true
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.side = "left"
lvim.builtin.nvimtree.show_icons.git = 1
lvim.builtin.dap.active = true
lvim.builtin.bufferline.active = true

-- Additional Plugins
lvim.plugins = {
	{ "sainnhe/gruvbox-material" },
	{ "reedes/vim-wordy" },
	{ "ray-x/lsp_signature.nvim" },
	{
		"lervag/vimtex",
		config = function()
			vim.g.vimtex_view_method = "zathura"
			vim.g.vimtex_complier_progname = "nvr"
			vim.g.vimtex_fold_enabled = 0
			vim.g.vimtex_view_forward_search_on_start = 1
			vim.g.vimtex_quickfix_open_on_warning = 0
			vim.g.vimtex_quickfix_autoclose_after_keystrokes = 3
			vim.g.vimtex_imaps_enabled = 1
			vim.g.vimtex_complete_img_use_tail = 1
			vim.g.vimtex_complete_bib = {
				simple = 1,
				menu_fmt = "@year, @author_short, @title",
			}
			vim.g.vimtex_echo_verbose_input = 0
			vim.cmd(
				[[
        augroup vimtex_event_1
            au!
            au User VimtexEventQuit     call vimtex#compiler#clean(0)
            au User VimtexEventInitPost call vimtex#compiler#compile()
        augroup END
        ]],
				false
			)
			vim.cmd(
				[[
        function! CloseViewers()
          if executable('xdotool') && exists('b:vimtex')
              \ && exists('b:vimtex.viewer') && b:vimtex.viewer.xwin_id > 0
            call system('xdotool windowclose '. b:vimtex.viewer.xwin_id)
          endif
        endfunction

        augroup vimtex_event_2
          au!
          au User VimtexEventQuit call CloseViewers()
        augroup END
        ]],
				false
			)
		end,
	},
	{
		"ethanholz/nvim-lastplace",
		event = "BufRead",
		config = function()
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
		"kevinhwang91/rnvimr",
		cmd = "RnvimrToggle",
		config = function()
			vim.g.rnvimr_draw_border = 1
			vim.g.rnvimr_pick_enable = 1
			vim.g.rnvimr_bw_enable = 1
		end,
	},
	{ "sindrets/diffview.nvim" },
	{
		"vim-pandoc/vim-pandoc",
		config = function()
			vim.g["pandoc#modules#disabled"] = { "folding" }
		end,
	},
	{
		"vim-pandoc/vim-pandoc-syntax",
		config = function()
			vim.g["pandoc#syntax#codeblocks#embeds#langs"] = { "python", "r", "cpp", "bash=sh", "latex=tex" }
		end,
	},
	{
		"jalvesaq/Nvim-R",
		config = function()
			vim.g.R_openpdf = 1
			vim.g.Rout_more_colors = 1
			vim.g.R_set_omnifunc = {}
			vim.g.R_auto_omni = {}
		end,
	},
	{
		"dkarter/bullets.vim",
		config = function()
			vim.g.bullets_mapping_leader = "<SPACE>"
			vim.g.bullets_enabled_file_types = {
				"markdown",
				"rmarkdown",
				"rmd",
				"pandoc",
				"vimwiki",
				"text",
				"gitcommit",
				"scratch",
			}
		end,
	},
	{ "dhruvasagar/vim-table-mode" },
	{
		"junegunn/vim-easy-align",
		setup = function()
			vim.api.nvim_set_keymap("x", "ga", "<Plug>(EasyAlign)", { noremap = false, silent = true })
		end,
		keys = "<Plug>(EasyAlign)",
	},
	{
		"norcalli/nvim-colorizer.lua",
		config = function()
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
}

-- treesitter
lvim.builtin.treesitter.ensure_installed = {}
lvim.builtin.treesitter.ignore_install = { "haskell" }
lvim.builtin.treesitter.highlight.enabled = true

-- LSP
lvim.lang.python.formatters = { { exe = "black" } }
lvim.lang.python.linters = { { exe = "flake8" } }
lvim.lang.lua.formatters = { { exe = "stylua" } }
lvim.lang.json.formatters = { { exe = "prettier" } }

-- Autocommands

lvim.autocommands.custom_groups = {
	{ "Filetype", "python", "map <buffer> <leader>bb :w<CR>:exec '!python3' shellescape(@%, 1)<CR>" },
	{
		"Filetype",
		"rmd,qmd,rmarkdown,markdown,md,ipynb",
		"map <buffer> <leader>bb :w<CR>:exec '!quarto render' shellescape(@%, 1)<CR>",
	},
	{
		"Filetype",
		"rmd,qmd,rmarkdown,markdown,md,ipynb",
		"map <buffer> <leader>pp :w<CR>:exec '!quarto preview' shellescape(@%, 1)<CR>",
	},
	{
		"BufNewFile,BufRead",
		"*qmd",
		"set ft=rmd",
	},
	{
		"VimLeave",
		"*.tex",
		"!texclear.sh",
	},
}

--Utilies

vim.cmd("source " .. "$HOME/.config/lvim/utilis.vim")
