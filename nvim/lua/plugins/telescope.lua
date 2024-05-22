return {
  "nvim-telescope/telescope.nvim",
  event = "VimEnter",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")

    telescope.setup({
      defaults = {
        path_display = { "truncate " },
        mappings = {
          i = {
            ["<C-n>"] = actions.move_selection_next,
            ["<C-p>"] = actions.move_selection_previous,
            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
            ["<C-y>"] = actions.select_default,
            ["<C-\\>"] = actions.select_vertical,
          },
        },
        dynamic_preview_title = true,
        vimgrep_arguments = {
          "rg",
          "--with-filename",
          "--no-heading",
          "--line-number",
          "--column",
          "--smart-case",
          "--hidden",
        },
      },
    })

    telescope.load_extension("fzf")
  end,
  keys = {
    {
      "<leader>ff",
      "<cmd>lua require('telescope.builtin').find_files({no_ignore=true})<cr>",
      desc = "Find Files (ignoring files)",
    },
    {
      "<leader>,",
      "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>",
      desc = "Switch Buffer",
    },
    -- find
    {
      "<leader><space>",
      "<cmd>Telescope find_files<cr>",
      desc = "Find Files (root dir)",
    },
    { "<leader>fb", "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>", desc = "Buffers" },
    {
      "<leader>fr",
      "<cmd>Telescope oldfiles<cr>",
      { desc = "Fuzzy find recent files" },
    },
    { '<leader>s"', "<cmd>Telescope registers<cr>", desc = "Registers" },
    { "<leader>sa", "<cmd>Telescope autocommands<cr>", desc = "Auto Commands" },
    { "<leader>so", "<cmd>Telescope vim_options<cr>", desc = "Options" },
    { "<leader>sg", "<cmd>Telescope live_grep<cr>", desc = "Grep in files" },
    {
      "<leader>sG",
      "<cmd>lua require('telescope.builtin').live_grep({additional_args=function() return { '--no-ignore' } end})<cr>",
      desc = "Grep in all files",
    },
    { "<leader>sw", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" } },
  },
}
