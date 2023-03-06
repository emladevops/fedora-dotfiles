vim.cmd [[packadd packer.nvim]]
local yabs = require('yabs')
vim.cmd("set number")
vim.cmd("tnoremap <Esc> <C-\\><C-n>")
vim.opt.autoindent = true
vim.opt.cursorline = true
vim.opt.autowrite = true
vim.o.expandtab = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2
-- Setting up all the hotkeys for us.
vim.g.mapleader = ' '
vim.keymap.set('n', '<Leader>t', ":FloatermToggle<CR>", {silent=true})
vim.keymap.set('n', '<Leader>n', ":FloatermNew<CR>", {silent=true})
vim.keymap.set('n', '<Leader>.', ":FloatermNext<CR>", {silent=true})
vim.keymap.set('n', '<Leader>e', ":NvimTreeToggle<CR>", {silent=true})
vim.keymap.set('n', '<C-t>', ":tabnew<CR>", {silent=true})
vim.keymap.set('n', '<C-l>', ":tabnext<CR>", {silent=true})
vim.keymap.set('n', '<C-h>', ":tabprevious<CR>", {silent=true})
vim.keymap.set('n', '<C-f>', ":Telescope live_grep<CR>", {silent=true})
vim.keymap.set('n', '<C-p>', ":Telescope find_files<CR>", {silent=true})
vim.keymap.set('n', '<C-r>', ":FloatermNew g++ % -O2 -o a.out && ./a.out && rm -rf a.out && echo '\\n\\nPress any key to continue...'; read -k1 -s<CR>")
vim.keymap.set('n', '<C-\\>', ":sp<CR>")
vim.keymap.set('n', '<C-s>', ":vsp<CR>")
vim.keymap.set('n', '<C-x>', ":q<CR>", {silent=true})
vim.keymap.set('n', '<C-l>', ":noh<CR>", {silent=true})
vim.keymap.set('n', '<C-q>', ":q<CR>", {silent=true})
-- examples for your init.lua
-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
-- vim.opt.termguicolors = true

-- empty setup using defaults
require("nvim-tree").setup()
require'lspconfig'.tsserver.setup{}
require('lualine').setup()
require('smart-splits').setup()
vim.keymap.set('n', '<C-r>', require('smart-splits').start_resize_mode, {silent=true})

-- Setup theme
--

vim.g.material_style = "deep ocean"
vim.cmd("colorscheme material")

require('yabs'):setup({
  languages = { -- List of languages in vim's `filetype` format
    lua = {
      tasks = {
        run = {
          command = 'luafile %', -- The command to run (% and other
          -- wildcards will be automatically
          -- expanded)
          type = 'vim',  -- The type of command (can be `vim`, `lua`, or
          -- `shell`, default `shell`)
        },
      },
    },
    c = {
      default_task = 'build_and_run',
      tasks = {
        build = {
          command = 'gcc main.c -o main',
          output = 'quickfix', -- Where to show output of the
          -- command. Can be `buffer`,
          -- `consolation`, `echo`,
          -- `quickfix`, `terminal`, or `none`
          opts = { -- Options for output (currently, there's only
            -- `open_on_run`, which defines the behavior
            -- for the quickfix list opening) (can be
            -- `never`, `always`, or `auto`, the default)
            open_on_run = 'always',
          },
        },
        run = { -- You can specify as many tasks as you want per
          -- filetype
          command = './main',
          output = 'consolation',
        },
        build_and_run = { -- Setting the type to lua means the command
          -- is a lua function
          command = function()
            -- The following api can be used to run a task when a
            -- previous one finishes
            -- WARNING: this api is experimental and subject to
            -- changes
            require('yabs'):run_task('build', {
              -- Job here is a plenary.job object that represents
              -- the finished task, read more about it here:
              -- https://github.com/nvim-lua/plenary.nvim#plenaryjob
              on_exit = function(Job, exit_code)
                -- The parameters `Job` and `exit_code` are optional,
                -- you can omit extra arguments or
                -- skip some of them using _ for the name
                if exit_code == 0 then
                  require('yabs').languages.c:run_task('run')
                end
              end,
            })
          end,
          type = 'lua',
        },
      },
    },
  },
  tasks = { -- Same values as `language.tasks`, but global
    build = {
      command = 'echo building project...',
      output = 'consolation',
    },
    run = {
      command = 'echo running project...',
      output = 'echo',
    },
    optional = {
      command = 'echo runs on condition',
      -- You can specify a condition which determines whether to enable a
      -- specific task
      -- It should be a function that returns boolean,
      -- not a boolean directly
      -- Here we use a helper from yabs that returns such function
      -- to check if the files exists
      condition = require('yabs.conditions').file_exists('filename.txt'),
    },
  },
  opts = { -- Same values as `language.opts`
    output_types = {
      quickfix = {
        open_on_run = 'always',
      },
    },
  },
})

