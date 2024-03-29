return {
	-- {
	-- 	"nvimdev/dashboard-nvim",
	-- 	event = "VimEnter",
	-- 	config = function()
	-- 		require("dashboard").setup({
	-- 			-- config
	-- 		})
	-- 	end,
	-- 	dependencies = { { "nvim-tree/nvim-web-devicons" } },
	-- },
	{
		"goolord/alpha-nvim",
		config = function()
			local alpha = require("alpha")
			local dashboard = require("alpha.themes.dashboard")

			dashboard.section.header.val = {

				[[          ▀████▀▄▄              ▄█ ]],
				[[            █▀    ▀▀▄▄▄▄▄    ▄▄▀▀█ ]],
				[[    ▄        █          ▀▀▀▀▄  ▄▀  ]],
				[[   ▄▀ ▀▄      ▀▄              ▀▄▀  ]],
				[[  ▄▀    █     █▀   ▄█▀▄      ▄█    ]],
				[[  ▀▄     ▀▄  █     ▀██▀     ██▄█   ]],
				[[   ▀▄    ▄▀ █   ▄██▄   ▄  ▄  ▀▀ █  ]],
				[[    █  ▄▀  █    ▀██▀    ▀▀ ▀▀  ▄▀  ]],
				[[   █   █  █      ▄▄           ▄▀   ]],
			}

			-- Set Menu
			dashboard.section.buttons.val = {
				dashboard.button("f", "󰱼  > Find file", ":Telescope find_files <CR>"),
				dashboard.button("e", "  > New file", ":ene <BAR> startinsert <CR>"),
				dashboard.button("r", "󰪶  > Recently used files", ":Telescope oldfiles <CR>"),
				dashboard.button("t", "  > Find text", ":Telescope live_grep <CR>"),
				dashboard.button("c", "  > Configuration", ":e ~/.config/nvim<CR>"),
				dashboard.button("q", "󰅚  > Quit Neovim", ":qa<CR>"),
			}

			-- Set Footer
			require("alpha.themes.dashboard").section.footer.val = require("alpha.fortune")()

			-- Was in the default in :h
			dashboard.config.opts.noautocmd = true
			vim.cmd([[autocmd User AlphaReady echo 'ready']])

			alpha.setup(dashboard.config)
		end,
	},
}
