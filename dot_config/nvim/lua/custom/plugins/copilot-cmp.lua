-- Adds Copilot to cmp.
return {
  "zbirenbaum/copilot-cmp",
  config = function()
    require("copilot_cmp").setup()
  end,
}
