return {
  -- Add gruvbox plugin
  { "ellisonleao/gruvbox.nvim" },
  -- Configure LazyVim to use gruvbox as the default colorscheme
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "gruvbox",
    },
  },
}
