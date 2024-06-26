return {
  "szw/vim-maximizer",
  -- Lazy load the plugin whenever the key is pressed
  keys = {
    { "<leader>wm", "<cmd>MaximizerToggle<CR>", desc = "Maximize/Restore Window" },
  },
}
