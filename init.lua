--This file contains basic Vim configs and options, and sets up Lazy.nvim.
-- All plugins are defined in, and managed in their own files

do
	-- Enable faster startup by caching compiled Lua modules
	vim.loader.enable()
	-- Set <space> as the leader key
	-- See `:help mapleader`
	--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
	vim.g.mapleader = " "
	vim.g.maplocalleader = " "

	-- Set to true if you have a Nerd Font installed and selected in the terminal
	vim.g.have_nerd_font = true

	-- Make line numbers default
	vim.opt.number = true
	vim.opt.relativenumber = true

	-- [[ Setting options ]]

	vim.opt.swapfile = false
	vim.opt.backup = false
	vim.opt.errorbells = false

	-- configure tabs
	vim.opt.tabstop = 2
	vim.opt.shiftwidth = 2
	vim.opt.expandtab = true

	-- Enable mouse mode, can be useful for resizing splits for example!
	vim.opt.mouse = "a"

	-- Don't show the mode, since it's already in the status line
	vim.opt.showmode = true

	-- Sync clipboard between OS and Neovim.
	--  Schedule the setting after `UiEnter` because it can increase startup-time.
	--  Remove this option if you want your OS clipboard to remain independent.
	--  See `:help 'clipboard'`
	vim.schedule(function()
		vim.o.clipboard = "unnamedplus"
	end)

	-- Enable break indent
	vim.opt.breakindent = true

	-- Save undo history
	vim.opt.undofile = true

	-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
	vim.opt.ignorecase = true
	vim.opt.smartcase = true

	-- Keep signcolumn on by default
	vim.opt.signcolumn = "yes"

	-- Decrease update time
	vim.opt.updatetime = 250

	-- Decrease mapped sequence wait time
	-- Displays which-key popup sooner
	vim.opt.timeoutlen = 300

	-- Configure how new splits should be opened
	vim.opt.splitright = true
	vim.opt.splitbelow = true

	-- Sets how neovim will display certain whitespace characters in the editor.
	--  See `:help 'list'`
	--  and `:help 'listchars'`
	vim.opt.list = true
	vim.opt.listchars = {
		tab = "| ",
		trail = "·",
		nbsp = "␣",
	}

	-- Preview substitutions live, as you type!
	vim.opt.inccommand = "split"

	-- Show which line your cursor is on
	vim.opt.cursorline = true

	-- Minimal number of screen lines to keep above and below the cursor.
	vim.opt.scrolloff = 5

	-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
	-- instead raise a dialog asking if you wish to save the current file(s)
	-- See `:help 'confirm'`
	vim.o.confirm = true
end

-- [[ Basic Keymaps ]]

do
	-- remap 'jj' to Esc
	vim.keymap.set("i", "jj", "<Esc>")

	-- Set highlight on search, but clear on pressing <Esc> in normal mode
	vim.opt.hlsearch = true
	vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
	vim.keymap.set("n", "<leader>V", "ggVG", { desc = "Select All" })
	vim.keymap.set("n", "<leader>v", ":vsp<CR>", { desc = "Vertical Split" })

	vim.keymap.set("n", "<leader>w", ":w<CR>")
	vim.keymap.set("v", "<C-r>", '"hy:%s/<C-r>h/<C-r>h/g<left><left>', { desc = "Find/Replace Selected Text" })
	-- vim.keymap.set("n", ";", ":", { desc = "CMD enter command mode" })

	-- resizing windows
	vim.keymap.set({ "n", "v" }, "<C-Left>", ":vertical resize +3<CR>", { desc = "Move Window Border Left" })
	vim.keymap.set({ "n", "v" }, "<C-Right>", ":vertical resize -3<CR>", { desc = "Move Window Border Right" })
	vim.keymap.set({ "n", "v" }, "<C-Up>", ": resize -3<CR>", { desc = "Move Window Border Up" })
	vim.keymap.set({ "n", "v" }, "<C-Down>", ": resize +3<CR>", { desc = "Move Window Border Down" })
	vim.cmd([[let g:tmux_naviagtor_preserve_zoom = 1]]) -- disable moving to other tmux windows when current window is zoomed

	-- Keybinds to make split navigation easier.
	--  Use CTRL+<hjkl> to switch between windows
	--
	--  See `:help wincmd` for a list of all window commands
	vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
	vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
	vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
	vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

	vim.keymap.set("n", "<Tab>", ":bnext\n", { desc = "Move to the next buffer" })
	vim.keymap.set("n", "<S-Tab>", ":bprevious\n", { desc = "Move to the last buffer" })

	-- Diagnostic Config & Keymaps
	--  See `:help vim.diagnostic.Opts`
	vim.diagnostic.config({
		update_in_insert = false,
		severity_sort = true,
		float = { border = "rounded", source = "if_many" },
		underline = { severity = { min = vim.diagnostic.severity.WARN } },

		-- Can switch between these as you prefer
		virtual_text = true, -- Text shows up at the end of the line
		virtual_lines = false, -- Text shows up underneath the line, with virtual lines

		-- Auto open the float, so you can easily read the errors when jumping with `[d` and `]d`
		jump = {
			on_jump = function(_, bufnr)
				vim.diagnostic.open_float({
					bufnr = bufnr,
					scope = "cursor",
					focus = false,
				})
			end,
		},
	})

	vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" })
	vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

	-- [[ Basic Autocommands ]]
	--  See `:help lua-guide-autocommands`

	-- Highlight when yanking (copying) text
	--  Try it with `yap` in normal mode
	--  See `:help vim.highlight.on_yank()`
	vim.api.nvim_create_autocmd("TextYankPost", {
		desc = "Highlight when yanking (copying) text",
		group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
		callback = function()
			vim.highlight.on_yank()
		end,
	})
