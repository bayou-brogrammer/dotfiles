-- Mapping data with "desc" stored directly by vim.keymap.set().
--
-- Please use this mappings table to set keyboard mapping since this is the
-- lower level configuration and more robust one. (which-key will
-- automatically pick-up stored data by this setting.)
return {
  -- first key is the mode
  n = {
    -- second key is the lefthand side of the map
    -- mappings seen under group name "Buffer"
    ["<leader>bn"] = { "<cmd>tabnew<cr>", desc = "New tab" },
    ["<leader>bD"] = {
      function()
        require("astronvim.utils.status").heirline.buffer_picker(function(bufnr)
          require("astronvim.utils.buffer").close(
            bufnr)
        end)
      end,
      desc = "Pick to close",
    },
    L = {
      function() require("astronvim.utils.buffer").nav(vim.v.count > 0 and vim.v.count or 1) end,
      desc = "Next buffer",
    },
    H = {
      function() require("astronvim.utils.buffer").nav(-(vim.v.count > 0 and vim.v.count or 1)) end,
      desc = "Previous buffer",
    },

    ["<C-q>"] = { ":qa!<cr>", desc = "Exit" },
    ["<C-s>"] = { ":w!<cr>", desc = "Save file" },
    ["<C-u>"] = { "<C-u>zz", desc = "Scroll up" },
    ["<C-d>"] = { "<C-d>zz", desc = "Scroll down" },
    ["<C-k>"] = { function() require("telescope.builtin").live_grep() end, desc = "Find words" },
    ["<C-f>"] = { function() require("telescope.builtin").find_files() end, desc = "Find files" },

    ["<leader>b"] = { name = "Buffers" },
    ["<leader>z"] = { ":ZenMode<cr>", desc = "Toggle Zen mode" },
    ["<leader>U"] = { ":UndotreeToggle<cr>", desc = "Toggle undo history" },

    -- Term
    ["<F12>"] = { ":ToggleTerm size=30 direction=horizontal<cr>", desc = "Toggle terminal" },
    ["<leader>|"] = { ":ToggleTerm size=30 direction=vertical<cr>", desc = "Open terminal - vertical" },
    ["<leader>\\"] = { ":ToggleTerm size=30 direction=horizontal<cr>", desc = "Open terminal -  horizontal" },

    -- Keys
    -- ["<esc>"] = { ":nohl<cr>", desc = "No highlight" },
  },
  i = {
    ["<C-s>"] = { "<esc>:w!<cr>", desc = "Save file" },
    ["<C-q>"] = { "<esc>:qa!<cr>", desc = "Exit" },
  },
  v = {
    ["<leader>p"] = { '"0p', desc = "Paste without replacing the buffer" },
    ["<C-r>"] = { '"hy:%s/<C-r>h//gc<left><left><left>', desc = "Replace" },
    ["<leader>s"] = { ":'<,'>Silicon<cr>", desc = "Save image" },
  },
  t = {
    ["<C-j>"] = { "<C-\\><C-N>", desc = "Switch to normal mode" },
  },
}
