local cmp_status, cmp = pcall(require, "cmp")
if cmp_status then
  cmp.setup({
    snippet = {
      expand = function(args)
        vim.snippet.expand(args.body)
      end,
    },
    mapping = cmp.mapping.preset.insert({
      ['<S-Tab>'] = cmp.mapping.complete(),
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
    }),
  })
end