end

do
	-- [[ Intro to `vim.pack` ]]
	-- `vim.pack` is a new plugin manager built into Neovim,
	--  which provides a Lua interface for installing and managing plugins.
	--
	--  See `:help vim.pack`, `:help vim.pack-examples` or the
	--  excellent blog post from the creator of vim.pack and mini.nvim:
	--  https://echasnovski.com/blog/2026-03-13-a-guide-to-vim-pack
	--
	--  To inspect plugin state and pending updates, run
	--    :lua vim.pack.update(nil, { offline = true })
	--
	--  To update plugins, run
	--    :lua vim.pack.update()
	--
	--
	--  Throughout the rest of the config there will be examples
	--  of how to install and configure plugins using `vim.pack`.
	--
	--  In this section we set up some autocommands to run build
	--  steps for certain plugins after they are installed or updated.

	local function run_build(name, cmd, cwd)
		local result = vim.system(cmd, { cwd = cwd }):wait()
		if result.code ~= 0 then
			local stderr = result.stderr or ""
			local stdout = result.stdout or ""
			local output = stderr ~= "" and stderr or stdout
			if output == "" then
				output = "No output from build command."
			end
			vim.notify(("Build failed for %s:\n%s"):format(name, output), vim.log.levels.ERROR)
		end
	end

	-- This autocommand runs after a plugin is installed or updated and
	--  runs the appropriate build command for that plugin if necessary.
	--
	-- See `:help vim.pack-events`
	vim.api.nvim_create_autocmd("PackChanged", {
		callback = function(ev)
			local name = ev.data.spec.name
			local kind = ev.data.kind
			if kind ~= "install" and kind ~= "update" then
				return
			end

			if name == "telescope-fzf-native.nvim" and vim.fn.executable("make") == 1 then
				run_build(name, { "make" }, ev.data.path)
				return
			end

			if name == "LuaSnip" then
				if vim.fn.has("win32") ~= 1 and vim.fn.executable("make") == 1 then
					run_build(name, { "make", "install_jsregexp" }, ev.data.path)
				end
				return
			end

			if name == "nvim-treesitter" then
				if not ev.data.active then
					vim.cmd.packadd("nvim-treesitter")
				end
				vim.cmd("TSUpdate")
				return
			end
		end,
	})
end

---Because most plugins are hosted on GitHub, you can use the helper
---function to have less repetition in the following sections.
---@param repo string
---@return string
local function gh(repo)
	return "https://github.com/" .. repo
end

