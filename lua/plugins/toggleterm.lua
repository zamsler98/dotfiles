return {
  'akinsho/toggleterm.nvim',
  version = "*",
  config = function()
    require('toggleterm').setup{
      direction = 'float',
      open_mapping = [[<C-\>]],
      float_opts = {
        border = 'curved',
      },
    }
  end
}