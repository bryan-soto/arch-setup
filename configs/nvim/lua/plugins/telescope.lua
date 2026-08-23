return {
  "nvim-telescope/telescope.nvim",
  event = 'VeryLazy',
  version = '*',
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope-file-browser.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = 'make'
    } },
  opts = {
    extensions = {
      fzf = {
        fuzzy = true,                   -- false will only do exact matching
        override_generic_sorter = true, -- override the generic sorter
        override_file_sorter = true,    -- override the file sorter
        case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
        -- the default case_mode is "smart_case"
      },

      file_browser = {
        hidden = true,
        grouped = true,
        respect_gitignore = false,
        sorting_strategy = "ascending",

      },
    }
  },
  config = function(_, opts)
    require("telescope").setup(opts)
    require("telescope").load_extension("fzf")
    require("telescope").load_extension("file_browser")
  end,
  keys = {
    {
      "<leader>fb",
      function()
        require("telescope").extensions.file_browser.file_browser({
          path = vim.fn.expand("%:h:p"),
          select_buffer = true,
        })
      end,
      desc = "Telescope file browser"
    },
    {
      "<leader>ff",
      function()

        local ok = pcall(function ()
          require("telescope.builtin").git_files({ show_untracked = true })
        end)

        if not ok then
          require("telescope.builtin").find_files()
        end
      end,
      desc = "Telescope Files"
    },
    {
      "<leader>bf",
      function()
        require("telescope.builtin").buffers()
      end,
      desc = "Telescope buffer",
    },
    {
      "<leader>gs",
      function()
        require("telescope.builtin").git_status()
      end,
      desc = "Telescope Git Status",
    },
    {
      "<leader>gc",
      function()
        require("telescope.builtin").git_commits()
      end,
      desc = "Telescope Git Commits",
    },
    {
      "<leader>gb",
      function()
        require("telescope.builtin").git_branches()
      end,
      desc = "Telescope Git Branches",
    },
    {
      "<leader>np",
      function()
        require("telescope.builtin").find_files({
          prompt_title = "Plugins",
          cwd = vim.fn.stdpath("config") .. "/lua/plugins",
          attach_mappings = function(_, map)
            local actions = require("telescope.actions")
            local action_state = require("telescope.actions.state")
            map("i", "<c-y>", function(prompt_bufnr)
              local new_plugin = action_state.get_current_line()
              actions.close(prompt_bufnr)
              vim.cmd(string.format("edit ~/.config/nvim/lua/plugins/%s.lua", new_plugin))
            end)
            return true
          end
        })
      end
    },
    {
      "<leader>th",
      function()
        require("telescope.builtin").help_tags()
      end,
      desc = "Telescope Help"
    },
  }
}
