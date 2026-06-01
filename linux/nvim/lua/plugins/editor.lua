return {
  { "windwp/nvim-autopairs", event = "InsertEnter", config = true },
  { "numToStr/Comment.nvim", keys = { "gcc", "gbc", { "gc", mode = "v" }, { "gb", mode = "v" } }, config = true },
  { "easymotion/vim-easymotion", keys = {
    { "/", "<Plug>(easymotion-sn)", mode = { "n", "o" } },
    { "n", "<Plug>(easymotion-next)" },
    { "N", "<Plug>(easymotion-prev)" },
  }},
  { "mileszs/ack.vim", cmd = "Ack", init = function()
    if vim.fn.executable("rg") == 1 then vim.g.ackprg = "rg --vimgrep" end
  end },
  { "nvim-tree/nvim-tree.lua",
    keys = { { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "File tree" } },
    config = function() require("nvim-tree").setup() end,
  },
}