-- ============================================================
-- SECTION 5: SEARCH & NAVIGATION
-- Telescope setup, keymaps, LSP picker mappings
-- ============================================================
do
	-- [[ Fuzzy Finder (files, lsp, etc) ]]
	--
	-- Telescope is a fuzzy finder that comes with a lot of different things that
	-- it can fuzzy find! It's more than just a "file finder", it can search
	-- many different aspects of Neovim, your workspace, LSP, and more!
	--
	-- There are lots of other alternative pickers (like snacks.picker, or fzf-lua)
	-- so feel free to experiment and see what you like!
	--
	-- The easiest way to use Telescope, is to start by doing something like:
	--  :Telescope help_tags
	--
	-- After running this command, a window will open up and you're able to
	-- type in the prompt window. You'll see a list of `help_tags` options and
	-- a corresponding preview of the help.
	--
	-- Two important keymaps to use while in Telescope are:
	--  - Insert mode: <c-/>
	--  - Normal mode: ?
	--
	-- This opens a window that shows you all of the keymaps for the current
	-- Telescope picker. This is really useful to discover what Telescope can
	-- do as well as how to actually do it!

	---@type (string|vim.pack.Spec)[]
	local telescope_plugins = {
		gh("nvim-lua/plenary.nvim"),
		gh("nvim-telescope/telescope.nvim"),
		gh("nvim-telescope/telescope-ui-select.nvim"),
	}
	if vim.fn.executable("make") == 1 then
		table.insert(telescope_plugins, gh("nvim-telescope/telescope-fzf-native.nvim"))
	end

	-- NOTE: You can install multiple plugins at once
	vim.pack.add(telescope_plugins)

	-- See `:help telescope` and `:help telescope.setup()`
	require("telescope").setup({
		-- You can put your default mappings / updates / etc. in here
		--  All the info you're looking for is in `:help telescope.setup()`
		--
		-- defaults = {
		--   mappings = {
		--     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
		--   },
		-- },
		-- pickers = {}
		extensions = {
			["ui-select"] = { require("telescope.themes").get_dropdown() },
		},
	})

	-- Enable Telescope extensions if they are installed
	pcall(require("telescope").load_extension, "fzf")
	pcall(require("telescope").load_extension, "ui-select")

	-- See `:help telescope.builtin`
	local builtin = require("telescope.builtin")
	vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
	vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
	vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
	vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
	vim.keymap.set({ "n", "v" }, "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
	vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
	vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
	vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
	vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
	vim.keymap.set("n", "<leader>sc", builtin.commands, { desc = "[S]earch [C]ommands" })
	vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })
	vim.keymap.set(
		"n",
		"<leader>sa",
		":Telescope find_files no_ignore=true hidden=true<CR>",
		{ desc = "[S]earch [A]ll files" }
	)
	vim.keymap.set("n", "<leader>sm", ":Telescope notify<CR>", { desc = "[S]earch [M]essages" })
	vim.keymap.set("n", "<leader>so", builtin.colorscheme, { desc = "[S]earch C[o]lorscheme" })

	-- Add Telescope-based LSP pickers when an LSP attaches to a buffer.
	-- If you later switch picker plugins, this is where to update these mappings.
	vim.api.nvim_create_autocmd("LspAttach", {
		group = vim.api.nvim_create_augroup("telescope-lsp-attach", { clear = true }),
		callback = function(event)
			local buf = event.buf

			-- Find references for the word under your cursor.
			vim.keymap.set("n", "grr", builtin.lsp_references, { buffer = buf, desc = "[G]oto [R]eferences" })

			-- Jump to the implementation of the word under your cursor.
			-- Useful when your language has ways of declaring types without an actual implementation.
			vim.keymap.set("n", "gri", builtin.lsp_implementations, { buffer = buf, desc = "[G]oto [I]mplementation" })

			-- Jump to the definition of the word under your cursor.
			-- This is where a variable was first declared, or where a function is defined, etc.
			-- To jump back, press <C-t>.
			vim.keymap.set("n", "grd", builtin.lsp_definitions, { buffer = buf, desc = "[G]oto [D]efinition" })

			-- Fuzzy find all the symbols in your current document.
			-- Symbols are things like variables, functions, types, etc.
			vim.keymap.set("n", "gO", builtin.lsp_document_symbols, { buffer = buf, desc = "Open Document Symbols" })

			-- Fuzzy find all the symbols in your current workspace.
			-- Similar to document symbols, except searches over your entire project.
			vim.keymap.set(
				"n",
				"gW",
				builtin.lsp_dynamic_workspace_symbols,
				{ buffer = buf, desc = "Open Workspace Symbols" }
			)

			-- Jump to the type of the word under your cursor.
			-- Useful when you're not sure what type a variable is and you want to see
			-- the definition of its *type*, not where it was *defined*.
			vim.keymap.set(
				"n",
				"grt",
				builtin.lsp_type_definitions,
				{ buffer = buf, desc = "[G]oto [T]ype Definition" }
			)
		end,
	})

	-- Override default behavior and theme when searching
	vim.keymap.set("n", "<leader>/", function()
		-- You can pass additional configuration to Telescope to change the theme, layout, etc.
		builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
			winblend = 10,
			previewer = false,
		}))
	end, { desc = "[/] Fuzzily search in current buffer" })

	-- It's also possible to pass additional configuration options.
	--  See `:help telescope.builtin.live_grep()` for information about particular keys
	vim.keymap.set("n", "<leader>s/", function()
		builtin.live_grep({
			grep_open_files = true,
			prompt_title = "Live Grep in Open Files",
		})
	end, { desc = "[S]earch [/] in Open Files" })

	-- Shortcut for searching your Neovim configuration files
	vim.keymap.set("n", "<leader>sn", function()
		builtin.find_files({ cwd = vim.fn.stdpath("config"), follow = true })
	end, { desc = "[S]earch [N]eovim files" })
end

