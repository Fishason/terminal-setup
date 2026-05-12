return {
	"folke/snacks.nvim",
	opts = {
		picker = {
			sources = {
				explorer = {
					layout = {
						preset = "sidebar",
						preview = false,
						layout = { width = 25 }, -- 默认 40，紧凑模式
					},
				},
			},
		},
	},
}
