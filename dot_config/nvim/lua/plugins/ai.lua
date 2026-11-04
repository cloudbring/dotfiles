return {
  -- Inline ghost text completion via Gemini Flash
  -- Replaces copilot.lua. Uses GEMINI_API_KEY env var.
  {
    "milanglacier/minuet-ai.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "InsertEnter",
    opts = {
      provider = "gemini",
      provider_options = {
        gemini = {
          model = "gemini-2.0-flash",
          stream = true,
          api_key = "GEMINI_API_KEY", -- reads from env var of this name
          optional = {
            generationConfig = {
              maxOutputTokens = 256,
              -- disable thinking tokens for speed
              thinkingConfig = { thinkingBudget = 0 },
            },
          },
        },
      },
      throttle = 1000,
      debounce = 400,
      virtualtext = {
        auto_trigger_ft = {
          "python", "lua", "typescript", "javascript", "typescriptreact",
          "javascriptreact", "astro", "css", "html", "sh",
        },
        keymap = {
          accept      = "<Tab>",
          accept_line = "<A-l>",
          next        = "<A-]>",
          prev        = "<A-[>",
          dismiss     = "<A-e>",
        },
      },
    },
  },

  -- AI chat assistant. Uses Claude via Anthropic API key, or Gemini.
  -- For Claude Max plan (no API key): set adapter to "claude_code" once
  -- codecompanion's ACP integration is configured (requires Claude Code CLI logged in).
  {
    "olimorris/codecompanion.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter" },
    cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionActions" },
    keys = {
      { "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>", desc = "AI Chat" },
      { "<leader>aa", "<cmd>CodeCompanionActions<cr>",    desc = "AI Actions" },
    },
    opts = {
      adapters = {
        gemini = function()
          return require("codecompanion.adapters").extend("gemini", {
            env = { api_key = "GEMINI_API_KEY" },
          })
        end,
      },
      strategies = {
        chat   = { adapter = "gemini" },
        inline = { adapter = "gemini" },
      },
    },
  },
}