-- ============================================================
-- SECTION 6: LSP
-- LSP keymaps, server configuration, Mason tools installations
-- ============================================================
do
	-- Useful status updates for LSP.
	vim.pack.add({ gh("j-hui/fidget.nvim") })
	require("fidget").setup({})

	--  This function gets run when an LSP attaches to a particular buffer.
	--    That is to say, every time a new file is opened that is associated with
	--    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
	--    function will be executed to configure the current buffer
	vim.api.nvim_create_autocmd("LspAttach", {
		group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
		callback = function(event)
			-- NOTE: Remember that Lua is a real programming language, and as such it is possible
			-- to define small helper and utility functions so you don't have to repeat yourself.
			--
			-- In this case, we create a function that lets us more easily define mappings specific
			-- for LSP related items. It sets the mode, buffer and description for us each time.
			local map = function(keys, func, desc, mode)
				mode = mode or "n"
				vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
			end

			-- Rename the variable under your cursor.
			--  Most Language Servers support renaming across files, etc.
			map("grn", vim.lsp.buf.rename, "[R]e[n]ame")

			-- Execute a code action, usually your cursor needs to be on top of an error
			-- or a suggestion from your LSP for this to activate.
			map("gra", vim.lsp.buf.code_action, "[G]oto Code [A]ction", { "n", "x" })

			-- WARN: This is not Goto Definition, this is Goto Declaration.
			--  For example, in C this would take you to the header.
			map("grD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

			-- The following two autocommands are used to highlight references of the
			-- word under your cursor when your cursor rests there for a little while.
			--    See `:help CursorHold` for information about when this is executed
			--
			-- When you move your cursor, the highlights will be cleared (the second autocommand).
			local client = vim.lsp.get_client_by_id(event.data.client_id)
			if client and client:supports_method("textDocument/documentHighlight", event.buf) then
				local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
				vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
					buffer = event.buf,
					group = highlight_augroup,
					callback = vim.lsp.buf.document_highlight,
				})

				vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
					buffer = event.buf,
					group = highlight_augroup,
					callback = vim.lsp.buf.clear_references,
				})

				vim.api.nvim_create_autocmd("LspDetach", {
					group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
					callback = function(event2)
						vim.lsp.buf.clear_references()
						vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
					end,
				})
			end

			-- The following code creates a keymap to toggle inlay hints in your
			-- code, if the language server you are using supports them
			--
			-- This may be unwanted, since they displace some of your code
			if client and client:supports_method("textDocument/inlayHint", event.buf) then
				map("<leader>th", function()
					vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
				end, "[T]oggle Inlay [H]ints")
			end
		end,
	})

	-- Enable the following language servers
	--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
	--  See `:help lsp-config` for information about keys and how to configure
	---@type table<string, vim.lsp.Config>
	local servers = {
		clangd = {},
		-- gopls = {},
		pyright = {},
		rust_analyzer = {},
		--
		-- Some languages (like typescript) have entire language plugins that can be useful:
		--    https://github.com/pmizio/typescript-tools.nvim
		--
		-- But for many setups, the LSP (`ts_ls`) will work just fine
		-- ts_ls = {},

		stylua = {}, -- Used to format Lua code

		-- Special Lua Config, as recommended by neovim help docs
		lua_ls = {
			on_init = function(client)
				client.server_capabilities.documentFormattingProvider = false -- Disable formatting (formatting is done by stylua)

				if client.workspace_folders then
					local path = client.workspace_folders[1].name
					if
						path ~= vim.fn.stdpath("config")
						and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
					then
						return
					end
				end

				client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
					runtime = {
						version = "LuaJIT",
						path = { "lua/?.lua", "lua/?/init.lua" },
					},
					workspace = {
						checkThirdParty = false,
						-- NOTE: this is a lot slower and will cause issues when working on your own configuration.
						--  See https://github.com/neovim/nvim-lspconfig/issues/3189
						library = vim.tbl_extend("force", vim.api.nvim_get_runtime_file("", true), {
							"${3rd}/luv/library",
							"${3rd}/busted/library",
						}),
					},
				})
			end,
			---@type lspconfig.settings.lua_ls
			settings = {
				Lua = {
					format = { enable = false }, -- Disable formatting (formatting is done by stylua)
				},
			},
		},
	}

	vim.pack.add({
		gh("neovim/nvim-lspconfig"),
		gh("mason-org/mason.nvim"),
		gh("mason-org/mason-lspconfig.nvim"),
		gh("WhoIsSethDaniel/mason-tool-installer.nvim"),
	})

	-- Automatically install LSPs and related tools to stdpath for Neovim
	require("mason").setup({})

	-- Ensure the servers and tools above are installed
	--
	-- To check the current status of installed tools and/or manually install
	-- other tools, you can run
	--    :Mason
	--
	-- You can press `g?` for help in this menu.
	local ensure_installed = vim.tbl_keys(servers or {})
	vim.list_extend(ensure_installed, {
		-- You can add other tools here that you want Mason to install
	})

	require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

	for name, server in pairs(servers) do
		vim.lsp.config(name, server)
		vim.lsp.enable(name)
	end
end

vim.keymap.set("n", "<leader>pi", ":checkhealth vim.lsp<CR>", { desc = "LS[P] [I]nfo" })
vim.keymap.set("n", "<leader>pr", ":lsp restart<CR>", { desc = "LS[P] [R]estart" })
vim.keymap.set("n", "<leader>ps", ":lsp enable<CR>", { desc = "LS[P] [S]tart" })
vim.keymap.set("n", "<leader>po", ":lsp disable<CR>", { desc = "LS[P] St[O]p" })
vim.keymap.set("n", "<leader>pl", ":LspLog<CR>", { desc = "LS[P] [L]og" })

