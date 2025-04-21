
vim.opt.rtp:prepend("~/.local/share/nvim/lazy/lazy.nvim")

-- Show line numbers
vim.opt.number = true

-- Use relative line numbers (Uncomment if needed)
vim.opt.relativenumber = true

-- Indentation
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "javascript", "typescript", "dart", "yaml", "json", "lua" }, -- Add your filetypes
  callback = function()
    vim.opt.expandtab = true    -- Convert tabs to spaces
    vim.opt.shiftwidth = 2
    vim.opt.tabstop = 2
    vim.opt.softtabstop = 2
  end,
})

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

-- Set to faster shortcut for toggling between current & previous file
vim.keymap.set("n", "<leader>e", "<C-^>", { noremap = true, silent = true })

-- Enable hover on Cursor Hold
-- vim.o.updatetime = 300
-- vim.cmd [[autocmd CursorHold * lua vim.diagnostic.open_float(nil, {focus=false})]]

-- Neovim LSP Diagnostic
vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { noremap = true, silent = true })
vim.diagnostic.config({
  virtual_text = false,  -- Disable inline error messages
  underline = true,      -- Keep underlines for warnings/errors
})

-- Enable formatting from build-in Dart
vim.keymap.set("n", "<leader>f", ":!dart format %<CR>", { noremap = true, silent = true })

-- Ctrl + S to save
vim.keymap.set("n", "<C-s>", "<Esc>:w<CR>", { noremap = true, silent = false })

-- Auto-Completion: Keep all suggestions visible while navigating
-- Not sure if this works
vim.opt.completeopt = { "menu", "menuone", "noselect", "preview" }

vim.keymap.set("n", "gr", vim.lsp.buf.references, { noremap = true, silent = true })

