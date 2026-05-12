-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Insert 模式下 jj 快速回 Normal
vim.keymap.set("i", "jj", "<Esc>", { desc = "Exit insert mode" })

-- Alt+j/k 移动行（LazyVim 默认已经有这个，但写在这里更稳）
-- 已被 LazyVim 默认覆盖，无需重复添加

-- Alt+h/l 跳到行首/行尾
vim.keymap.set("n", "<A-h>", "0", { desc = "Line start" })
vim.keymap.set("n", "<A-l>", "$", { desc = "Line end" })
vim.keymap.set("i", "<A-h>", "<C-o>0", { desc = "Line start (insert)" })
vim.keymap.set("i", "<A-l>", "<C-o>$", { desc = "Line end (insert)" })

-- Tab / Shift-Tab 缩进
vim.keymap.set("n", "<Tab>", ">>", { desc = "Indent" })
vim.keymap.set("n", "<S-Tab>", "<<", { desc = "Outdent" })
vim.keymap.set("v", "<Tab>", ">gv", { desc = "Indent (keep selection)" })
vim.keymap.set("v", "<S-Tab>", "<gv", { desc = "Outdent (keep selection)" })

-- Q 用来格式化（vim 默认就是这个，显式写一下保持习惯）
vim.keymap.set("n", "Q", "gq", { desc = "Format" })

-- 逗号打开文件资源管理器（覆盖 vim 原生的反向 f/F 跳转）
vim.keymap.set("n", ",", function() Snacks.explorer() end, { desc = "Explorer (Snacks)" })