-- ============================================================
-- SECTION 7: FORMATTING
-- conform.nvim setup and keymap
-- ============================================================
do
	-- [[ Formatting ]]
	vim.pack.add({ gh("stevearc/conform.nvim") })
	require("conform").setup({
		notify_on_error = false,
		format_on_save = function(bufnr)
			-- You can specify filetypes to autoformat on save here:
			local enabled_filetypes = {
				-- lua = true,
				-- python = true,
			}
			if enabled_filetypes[vim.bo[bufnr].filetype] then
				return { timeout_ms = 500 }
			else
				return nil
			end
		end,
		default_format_opts = {
			lsp_format = "fallback", -- Use external formatters if configured below, otherwise use LSP formatting. Set to `false` to disable LSP formatting entirely.
		},
		-- You can also specify external formatters in here.
		formatters_by_ft = {
			-- rust = { 'rustfmt' },
			-- Conform can also run multiple formatters sequentially
			-- python = { "isort", "black" },
			--
			-- You can use 'stop_after_first' to run the first available formatter from the list
			-- javascript = { "prettierd", "prettier", stop_after_first = true },
		},
	})

	vim.keymap.set({ "n", "v" }, "<leader>f", function()
		require("conform").format({ async = true })
	end, { desc = "[F]ormat buffer" })
end

-- ============================================================
-- SECTION 8: AUTOCOMPLETE & SNIPPETS
-- blink.cmp and luasnip setup
-- ============================================================
do
	-- [[ Snippet Engine ]]

	-- NOTE: You can also specify plugin using a version range for its git tag.
	--  See `:help vim.version.range()` for more info
	vim.pack.add({ { src = gh("L3MON4D3/LuaSnip"), version = vim.version.range("2.*") } })
	require("luasnip").setup({})

	-- `friendly-snippets` contains a variety of premade snippets.
	--    See the README about individual language/framework/plugin snippets:
	--    https://github.com/rafamadriz/friendly-snippets
	--
	-- vim.pack.add { gh 'rafamadriz/friendly-snippets' }
	-- require('luasnip.loaders.from_vscode').lazy_load()

	-- [[ Autocomplete Engine ]]
	vim.pack.add({ { src = gh("saghen/blink.cmp"), version = vim.version.range("1.*") } })
	require("blink.cmp").setup({
		keymap = {
			-- 'default' (recommended) for mappings similar to built-in completions
			--   <c-y> to accept ([y]es) the completion.
			--    This will auto-import if your LSP supports it.
			--    This will expand snippets if the LSP sent a snippet.
			-- 'super-tab' for tab to accept
			-- 'enter' for enter to accept
			-- 'none' for no mappings
			--
			-- For an understanding of why the 'default' preset is recommended,
			-- you will need to read `:help ins-completion`
			--
			-- No, but seriously. Please read `:help ins-completion`, it is really good!
			--
			-- All presets have the following mappings:
			-- <tab>/<s-tab>: move to right/left of your snippet expansion
			-- <c-space>: Open menu or open docs if already open
			-- <c-n>/<c-p> or <up>/<down>: Select next/previous item
			-- <c-e>: Hide menu
			-- <c-k>: Toggle signature help
			--
			-- See `:help blink-cmp-config-keymap` for defining your own keymap
			preset = "default",

			-- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
			--    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
		},

		appearance = {
			-- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
			-- Adjusts spacing to ensure icons are aligned
			nerd_font_variant = "mono",
		},

		completion = {
			-- By default, you may press `<c-space>` to show the documentation.
			-- Optionally, set `auto_show = true` to show the documentation after a delay.
			documentation = { auto_show = false, auto_show_delay_ms = 500 },
		},

		sources = {
			default = { "lsp", "path", "snippets" },
		},

		snippets = { preset = "luasnip" },

		-- Blink.cmp includes an optional, recommended rust fuzzy matcher,
		-- which automatically downloads a prebuilt binary when enabled.
		--
		-- By default, we use the Lua implementation instead, but you may enable
		-- the rust implementation via `'prefer_rust_with_warning'`
		--
		-- See `:help blink-cmp-config-fuzzy` for more information
		fuzzy = { implementation = "lua" },

		-- Shows a signature help window while you type arguments for a function
		signature = { enabled = true },
	})
end

