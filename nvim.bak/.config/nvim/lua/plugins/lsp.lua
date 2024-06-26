return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPost" },
		dependencies = {
			-- Automatically install LSPs to stdpath for neovim
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",

			-- LSP autocomplete in case it isn't loaded in the autocmp file
			"hrsh7th/cmp-nvim-lsp",

			-- Neovim as a language server for LSP diagnostics, code actions, and formatting
			-- Prettier, ESLint, etc.
			"nvimtools/none-ls.nvim",
			"nvimtools/none-ls-extras.nvim",

			-- Additional lua configuration, makes nvim stuff amazing!
			"folke/neodev.nvim",

			-- Useful status updates for LSP
			{ "j-hui/fidget.nvim", opts = {} },
		},
		config = function()
			-- local null_ls = require("null-ls")

			-- Have to load kemaps first
			local map_lsp_keybinds = require("user.keymaps").map_lsp_keybinds

			-- Use neodev to configure lua_ls in nvim directories -- must load before lspconfig
			require("neodev").setup()

			-- setup mason to manage 3rd party lsp servers
			require("mason").setup({
				PATH = "prepend", --"skip" seems to cause a spawning error
				ui = {
					border = "rounded",
				},
				log_level = vim.log.levels.DEBUG,
			})

			-- configure mason to auto install servers
			require("mason-lspconfig").setup()

			-- Enable the following language servers
			-- Full List: (https://github.com/williamboman/mason-lspconfig.nvim?tab=readme-ov-file#available-lsp-servers)
			local servers = {
				bashls = {},
				-- clangd = {},
				cssls = {},
				gopls = {},
				html = {},
				jsonls = {},
				lua_ls = {
					settings = {
						Lua = {
							workspace = { checkThirdParty = false },
							telemetry = { enabled = false },
						},
					},
				},
				pyright = {},
				sqlls = {},
				tailwindcss = {},
				tsserver = {
					settings = {
						experimental = {
							enableProjectDiagnostics = true,
						},
					},
				},
				yamlls = {},
			}

			-- Change UI for default handlers for LSP
			local default_handlers = {
				["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" }),
				["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" }),
			}
			-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

			-- -- Set mode, buffer, and decription for each client attached to the lsp
			-- local on_attach = function(_client, bufnr)
			-- 	-- Pass current buffer to map lsp keybinds
			-- 	map_lsp_keybinds(bufnr)
			--
			-- 	-- Create a command `:Format` local to the LSP buffer
			-- 	vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
			-- 		vim.lsp.buf.format({
			-- 			filter = function(format_client)
			-- 				-- Use Prettier to format TS/JS if available instead of tsserver
			-- 				return format_client.name ~= "tsserver" or not null_ls.is_registered("prettierd")
			-- 			end,
			-- 		})
			-- 	end, { desc = "LSP: Format current buffer with LSP" })
			-- end

			-- Function to run when neovim connects to a Lsp client
			---@diagnostic disable-next-line: unused-local
			local on_attach = function(_client, buffer_number)
				-- Pass the current buffer to map lsp keybinds
				map_lsp_keybinds(buffer_number)
			end

			-- Iterate over servers and set them up
			for name, config in pairs(servers) do
				require("lspconfig")[name].setup({
					capabilities = capabilities,
					on_attach = on_attach,
					settings = config.settings,
					filetypes = config.filetypes,
					handlers = vim.tbl_deep_extend("force", {}, default_handlers, config.handlers or {}),
				})
			end

			-- -- Configure LSP linting, formatting, diagnostics, and code actions
			-- local formatting = null_ls.builtins.formatting
			-- local code_actions = null_ls.builtins.code_actions
			--
			-- null_ls.setup({
			--   border = "rounded",
			--   sources = {
			--     -- formatting
			--     formatting.prettierd,
			--     formatting.stylua,
			--     formatting.black, -- python
			--     formatting.isort, -- python import sorting
			--
			--     -- diagnostics
			--     require("none-ls.diagnostics.eslint_d"),
			--
			--     -- code actions
			--     code_actions.gitsigns,
			--     require("none-ls.code_actions.eslint_d"),
			--   },
			-- })

			-- Configure border for LspInfo ui
			require("lspconfig.ui.windows").default_options.border = "rounded"

			-- Configure diagnostics border
			vim.diagnostic.config({
				float = {
					bodered = "rounded",
				},
			})
		end,
	},
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		opts = {
			notify_on_error = true,
			format_on_save = {
				async = true,
				timeout_ms = 500,
				lsp_fallback = true,
			},
			formatters_by_ft = {
				javascript = { { "prettierd", "prettier" } },
				typescript = { { "prettierd", "prettier" } },
				typescriptreact = { { "prettierd", "prettier" } },
				lua = { "stylua" },
			},
		},
	},
}