-- Install plugins
require("lazy").setup({
  {
    "rose-pine/neovim",
    name = "rose-pine",
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false, -- Load immediately
    priority = 1000, -- Ensure it loads first
  },
  {
    "EdenEast/nightfox.nvim",
    name = "nightfox",
    lazy = false, -- Load immediately
    priority = 1000, -- Ensure it loads first
  },
  {
    "smjonas/inc-rename.nvim",
    config = function()
      require("inc_rename").setup()
      vim.keymap.set("n", "<leader>rn", ":IncRename ")
    end,
  },
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
  {
    "nvim-telescope/telescope.nvim", -- Fuzzy finder (optional)
    config = function()
      require("telescope").setup({})
      vim.keymap.set("n", "<C-p>", ":Telescope find_files<CR>", { noremap = true, silent = true })
      vim.keymap.set("n", "<leader>o", ":Telescope lsp_document_symbols<CR>", { noremap = true, silent = true })
      vim.keymap.set("n", "gr", require('telescope.builtin').lsp_references, { noremap = true, silent = true })
    end
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
  },
  -- Catppuccin theme
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({})
      vim.api.nvim_set_keymap("n", "<C-n>", ":NvimTreeToggle<CR>", { noremap = true, silent = true })
      vim.keymap.set("n", "<leader>n", ":NvimTreeFindFile<CR>", { noremap = true, silent = true })
      -- Tab to navigate between active file & tree focuses.
      vim.keymap.set("n", "<Tab>", function()
        local api = require("nvim-tree.api")
        if vim.bo.filetype == "NvimTree" then
          -- If focus is on nvim-tree, move to the right (file)
          vim.cmd("wincmd l")
        else
          -- If focus is on file, move to the left (tree)
          api.tree.focus()
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
  "RRethy/vim-illuminate", -- Highlighting same occurrences
  {
    "windwp/nvim-autopairs", -- Nvim auto pairs
    config = function()
      require("nvim-autopairs").setup({})
    end
  },
})

-- Nvim colorscheme
-- vim.cmd.colorscheme("rose-pine-moon")
-- vim.cmd.colorscheme("catppuccin")
vim.cmd.colorscheme("nightfox")

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

-- Set up nightfox colorscheme
-- Palettes are the base color defines of a colorscheme.
-- You can override these palettes for each colorscheme defined by nightfox.
local palettes = {
  -- Everything defined under `all` will be applied to each style.
  all = {
    -- Each palette defines these colors:
    --   black, red, green, yellow, blue, magenta, cyan, white, orange, pink
    --
    -- These colors have 3 shades: base, bright, and dim
    --
    -- Defining just a color defines it's base color
    red = "#ff0000",
  },
  nightfox = {
    -- A specific style's value will be used over the `all`'s value
    red = "#c94f6d",
  },
  dayfox = {
    -- Defining multiple shades is done by passing a table
    blue = { base = "#4d688e", bright = "#4e75aa", dim = "#485e7d" },
  },
  nordfox = {
    -- A palette also defines the following:
    --   bg0, bg1, bg2, bg3, bg4, fg0, fg1, fg2, fg3, sel0, sel1, comment
    --
    -- These are the different foreground and background shades used by the theme.
    -- The base bg and fg is 1, 0 is normally the dark alternative. The others are
    -- incrementally lighter versions.
    bg1 = "#2e3440",

    -- sel is different types of selection colors.
    sel0 = "#3e4a5b", -- Popup bg, visual selection bg
    sel1 = "#4f6074", -- Popup sel bg, search bg

    -- comment is the definition of the comment color.
    comment = "#60728a",
  },
}

-- Spec's (specifications) are a mapping of palettes to logical groups that will be
-- used by the groups. Some examples of the groups that specs map would be:
--   - syntax groups (functions, types, keywords, ...)
--   - diagnostic groups (error, warning, info, hints)
--   - git groups (add, removed, changed)
--
-- You can override these just like palettes
local specs = {
  -- As with palettes, the values defined under `all` will be applied to every style.
  all = {
    syntax = {
      -- Specs allow you to define a value using either a color or template. If the string does
      -- start with `#` the string will be used as the path of the palette table. Defining just
      -- a color uses the base version of that color.
      keyword = "magenta",

      -- Adding either `.bright` or `.dim` will change the value
      conditional = "magenta.bright",
      number = "orange.dim",
    },
    git = {
      -- A color define can also be used
      changed = "#f4a261",
    },
  },
  nightfox = {
    syntax = {
      -- As with palettes, a specific style's value will be used over the `all`'s value.
      operator = "orange",
    },
  },
}

-- Groups are the highlight group definitions. The keys of this table are the name of the highlight
-- groups that will be overridden. The value is a table with the following values:
--   - fg, bg, style, sp, link,
--
-- Just like `spec` groups support templates. This time the template is based on a spec object.
local groups = {
  -- As with specs and palettes, the values defined under `all` will be applied to every style.
  all = {
    -- If `link` is defined it will be applied over any other values defined
    Whitespace = { link = "Comment" },

    -- Specs are used for the template. Specs have their palette's as a field that can be accessed
    IncSearch = { bg = "palette.cyan" },
  },
  nightfox = {
    -- As with specs and palettes, a specific style's value will be used over the `all`'s value.
    PmenuSel = { bg = "#73daca", fg = "bg0" },
  },
}
require('nightfox').setup({
  options = {
    -- Compiled file's destination location
    compile_path = vim.fn.stdpath("cache") .. "/nightfox",
    compile_file_suffix = "_compiled", -- Compiled file suffix
    transparent = false,     -- Disable setting background
    terminal_colors = true,  -- Set terminal colors (vim.g.terminal_color_*) used in `:terminal`
    dim_inactive = false,    -- Non focused panes set to alternative background
    module_default = true,   -- Default enable value for modules
    colorblind = {
      enable = false,        -- Enable colorblind support
      simulate_only = false, -- Only show simulated colorblind colors and not diff shifted
      severity = {
        protan = 0,          -- Severity [0,1] for protan (red)
        deutan = 0,          -- Severity [0,1] for deutan (green)
        tritan = 0,          -- Severity [0,1] for tritan (blue)
      },
    },
    styles = {               -- Style to be applied to different syntax groups
      comments = "NONE",     -- Value is any valid attr-list value `:help attr-list`
      conditionals = "NONE",
      constants = "NONE",
      functions = "NONE",
      keywords = "NONE",
      numbers = "NONE",
      operators = "NONE",
      strings = "NONE",
      types = "NONE",
      variables = "NONE",
    },
    inverse = {             -- Inverse highlight for different types
      match_paren = false,
      visual = false,
      search = false,
    },
    modules = {             -- List of various plugins and additional options
      -- ...
    },
  },
  palettes = palettes,
  specs = specs,
  groups = groups,
})

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