-- ============================================================
-- SECTION 9: TREESITTER
-- Parser installation, syntax highlighting, folds, indentation
-- ============================================================
do
	-- [[ Configure Treesitter ]]
	--  Used to highlight, edit, and navigate code
	--
	--  See `:help nvim-treesitter-intro`

	-- NOTE: You can also specify a branch or a specific commit
	vim.pack.add({ { src = gh("nvim-treesitter/nvim-treesitter"), version = "main" } })

	-- Ensure basic parsers are installed
	local parsers = {
		"bash",
		"c",
		"diff",
		"html",
		"lua",
		"luadoc",
		"markdown",
		"markdown_inline",
		"query",
		"vim",
		"vimdoc",
		"rust",
	}
	require("nvim-treesitter").install(parsers)

	---@param buf integer
	---@param language string
	local function treesitter_try_attach(buf, language)
		-- Check if a parser exists and load it
		if not vim.treesitter.language.add(language) then
			return
		end
		-- Enable syntax highlighting and other treesitter features
		vim.treesitter.start(buf, language)

		-- Enable treesitter based folds
		-- For more info on folds see `:help folds`
		-- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
		-- vim.wo.foldmethod = 'expr'

		-- Check if treesitter indentation is available for this language, and if so enable it
		-- in case there is no indent query, the indentexpr will fallback to the vim's built in one
		local has_indent_query = vim.treesitter.query.get(language, "indents") ~= nil

		-- Enable treesitter based indentation
		if has_indent_query then
			vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
		end
	end

	local available_parsers = require("nvim-treesitter").get_available()
	vim.api.nvim_create_autocmd("FileType", {
		callback = function(args)
			local buf, filetype = args.buf, args.match

			local language = vim.treesitter.language.get_lang(filetype)
			if not language then
				return
			end

			local installed_parsers = require("nvim-treesitter").get_installed("parsers")

			if vim.tbl_contains(installed_parsers, language) then
				-- Enable the parser if it is already installed
				treesitter_try_attach(buf, language)
			elseif vim.tbl_contains(available_parsers, language) then
				-- If a parser is available in `nvim-treesitter`, auto-install it and enable it after the installation is done
				require("nvim-treesitter").install(language):await(function()
					treesitter_try_attach(buf, language)
				end)
			else
				-- Try to enable treesitter features in case the parser exists but is not available from `nvim-treesitter`
				treesitter_try_attach(buf, language)
			end
		end,
	})
end

-- ============================================================
-- SECTION 10: Colorschemes
-- ============================================================
do
	local colorschemes = {
		gh("folke/tokyonight.nvim"),
		gh("morhetz/gruvbox"),
		gh("sainnhe/gruvbox-material"),
		gh("rebelot/kanagawa.nvim"),
		gh("sainnhe/everforest"),
	}
	vim.pack.add(colorschemes)

	-- kanagawa config
	require("kanagawa").setup({
		overrides = function(colors)
			return {
				-- assign a static color to strings
				Comment = { fg = colors.palette.boatYellow2, italic = true },
				Visual = { bg = colors.palette.dragonBlack6, italic = true },
			}
		end,
	})

	vim.cmd.hi("Comment gui=none")
	vim.cmd.colorscheme("kanagawa")
end

-- ============================================================
-- SECTION 11: Other plugins
-- ============================================================

-- ============================================================
-- auto-save.nvim
-- ============================================================
vim.pack.add({ gh("Pocco81/auto-save.nvim") })
require("auto-save").setup({})

-- ============================================================
-- bufferline.nvim
-- visuals for tabs
-- ============================================================
do
	local bufferline = {
		gh("akinsho/bufferline.nvim"),
		gh("nvim-tree/nvim-web-devicons"),
	}
	vim.pack.add(bufferline)

	require("bufferline").setup({
		options = {
			mode = "tabs", -- set to "tabs" to only show tabpages instead
			numbers = "ordinal",
			indicator = {
				style = "underline",
			},
			separator_style = "slant",
			diagnostics = "nvim_lsp",
			diagnostics_indicator = function(count, level, diagnostics_dict, context)
				local icon = level:match("error") and " " or " "
				return " " .. icon .. count
			end,
		},
	})
end

-- ============================================================
-- gitsigns
-- Deep buffer integration for Git
-- ============================================================
do
	vim.pack.add({ gh("lewis6991/gitsigns.nvim") })

	require("gitsigns").setup({
		on_attach = function(bufnr)
			local gitsigns = require("gitsigns")

			local function map(mode, l, r, opts)
				opts = opts or {}
				opts.buffer = bufnr
				vim.keymap.set(mode, l, r, opts)
			end

			-- Navigation
			map("n", "]c", function()
				if vim.wo.diff then
					vim.cmd.normal({ "]c", bang = true })
				else
					gitsigns.nav_hunk("next")
				end
			end, { desc = "Jump to next git [c]hange" })

			map("n", "[c", function()
				if vim.wo.diff then
					vim.cmd.normal({ "[c", bang = true })
				else
					gitsigns.nav_hunk("prev")
				end
			end, { desc = "Jump to previous git [c]hange" })

			-- Actions
			-- visual mode
			map("v", "<leader>hs", function()
				gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end, { desc = "git [s]tage hunk" })
			map("v", "<leader>hr", function()
				gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end, { desc = "git [r]eset hunk" })
			-- normal mode
			map("n", "<leader>hs", gitsigns.stage_hunk, { desc = "git [s]tage hunk" })
			map("n", "<leader>hr", gitsigns.reset_hunk, { desc = "git [r]eset hunk" })
			map("n", "<leader>hS", gitsigns.stage_buffer, { desc = "git [S]tage buffer" })
			map("n", "<leader>hR", gitsigns.reset_buffer, { desc = "git [R]eset buffer" })
			map("n", "<leader>hp", gitsigns.preview_hunk, { desc = "git [p]review hunk" })
			map("n", "<leader>hi", gitsigns.preview_hunk_inline, { desc = "git preview hunk [i]nline" })
			map("n", "<leader>hb", function()
				gitsigns.blame_line({ full = true })
			end, { desc = "git [b]lame line" })
			map("n", "<leader>hd", gitsigns.diffthis, { desc = "git [d]iff against index" })
			map("n", "<leader>hD", function()
				gitsigns.diffthis("@")
			end, { desc = "git [D]iff against last commit" })
			map("n", "<leader>hQ", function()
				gitsigns.setqflist("all")
			end, { desc = "git hunk [Q]uickfix list (all files in repo)" })
			map("n", "<leader>hq", gitsigns.setqflist, { desc = "git hunk [q]uickfix list (all changes in this file)" })
			-- Toggles
			map("n", "<leader>tb", gitsigns.toggle_current_line_blame, { desc = "[T]oggle git show [b]lame line" })
			map("n", "<leader>tw", gitsigns.toggle_word_diff, { desc = "[T]oggle git intra-line [w]ord diff" })

			-- Text object
			map({ "o", "x" }, "ih", gitsigns.select_hunk)
		end,
	})
