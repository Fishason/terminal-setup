return {
	"mikavilpas/yazi.nvim",
	event = "VeryLazy",
	dependencies = { "nvim-lua/plenary.nvim" },
	keys = {
		-- Space + - : 在当前文件所在目录打开 yazi
		{ "<leader>-", "<cmd>Yazi<cr>", desc = "Open yazi at the current file" },
		-- Space + cw : 在 nvim 当前工作目录打开 yazi
		{ "<leader>cw", "<cmd>Yazi cwd<cr>", desc = "Open yazi (cwd)" },
		-- Ctrl + Up : 恢复上一次的 yazi 会话
		{ "<c-up>", "<cmd>Yazi toggle<cr>", desc = "Resume last yazi session" },
	},
	opts = {
		open_for_directories = false,
		keymaps = {
			show_help = "<f1>",
		},
	},
}
