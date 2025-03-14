
vim.opt.rtp:prepend("~/.local/share/nvim/lazy/lazy.nvim")

-- Show line numbers
vim.opt.number = true

-- Use relative line numbers (Uncomment if needed)
vim.opt.relativenumber = true

-- Indentation
vim.opt.expandtab = true    -- Convert tabs to spaces
vim.opt.shiftwidth = 2      -- Number of spaces for indentation
vim.opt.tabstop = 2         -- Number of spaces per tab
vim.opt.softtabstop = 2     -- Backspace deletes 2 spaces

-- Enable mouse support
vim.opt.mouse = "a"

-- Enable clipboard support (System Clipboard)
vim.opt.clipboard = "unnamedplus"

-- Map 'jj' to Escape in Insert Mode
vim.api.nvim_set_keymap("i", "jj", "<Esc>", { noremap = true, silent = true })

-- Use <Tab> for completion and navigation
vim.api.nvim_set_keymap("i", "<Tab>", 'pumvisible() ? "\\<C-n>" : "\\<Tab>"', { expr = true, noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<S-Tab>", 'pumvisible() ? "\\<C-p>" : "\\<C-h>"', { expr = true, noremap = true, silent = true })

-- Esc to remove highlights from gd
vim.api.nvim_set_keymap("n", "<Esc>", ":noh<CR>", { noremap = true, silent = true })

-- Show the full warning/error message from LSP Warnings
vim.keymap.set("n", "<C-e>", vim.diagnostic.open_float, { noremap = true, silent = true })

-- Set leader key to SPACE
vim.g.mapleader = " "

-- Enable hover on Cursor Hold
-- vim.o.updatetime = 300
-- vim.cmd [[autocmd CursorHold * lua vim.diagnostic.open_float(nil, {focus=false})]]

-- Enable diagnostic
vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { noremap = true, silent = true })

-- Enable formatting from build-in Dart
vim.keymap.set("n", "<leader>f", ":!dart format %<CR>", { noremap = true, silent = true })

-- Ctrl + S to save
vim.keymap.set("n", "<C-s>", "<Esc>:w<CR>", { noremap = true, silent = false })

-- Auto-Completion: Keep all suggestions visible while navigating
vim.opt.completeopt = { "menu", "menuone", "noselect", "preview" }

-- Install plugins
require("lazy").setup({
  {
    "neovim/nvim-lspconfig",  -- LSP support
  },
  {
    "dart-lang/dart-vim-plugin", -- Dart syntax highlighting
    ft = { "dart" } -- Load only for Dart files
  },
  {
    "akinsho/flutter-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "stevearc/dressing.nvim" } -- Required dependencies
  },
  "nvim-telescope/telescope.nvim", -- Fuzzy finder (optional)
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
  },
  -- Catppuccin theme
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false, -- Load immediately
    priority = 1000, -- Ensure it loads first
  },
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({})
      -- vim.api.nvim_set_keymap("n", "<C-n>", ":NvimTreeToggle<CR>", { noremap = true, silent = true })
      vim.keymap.set("n", "<leader>n", ":NvimTreeFindFile<CR>", { noremap = true, silent = true })
      -- Open when Tree is closed, focus when it has been already opened.
      vim.keymap.set("n", "<C-n>", function()
        local api = require("nvim-tree.api")
        if api.tree.is_visible() then
          api.tree.focus()  -- Focus if already open
        else
          api.tree.toggle()  -- Open if closed
        end
      end, { noremap = true, silent = true })

    end
  },
  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end
  },
  "hrsh7th/nvim-cmp", -- Completion plugin
  "hrsh7th/cmp-nvim-lsp", -- LSP completion source
  "L3MON4D3/LuaSnip", -- Snippet support
  "tpope/vim-surround", -- Vim Surround
  {
    "windwp/nvim-autopairs", -- Nvim auto pairs
    config = function()
      require("nvim-autopairs").setup({})
    end
  },
})

-- Flutter tools setup
require("flutter-tools").setup{}

-- Better highlighting
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "dart", "lua", "vim", "bash" }, -- Install Dart support
  highlight = {
    enable = true, -- Enable Treesitter highlighting 
  }, 
  indent = { enable = true }, 
  fold = { enable = true },
}
vim.opt.foldmethod = "indent"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldenable = false -- Start unfolded

-- NVIM Theme
require("catppuccin").setup({
  flavour = "mocha", -- latte, frappe, macchiato, mocha
  background = { -- :h background
    light = "latte",
    dark = "mocha",
  },
  transparent_background = false, -- disables setting the background color.
  show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
  term_colors = false, -- sets terminal colors (e.g. `g:terminal_color_0`)
  dim_inactive = {
    enabled = false, -- dims the background color of inactive window
    shade = "dark",
    percentage = 0.15, -- percentage of the shade to apply to the inactive window
  },
  no_italic = false, -- Force no italic
  no_bold = false, -- Force no bold
  no_underline = false, -- Force no underline
  styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
    comments = { "italic" }, -- Change the style of comments
    conditionals = { "italic" },
    loops = {},
    functions = {},
    keywords = {},
    strings = {},
    variables = {},
    numbers = {},
    booleans = {},
    properties = {},
    types = {},
    operators = {},
    -- miscs = {}, -- Uncomment to turn off hard-coded styles
  },
  color_overrides = {},
  custom_highlights = {},
  default_integrations = true,
  integrations = {
    lsp_trouble = true,
    telescope = true,
    which_key = true,
    cmp = true,
    gitsigns = true,
    nvimtree = true,
    treesitter = true,
    notify = false,
    mini = {
      enabled = true,
      indentscope_color = "",
    },
    -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
  },
})

-- setup must be called before loading
vim.cmd.colorscheme "catppuccin"

-- Configure Completion
local cmp = require("cmp")
cmp.setup({
  mapping = {
    ["<C-Space>"] = cmp.mapping.complete(), -- Show completion manually
    ['<C-j>'] = cmp.mapping.select_next_item(),  -- Move down
    ['<C-k>'] = cmp.mapping.select_prev_item(),  -- Move up
    ['<CR>'] = cmp.mapping.confirm({ select = true }),  -- Confirm selection
  },
  sources = {
    { name = "nvim_lsp" },
  },
})

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.dart",
  callback = function()
    vim.cmd("silent! !dart format %")
  end,
})

vim.opt.path:append("**")  -- Enable recursive file searching with :find

-- Fix WARNING The file has beeen changed since reading it!!!" issue
vim.opt.autoread = true
vim.opt.confirm = false  -- Disable confirmation WARNING prompts
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "BufReadPost" }, {
  callback = function()
    vim.cmd("checktime")
  end,
})

-- -- Enable gd & gD to go to definition
-- require("lspconfig").dartls.setup({
--     on_attach = function(client, bufnr)
--         print("Dart LSP attached!")  -- Debugging message
--         local opts = { noremap = true, silent = true, buffer = bufnr }
--         vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
--         vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
--         vim.keymap.set("n", "K", vim.lsp.buf.hover, opts) 
-- end,
-- })