end

-- ============================================================
-- harpoon.nvim
-- saves commonly accessed files off
-- ============================================================
do
	vim.pack.add({ gh("ThePrimeagen/harpoon") })
	vim.keymap.set({ "n", "v" }, "<leader>ma", function()
		require("harpoon.mark").add_file()
	end, { desc = "[M]arks [A]dd file" })
	vim.keymap.set({ "n", "v" }, "<leader>mm", function()
		require("harpoon.ui").toggle_quick_menu()
	end, { desc = "Open [M]arks [M]enu" })
	vim.keymap.set({ "n", "v" }, "<leader>mn", function()
		require("harpoon.ui").nav_next()
	end, { desc = "[M]arks [N]ext" })
	vim.keymap.set({ "n", "v" }, "<leader>mp", function()
		require("harpoon.ui").nav_prev()
	end, { desc = "[M]arks [P]revious" })

	vim.keymap.set({ "n", "v" }, "<leader>m1", function()
		require("harpoon.ui").nav_file(1)
	end, { desc = "[M]ark [F]ile 1" })
	vim.keymap.set({ "n", "v" }, "<leader>m2", function()
		require("harpoon.ui").nav_file(2)
	end, { desc = "[M]ark [F]ile 2" })
	vim.keymap.set({ "n", "v" }, "<leader>m3", function()
		require("harpoon.ui").nav_file(3)
	end, { desc = "[M]ark [F]ile 3" })
	vim.keymap.set({ "n", "v" }, "<leader>m4", function()
		require("harpoon.ui").nav_file(4)
	end, { desc = "[M]ark [F]ile 4" })
	vim.keymap.set({ "n", "v" }, "<leader>m5", function()
		require("harpoon.ui").nav_file(5)
	end, { desc = "[M]ark [F]ile 5" })
	vim.keymap.set({ "n", "v" }, "<leader>m6", function()
		require("harpoon.ui").nav_file(6)
	end, { desc = "[M]ark [F]ile 6" })
	vim.keymap.set({ "n", "v" }, "<leader>m7", function()
		require("harpoon.ui").nav_file(7)
	end, { desc = "[M]ark [F]ile 7" })
	vim.keymap.set({ "n", "v" }, "<leader>m8", function()
		require("harpoon.ui").nav_file(8)
	end, { desc = "[M]ark [F]ile 8" })
	vim.keymap.set({ "n", "v" }, "<leader>m9", function()
		require("harpoon.ui").nav_file(9)
	end, { desc = "[M]ark [F]ile 9" })
	vim.keymap.set({ "n", "v" }, "<leader>m0", function()
		require("harpoon.ui").nav_file(0)
	end, { desc = "[M]ark [F]ile 0" })
	require("harpoon").setup({
		menu = {
			width = vim.api.nvim_win_get_width(0) - 30,
		},
	})
end

-- ============================================================
-- hop.nvim
-- enables jumping to a single character in the buffer
-- ============================================================
do
	vim.pack.add({ gh("smoka7/hop.nvim") })

	require("hop").setup({})
	vim.keymap.set({ "n", "v" }, "<leader>j", ":HopChar1<CR>", { desc = "[J]ump to character" })
end

-- ============================================================
-- lazygit
-- nice CLI git application
-- ============================================================
do
	local lazygit = {
		gh("kdheepak/lazygit.nvim"),
		gh("nvim-lua/plenary.nvim"),
	}
	vim.pack.add(lazygit)

	vim.keymap.set("n", "<leader>lg", ":LazyGit<CR>", { desc = "[L]azy[G]it" })
end

-- ============================================================
-- lualine
-- good looking status line
-- ============================================================
do
	local lualine = {
		gh("nvim-lualine/lualine.nvim"),
		gh("nvim-tree/nvim-web-devicons"),
	}
	vim.pack.add(lualine)
	require("lualine").setup({ options = {
		theme = "ayu_dark",
	} })
end

-- ============================================================
-- nvim-autopairs
-- ============================================================
vim.pack.add({ gh("windwp/nvim-autopairs") })
require("nvim-autopairs").setup({})

