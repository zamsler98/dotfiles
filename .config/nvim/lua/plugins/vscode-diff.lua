return {
  'esmuellert/vscode-diff.nvim',
  branch = 'next',
  config = function()
    require('vscode-diff').setup({
      -- your config...
    })
  end
}
