-- 🎨 テーマ
vim.cmd.colorscheme("catppuccin-mocha")

-- 📋 表示・インデント・クリップボード
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.clipboard = "unnamedplus"
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

-- 🔐 プロジェクトごとの .nvim.lua を有効化(信頼確認あり)
vim.o.exrc = true
vim.o.secure = true
