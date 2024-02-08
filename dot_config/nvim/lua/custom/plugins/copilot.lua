-- Sets up Copilot. Uses lua alternative of official repo.
return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  event = "InsertEnter",
  config = function()
    require("copilot").setup({
      -- setup for usage with cmp
      suggestion = { enabled = false },
      panel = { enabled = false },
    })
  end,
}
