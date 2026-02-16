return {
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    opts = {},
    keys = {
      { "<leader>a", function() require("harpoon"):list():add() end, desc = "Harpoon Add File" },
      { "<C-e>", function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end, desc = "Harpoon Menu" },
      { "<C-h>", function() require("harpoon"):list():select(1) end, desc = "Harpoon File 1" },
      { "<C-t>", function() require("harpoon"):list():select(2) end, desc = "Harpoon File 2" },
      { "<C-n>", function() require("harpoon"):list():select(3) end, desc = "Harpoon File 3" },
      { "<C-s>", function() require("harpoon"):list():select(4) end, desc = "Harpoon File 4" },
    },
  },
  { "mbbill/undotree", keys = { { "<leader>u", "<cmd>UndotreeToggle<cr>", desc = "Undotree" } } },
  { "tpope/vim-fugitive", keys = { { "<leader>gs", "<cmd>Git<cr>", desc = "Fugitive" } } },
  { "eandrju/cellular-automaton.nvim" },

  {
    "otavioschwanck/cool-substitute.nvim",
    opts = {
      setup_keybindings = true,
      mappings = {
        start = "gm",
        start_and_edit = "gM",
        start_and_edit_word = "g!M",
        start_word = "g!m",
        apply_substitute_and_next = "M",
        apply_substitute_and_prev = "<C-b>",
        apply_substitute_all = "ga",
        force_terminate_substitute = "g!!",
        terminate_substitute = "<esc>",
        skip_substitute = "n",
        goto_next = "<C-j>",
        goto_previous = "<C-k>",
      },
      writing_substitution_color = "#ECBE7B",
      applying_substitution_color = "#98be65",
    },
  },

  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      suggestion = { enabled = true, auto_trigger = true, keymap = { accept = "<Tab>" } },
      panel = { enabled = false },
    },
  },

  {
    "jackMort/ChatGPT.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    opts = {
      api_key_cmd = "op read op://Personal/OpenAI/api-key --no-newline",
      yank_register = "+",
      edit_with_instructions = {
        diff = false,
        keymaps = {
          close = "<C-c>",
          accept = "<C-y>",
          toggle_diff = "<C-d>",
          toggle_settings = "<C-o>",
          cycle_windows = "<Tab>",
          use_output_as_input = "<C-i>",
        },
      },
      chat = {
        welcome_message = "Welcome weary traveller...",
        loading_text = "Loading, please wait ...",
        question_sign = "",
        answer_sign = "ﮧ",
        max_line_length = 120,
        keymaps = {
          close = { "<C-c>" },
          yank_last = "<C-y>",
          yank_last_code = "<C-k>",
          scroll_up = "<C-u>",
          scroll_down = "<C-d>",
          new_session = "<C-n>",
          cycle_windows = "<Tab>",
          cycle_modes = "<C-f>",
          select_session = "<Space>",
          rename_session = "r",
          delete_session = "d",
          draft_message = "<C-d>",
          toggle_settings = "<C-o>",
          toggle_message_role = "<C-r>",
          toggle_system_role_open = "<C-s>",
        },
      },
      popup_layout = {
        default = "center",
        center = { width = "80%", height = "80%" },
      },
      popup_window = {
        border = { style = "rounded", text = { top = " ChatGPT " } },
        win_options = { wrap = true, linebreak = true, foldcolumn = "1" },
      },
      popup_input = {
        prompt = "  ",
        border = { style = "rounded", text = { top = " Prompt " } },
        submit = "<C-Enter>",
        submit_n = "<Enter>",
      },
      openai_params = {
        model = "gpt-4o",
        frequency_penalty = 0,
        presence_penalty = 0,
        max_tokens = 300,
        temperature = 0,
        top_p = 1,
        n = 1,
      },
    },
    keys = {
      { "<leader>g", ":ChatGPT<cr>", mode = "v", desc = "ChatGPT" },
    },
  },

  {
    "folke/zen-mode.nvim",
    dependencies = { "folke/twilight.nvim" },
    opts = {},
  },
}