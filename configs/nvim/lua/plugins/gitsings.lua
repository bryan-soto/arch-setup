return {
  'lewis6991/gitsigns.nvim',
  config = function ()
    require('gitsigns').setup{
      numhl = true,
      max_file_length = 10000,
    }
  end
}
