return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-nvim-lsp",
  },
  config = function()
    local cmp = require("cmp")

    -- Force black background / white text on completion menu
    local hl = vim.api.nvim_set_hl
    hl(0, "CmpItemAbbr", { ctermfg = 15, ctermbg = 0, fg = "#ffffff", bg = "#000000" })
    hl(0, "CmpItemAbbrMatch", { ctermfg = 15, ctermbg = 0, fg = "#ffffff", bg = "#000000", bold = true })
    hl(0, "CmpItemAbbrMatchFuzzy", { ctermfg = 15, ctermbg = 0, fg = "#ffffff", bg = "#000000" })
    hl(0, "CmpItemMenu", { ctermfg = 15, ctermbg = 0, fg = "#ffffff", bg = "#000000" })
    hl(0, "CmpItemKind", { ctermfg = 15, ctermbg = 0, fg = "#ffffff", bg = "#000000" })

    cmp.setup({
      window = {
        completion = cmp.config.window.bordered({
          winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None",
        }),
      },
      mapping = cmp.mapping.preset.insert({
        ["<Tab>"] = cmp.mapping.select_next_item(),
        ["<S-Tab>"] = cmp.mapping.select_prev_item(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
      }),
      sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "buffer" },
        { name = "path" },
      }),
    })
  end,
}
