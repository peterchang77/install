-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins")

-- Options
vim.opt.number = true
vim.opt.wrap = false
vim.opt.scrolloff = 10
vim.opt.expandtab = true
vim.opt.smarttab = true
vim.opt.tabstop = 8
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.clipboard = "unnamed"
vim.opt.termguicolors = false

-- JavaScript indent
vim.api.nvim_create_autocmd("FileType", {
  pattern = "javascript",
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.shiftwidth = 2
  end,
})

-- Colorscheme
vim.cmd("colorscheme badwolf")
vim.cmd("highlight Normal ctermbg=NONE guibg=NONE")
vim.cmd("highlight NonText ctermbg=NONE guibg=NONE")
vim.cmd("highlight Comment ctermfg=12")

-- Force popup menu colors after any colorscheme/plugin load
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    vim.api.nvim_set_hl(0, "Pmenu", { bg = "#000000", fg = "#ffffff", ctermbg = 0, ctermfg = 15 })
    vim.api.nvim_set_hl(0, "PmenuSel", { bg = "#333333", fg = "#ffffff", ctermbg = 8, ctermfg = 15 })
  end,
})
vim.api.nvim_set_hl(0, "Pmenu", { bg = "#000000", fg = "#ffffff", ctermbg = 0, ctermfg = 15 })
vim.api.nvim_set_hl(0, "PmenuSel", { bg = "#333333", fg = "#ffffff", ctermbg = 8, ctermfg = 15 })

-- Keymaps: window navigation
vim.keymap.set("n", "<C-J>", "<C-W><C-J>")
vim.keymap.set("n", "<C-K>", "<C-W><C-K>")
vim.keymap.set("n", "<C-L>", "<C-W><C-L>")
vim.keymap.set("n", "<C-H>", "<C-W><C-H>")
vim.keymap.set("n", "<F2>", "<Esc>:w<CR>")
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")
