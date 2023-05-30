return {
	-- tree-sitter
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				-- A list of parser names, or "all" (the five listed parsers should always be installed)
				ensure_installed = { "javascript", "typescript" },
				-- Install parsers synchronously (only applied to `ensure_installed`)
				sync_install = false,
				-- Automatically install missing parsers when entering buffer
				-- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
				auto_install = false,
				context_commentstring = {
					enable = true,
				},
				highlight = {
					enable = true,
				},
				indent = {
					enable = true,
				},
				autotag = {
					enable = true,
				},
			})
		end,
	},
	-- lsp
	{
		"neovim/nvim-lspconfig",
		opts = {
			--options for vim.diagnostic.config()
			diagnostics = {
				underline = true,
				update_in_insert = false,
				sign = false,
				virtual_text = {
					spacing = 4,
					source = "if_many",
					prefix = "●",
				},
			},
			--     -- LSP Server Settings
			--     ---@type lspconfig.options
			servers = {
				settings = {
					completion = {
						workspaceWord = false,
						showWord = "Disable",
						callSnippet = "Replace",
					},
				},
				-- setup = {
				--   tsserver = function(_, opts)
				--     require('typescript').setup({ server = opts })
				--     return true
				--   end
				-- }
			},
		},
		config = function()
			local lspconfig = require("lspconfig")
			lspconfig.tsserver.setup({})
			lspconfig.tailwindcss.setup({})
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities.textDocument.completion.completionItem.snippetSupport = true

			--     -- Use LspAttach autocommand to only map the following keys
			--     -- after the language server attaches to the current buffer
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev)
					--         -- Enable completion triggered by <c-x><c-o>
					vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

					--         -- Buffer local mappings.
					--         -- See `:help vim.lsp.*` for documentation on any of the below functions
					local opts = { buffer = ev.buf }
					vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
					vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
					vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
					vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
					vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
					vim.keymap.set("n", "<space>wl", function()
						print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
					end, opts)
					vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, opts)
					vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
					vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, opts)
					vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
					vim.keymap.set("n", "<space>f", function()
						vim.lsp.buf.format({ async = true })
					end, opts)
				end,
			})
		end,
	},
	{
		"L3MON4D3/LuaSnip",
		-- follow latest release.
		version = "<CurrentMajor>.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
		-- install jsregexp (optional!).
		build = "make install_jsregexp",
		config = function()
			require("luasnip/loaders/from_vscode").load({ paths = { "~/.config/nvim/snippets/" } })
		end,
	},

	-- cmp
	-- https://www.lazyvim.org/plugins/coding#nvim-cmp
	{
		"hrsh7th/nvim-cmp",
		version = false, -- last release is way too old
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"saadparwaiz1/cmp_luasnip",
		},
		opts = function()
			local cmp = require("cmp")
			return {
				completion = {
					completeopt = "menu,menuone,noinsert",
				},
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
					["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<Tab>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
					["<S-CR>"] = cmp.mapping.confirm({
						behavior = cmp.ConfirmBehavior.Replace,
						select = true,
					}), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
				}),
				sources = cmp.config.sources({
					{
						name = "nvim_lsp",
						priority = 8,
						max_item_count = 6,
						entry_filter = function(entry, ctx)
							return require("cmp.types").lsp.CompletionItemKind[entry:get_kind()] ~= "Text"
						end,
					},
					{ name = "luasnip", priority = 8, max_item_count = 4 }, -- For vsnip users.
				}),
				experimental = {
					ghost_text = {
						hl_group = "LspCodeLens",
					},
				},
			}
		end,
	},
	{
		"hrsh7th/cmp-nvim-lsp",
	},

	"hrsh7th/cmp-path",
	"saadparwaiz1/cmp_luasnip",
	"hrsh7th/cmp-buffer",
	{
		"echasnovski/mini.pairs",
		event = "VeryLazy",
		config = function(_, opts)
			require("mini.pairs").setup(opts)
		end,
	},
	{
		{
			"akinsho/toggleterm.nvim",
			event = "VeryLazy",
			version = "*",
			opts = { --[[ things you want to change go here]]
			},
		},
	},
	{
		"kylechui/nvim-surround",
		version = "*", -- Use for stability; omit to use `main` branch for the latest features
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup()
		end,
	},
	{
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup({
				pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
			})
		end,
	},
	{
		"JoosepAlviste/nvim-ts-context-commentstring",
	},
	{
		"nvim-lua/plenary.nvim",
	},
	-- format
	{
		"jose-elias-alvarez/null-ls.nvim",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = { "mason.nvim" },
		config = function()
			local null_ls = require("null-ls")
			local async_formatting = function(bufnr)
				bufnr = bufnr or vim.api.nvim_get_current_buf()
				vim.lsp.buf_request(
					bufnr,
					"textDocument/formatting",
					vim.lsp.util.make_formatting_params({}),
					function(err, res, ctx)
						if err then
							local err_msg = type(err) == "string" and err or err.message
							-- you can modify the log message / level (or ignore it completely)
							vim.notify("formatting: " .. err_msg, vim.log.levels.WARN)
							return
						end

						-- don't apply results if buffer is unloaded or has been modified
						if not vim.api.nvim_buf_is_loaded(bufnr) or vim.api.nvim_buf_get_option(bufnr, "modified") then
							return
						end

						if res then
							local client = vim.lsp.get_client_by_id(ctx.client_id)
							vim.lsp.util.apply_text_edits(res, bufnr, client and client.offset_encoding or "utf-16")
							vim.api.nvim_buf_call(bufnr, function()
								vim.cmd("silent noautocmd update")
							end)
						end
					end
				)
			end
			local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
			null_ls.setup({
				sources = {
					null_ls.builtins.formatting.stylua,
					-- null_ls.builtins.diagnostics.eslint,
					null_ls.builtins.completion.spell,
				},
				debug = false,
				-- you can reuse a shared lspconfig on_attach callback here
				on_attach = function(client, bufnr)
					if client.supports_method("textDocument/formatting") then
						vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
						vim.api.nvim_create_autocmd("BufWritePost", {
							group = augroup,
							buffer = bufnr,
							callback = function()
								async_formatting(bufnr)
							end,
						})
					end
				end,
			})
		end,
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		config = {
			show_current_context = true,
			show_current_context_start = true,
		},
	},
	{
		"SmiteshP/nvim-navic",
		config = function()
			local navic = require("nvim-navic")
			local on_attach = function(client, bufnr)
				if client.server_capabilities.documentSymbolProvider then
					navic.attach(client, bufnr)
				end
			end
			require("lspconfig").tsserver.setup({
				on_attach = on_attach,
			})
		end,
	},
	"RRethy/vim-illuminate",
	{
		"ggandor/leap.nvim",
		dependencies = {
			"tpope/vim-repeat",
		},
		config = function()
			require("leap").add_default_mappings()
		end,
	},
	"windwp/nvim-ts-autotag",
}
