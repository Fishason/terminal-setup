return {
	"nvim-lualine/lualine.nvim",
	opts = function(_, opts)
		-- 移除 lualine_b 的 branch（左下角分支）
		-- 移除 lualine_z 的时间
		opts.sections = opts.sections or {}
		opts.sections.lualine_b = {}
		opts.sections.lualine_z = {}
	end,
}