-- ============================================================
-- nvim-notify
-- pretty notification window
-- ============================================================
vim.pack.add({ gh("rcarriga/nvim-notify") })
vim.notify = require("notify")

-- ============================================================
-- nvim-surround
-- ============================================================
vim.pack.add({ gh("kylechui/nvim-surround") })
require("nvim-surround").setup({})

-- ============================================================
-- oil.nvim
-- ============================================================
do
	vim.pack.add({ gh("stevearc/oil.nvim") })
	require("oil").setup({
		default_file_explorer = true,
	})

	vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
end


-- ============================================================
-- opencode.nvim
-- client for opencode
-- ============================================================
vim.pack.add({
  {
    src = "https://github.com/nickjvandyke/opencode.nvim",
    version = vim.version.range("*"), -- Latest stable release
  },
})

---@type opencode.Opts
vim.g.opencode_opts = {
  -- Your configuration, if any; goto definition on the type for details
}

vim.o.autoread = true -- Required for `vim.g.opencode_opts.events.reload`

-- Recommended/example keymaps
vim.keymap.set({ "n", "x" }, "<leader>oa", function() require("opencode").ask("@this: ") end, { desc = "Ask OpenCode…" })
vim.keymap.set({ "n", "x" }, "<leader>os", function() require("opencode").select() end,       { desc = "Select OpenCode…" })

vim.keymap.set({ "n", "x" }, "go",  function() return require("opencode").operator("@this ") end,        { desc = "Append range to OpenCode", expr = true })
vim.keymap.set("n",          "goo", function() return require("opencode").operator("@this ") .. "_" end, { desc = "Append line to OpenCode", expr = true })

vim.keymap.set("n", "<S-C-u>", function() require("opencode").command("session.half.page.up") end,   { desc = "Scroll OpenCode up" })
vim.keymap.set("n", "<S-C-d>", function() require("opencode").command("session.half.page.down") end, { desc = "Scroll OpenCode down" })

-- ============================================================
-- rainbow_csv
-- colorful csv files
-- ============================================================
vim.pack.add({ gh("mechatroner/rainbow_csv") })

-- ============================================================
-- todo-comments
-- adds highlighting to common TODO comments
-- ============================================================
do
	local todo_comments = {
		gh("folke/todo-comments.nvim"),
		gh("nvim-lua/plenary.nvim"),
	}
	vim.pack.add(todo_comments)
end

-- ============================================================
-- trouble.nvim
-- pretty list for showing diagnostics
-- ============================================================
do
	local trouble = {
		gh("folke/trouble.nvim"),
		gh("nvim-tree/nvim-web-devicons"),
	}
	vim.pack.add(trouble)
	require("trouble").setup({
		-- your configuration comes here
		-- or leave it empty to use the default settings
		-- refer to the configuration section below
	})

	-- TODO: verify that this is working
	vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Diagnostics (Trouble)" })
	vim.keymap.set(
		"n",
		"<leader>xX",
		"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
		{ desc = "Buffer Diagnostics (Trouble)" }
	)
	vim.keymap.set("n", "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", { desc = "Symbols (Trouble)" })
	vim.keymap.set(
		"n",
		"<leader>cl",
		"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
		{ desc = "LSP Definitions / references / ... (Trouble)" }
	)
	vim.keymap.set("n", "<leader>xL", "<cmd>Trouble loclist toggle<cr>", { desc = "Location List (Trouble)" })
	vim.keymap.set("n", "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", { desc = "Quickfix List (Trouble)" })
end

-- ============================================================
-- vim-fugitive
-- basic git actions
-- ============================================================
do
	vim.pack.add({ gh("tpope/vim-fugitive") })

	vim.keymap.set("n", "<leader>gh", ":diffget //3<CR>", { desc = "Git Get Diff on Right" })
	vim.keymap.set("n", "<leader>gf", ":diffget //2<CR>", { desc = "Git Get Diff on Left" })
	vim.keymap.set("n", "<leader>gs", ":G<CR>", { desc = "[G]it [S]tatus" })
	vim.keymap.set("n", "<leader>gc", ':G commit -m ""<left>', { desc = "[G]it [C]ommit" })
	vim.keymap.set("n", "<leader>gu", ":G push<CR>", { desc = "[G]it P[u]sh" })
end

-- ============================================================
-- vim-sleuth
-- ============================================================
vim.pack.add({ gh("tpope/vim-sleuth") })

-- ============================================================
-- vim-tmux-navigator
-- ============================================================
vim.pack.add({ gh("christoomey/vim-tmux-navigator") })

-- ============================================================
-- which-key
-- legend for keyboard shortcuts
-- ============================================================
do
	local which_key = {
		gh("folke/which-key.nvim"),
		gh("echasnovski/mini.icons"),
		gh("nvim-tree/nvim-web-devicons"),
	}
	vim.pack.add(which_key)

	vim.keymap.set("n", "<leader>?", function()
		require("which-key").show({ global = false })
	end, { desc = "Buffer Local Keymaps (which-key)" })
end

-- TODO: make format work on ly on current selection
-- TODO: figure out opencode integration