-- The setup config table shows all available config options with their default values:
require("presence"):setup({
    -- General options
    auto_update         = true,                       -- Update activity based on autocmd events (if `false`, map or manually execute `:lua package.loaded.presence:update()`)
    neovim_image_text   = "Neovim 0.8.3", -- Text displayed when hovered over the Neovim image
    main_image          = "neovim",                   -- Main image display (either "neovim" or "file")
    client_id           = "793271441293967371",       -- Use your own Discord application client id (not recommended)
    log_level           = nil,                        -- Log messages at or above this level (one of the following: "debug", "info", "warn", "error")
    debounce_timeout    = 10,                         -- Number of seconds to debounce events (or calls to `:lua package.loaded.presence:update(<filename>, true)`)
    enable_line_number  = false,                      -- Displays the current line number instead of the current project
    blacklist           = {},                         -- A list of strings or Lua patterns that disable Rich Presence if the current file name, path, or workspace matches
    buttons             = true,                       -- Configure Rich Presence button(s), either a boolean to enable/disable, a static table (`{{ label = "<label>", url = "<url>" }, ...}`, or a function(buffer: string, repo_url: string|nil): table)
    file_assets         = {},                         -- Custom file asset definitions keyed by file names and extensions (see default config at `lua/presence/file_assets.lua` for reference)
    show_time           = true,                       -- Show the timer

    -- Rich Presence text options
    editing_text        = "Working on %s",               -- Format string rendered when an editable file is loaded in the buffer (either string or function(filename: string): string)
    file_explorer_text  = "Browsing %s",              -- Format string rendered when browsing a file explorer (either string or function(file_explorer_name: string): string)
    git_commit_text     = "Committing changes",       -- Format string rendered when committing changes in git (either string or function(filename: string): string)
    plugin_manager_text = "Managing plugins",         -- Format string rendered when managing plugins (either string or function(plugin_manager_name: string): string)
    reading_text        = "Reading %s",               -- Format string rendered when a read-only or unmodifiable file is loaded in the buffer (either string or function(filename: string): string)
    workspace_text      = "Gitting on %s",            -- Format string rendered when in a git repository (either string or function(project_name: string|nil, filename: string): string)
    line_number_text    = "Line %s out of %s",        -- Format string rendered when `enable_line_number` is set to true (either string or function(line_number: number, line_count: number): string)
})

-- OR setup with some options
require("nvim-tree").setup({
  sort_by = "case_sensitive",
  view = {
    adaptive_size = true,
    mappings = {
      list = {
        { key = "u", action = "dir_up" },
        { key = "c", action = "create" },
        { key = "<C-r>", action = "cd" },
      },
    },
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
})

require'cmp'.setup {
  sources = {
    { name = 'nvim_lsp' }
  }
}

require("mason").setup({
    ui = {
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
        }
    }
})

-- The nvim-cmp almost supports LSP's capabilities so You should advertise it to LSP servers..
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- The following example advertise capabilities to `clangd`.
require'lspconfig'.clangd.setup {
  capabilities = capabilities,
}

-- Set up nvim-cmp.
  local cmp = require'cmp'

  cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
        -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
      end,
    },
    window = {
      -- completion = cmp.config.window.bordered(),
      -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' }, -- For vsnip users.
      -- { name = 'luasnip' }, -- For luasnip users.
      -- { name = 'ultisnips' }, -- For ultisnips users.
      -- { name = 'snippy' }, -- For snippy users.
    }, {
      { name = 'buffer' },
    })
  })

  -- Set configuration for specific filetype.
  cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
    }, {
      { name = 'buffer' },
    })
  })

  -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })

  -- Set up lspconfig.
  local capabilities = require('cmp_nvim_lsp').default_capabilities()
  -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
  require('lspconfig')['clangd'].setup {
    capabilities = capabilities
  }

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'
  use 'hrsh7th/nvim-cmp'
  use { 'feline-nvim/feline.nvim', branch = '0.5-compat' }
  use {
  'lewis6991/gitsigns.nvim',
  -- tag = 'release' -- To use the latest release (do not use this if you run Neovim nightly or dev builds!)
  }
   use 'voldikss/vim-floaterm'
   use 'williamboman/mason.nvim'
   use 'williamboman/mason-lspconfig.nvim'
   use 'neovim/nvim-lspconfig'
   use 'nvim-tree/nvim-web-devicons'
   use {'romgrk/barbar.nvim'}
   use 'nvim-tree/nvim-tree.lua'
   use 'jiangmiao/auto-pairs'
   use 'nvim-treesitter/nvim-treesitter'
   use { "catppuccin/nvim", as = "catppuccin" }
   use {
  'nvim-telescope/telescope.nvim', tag = '0.1.0',
-- or                            , branch = '0.1.x',
  requires = { {'nvim-lua/plenary.nvim'} }
   }
   use {
  'pianocomposer321/yabs.nvim',
  requires = { 'nvim-lua/plenary.nvim' }
   }
   use 'andweeb/presence.nvim'
   use 'marko-cerovac/material.nvim'
   use 'nvim-lualine/lualine.nvim'
   use('mrjones2014/smart-splits.nvim')
end)

