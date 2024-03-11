{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.nvim;

  copilot-lua = pkgs.vimUtils.buildVimPlugin {
    name = "copilot-lua";
    src = pkgs.fetchFromGitHub {
      owner = "zbirenbaum";
      repo = "copilot.lua";
      rev = "a4a37dda9e48986e5d2a90d6a3cbc88fca241dbb";
      sha256 = "sha256-ttF9LW6PNKk/BBWET2BUqtq5f7OIZ7ohtQevAaP8srg=";
    };
  };

  nvim-tree-remote = pkgs.vimUtils.buildVimPlugin {
    name = "nvim-tree-remote";
    src = pkgs.fetchFromGitHub {
      owner = "kiyoon";
      repo = "nvim-tree-remote.nvim";
      rev = "294432a0e8a1f09be4db0a07029b2d1489a28d2f";
      sha256 = "sha256-4kWbnaBQoxiomZSQJkOLN20t8ZzZaXUAshcgfggKWbU=";
    };
  };

  custom-nvim-lspconfig =
    pkgs.vimPlugins.nvim-lspconfig.overrideAttrs
    (oldAttrs: {
      version = "custom";
      src = pkgs.fetchFromGitHub {
        owner = "neovim";
        repo = "nvim-lspconfig";
        rev = "e52efca5d4f5536533d447ec0d97e4d525b37ace";
        sha256 = "sha256-ZqCwGpSmLhfnWYNdgrkvGXOv44wmEUVhfuo+i/cUfck=";
      };
    });

  custom-symbols-outline-nvim = pkgs.vimPlugins.symbols-outline-nvim.overrideAttrs (oldAttrs: {
    version = "custom";
    src = pkgs.fetchFromGitHub {
      owner = "simrat39";
      repo = "symbols-outline.nvim";
      rev = "512791925d57a61c545bc303356e8a8f7869763c";
      sha256 = "sha256-Kori/wRtg/bz4luU5esUwIaZ+4G6Ilb4T02xE0J+hYU=";
    };
  });

  vimPlugins =
    pkgs.vimPlugins
    // {
      nvim-lspconfig = custom-nvim-lspconfig;
      symbols-outline-nvim = custom-symbols-outline-nvim;
    };
in {
  options.modules.nvim = {enable = mkEnableOption "nvim";};
  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        rnix-lsp
        nixfmt
        alejandra
        nil # Nix
        sumneko-lua-language-server
        stylua # Lua
        nnn # file manager
        ripgrep
        xclip
        fd
        tree-sitter
        gcc
        nodejs-slim
        nodePackages.pyright
        nodePackages.dockerfile-language-server-nodejs
        nodePackages.yaml-language-server
      ];
    };
    programs.neovim = {
      enable = true;
      extraLuaConfig = ''
        local o = vim.opt
        local g = vim.g

        -- Autocmds
        vim.cmd [[
        augroup CursorLine
            au!
            au VimEnter * setlocal cursorline
            au WinEnter * setlocal cursorline
            au BufWinEnter * setlocal cursorline
            au WinLeave * setlocal nocursorline
        augroup END
        autocmd FileType nix setlocal shiftwidth=4
        colorscheme tokyonight-storm
        ]]

        -- Keybinds
        local map = vim.api.nvim_set_keymap
        local opts = {
          silent = true,
          noremap = true,
        }

        -- map("n", "<C-h>", "<C-w>h", opts)
        --map("n", "<C-j>", "<C-w>j", opts)
        -- map("n", "<C-k>", "<C-w>k", opts)
        -- map("n", "<C-l>", "<C-w>l", opts)
        map('n', '<C-g>', ':Telescope live_grep path=%:p:h select_buffer=true <CR>', opts)
        map('n', '<C-f>', ':Telescope find_files path=%:p:h select_buffer=true <CR>', opts)
        map('n', '<C-b>', ':Telescope file_browser respect_gitignore=false path=%:p:h grouped=true select_buffer=true git_status=true <CR>', { noremap = true } )
        map('n', 'j', 'gj', opts)
        map('n', 'k', 'gk', opts)
        map('n', ';', ':', { noremap = true } )

        map('n', '<C-h>', ':BufferLineCyclePrev <CR>', opts)
        map('n', '<C-l>', ':BufferLineCycleNext <CR>', opts)
        map('n', '<C-x>', ':bd <CR>', opts)
        map('n', '<C-_>', 'gc', opts)

        map('n', '<leader>]', ':SymbolsOutline <CR>', opts)

        g.mapleader = '\\'

        -- Performance
        o.lazyredraw = true;
        o.shell = "zsh"
        o.shadafile = "NONE"

        -- Colors
        o.termguicolors = true

        -- Undo files
        o.undofile = true

        -- Indentation
        o.smartindent = true
        o.tabstop = 4
        o.shiftwidth = 4
        o.shiftround = true
        o.expandtab = true
        o.scrolloff = 3

        -- Set clipboard to use system clipboard
        o.clipboard = "unnamedplus"

        -- Use mouse
        o.mouse = "a"

        -- Nicer UI settings
        o.cursorline = true
        o.relativenumber = true
        o.number = true

        -- Get rid of annoying viminfo file
        o.viminfo = ""
        o.viminfofile = "NONE"

        -- Miscellaneous quality of life
        o.ignorecase = true
        o.ttimeoutlen = 5
        o.hidden = true
        o.shortmess = "atI"
        o.wrap = false
        o.backup = false
        o.writebackup = false
        o.errorbells = false
        o.swapfile = false
        o.showmode = false
        o.laststatus = 3
        o.pumheight = 6
        o.splitright = true
        o.splitbelow = true
        o.completeopt = "menuone,noselect"
      '';
      plugins = with vimPlugins; [
        vim-nix
        plenary-nvim
        nvim-web-devicons
        editorconfig-nvim
        tokyonight-nvim

        # Telecope and supporting plugins
        telescope-file-browser-nvim
        {
          plugin = telescope-nvim;
          config = ''
            lua << EOF
            require('telescope').setup {
                extensions = {
                    file_browser = {
                        hijack_netrw = true,
                        hidden = true,
                        grouped = true,
                    },
                },
            }
            require('telescope').load_extension 'file_browser'
            EOF
          '';
        }
        {
          plugin = barbecue-nvim;
          config = ''
            lua << EOF
            require('barbecue').setup {
                theme = 'tokyonight',
            }
            EOF
          '';
        }
        {
          plugin = lualine-nvim;
          config = ''
            lua << EOF
            require('lualine').setup {
                options = {
                    theme = 'tokyonight',
                }
            }
            EOF
          '';
        }
        {
          plugin = nvim-autopairs;
          config = "lua require('nvim-autopairs').setup{}";
        }
        {
          plugin = nvim-tree-remote;
        }
        {
          plugin = vim-illuminate;
          config = "lua require('illuminate').configure{}";
        }
        {
          plugin = copilot-lua;
          config = ''
            lua << EOF
            require('copilot').setup{
                panel = {
                    auto_refresh = true,
                },
                suggestion = {
                    auto_trigger = true,
                },
                filetypes = {
                    ["*"] = true,
                },
            }
            EOF
          '';
        }
        {
          plugin = gitsigns-nvim;
          config = ''
            lua << EOF
            require('gitsigns').setup {
              current_line_blame = true,
              current_line_blame_opts = {
                virt_text = true,
                virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
                delay = 1000,
                ignore_whitespace = true,
              },
              current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
            }
            EOF
          '';
        }
        {
          plugin = symbols-outline-nvim;
          config = ''
            lua <<EOF
            require('symbols-outline').setup {
                highlight_hovered_item = true,
                auto_preview = true,
                auto_close = true,
                show_numbers = true,
            }
            EOF
          '';
        }
        {
          plugin = comment-nvim;
          config = "lua require('Comment').setup{}";
        }
        {
          plugin = bufferline-nvim;
          config = ''
            lua << EOF
            require("bufferline").setup{}
            EOF
          '';
        }
        {
          plugin = impatient-nvim;
          config = "lua require('impatient')";
        }
        {
          plugin = lualine-nvim;
          config = "lua require('lualine').setup()";
        }
        {
          plugin = indent-blankline-nvim;
          config = "lua require('ibl').setup()";
        }
        {
          plugin = nvim-lspconfig;
          config = ''
            lua << EOF
            require('lspconfig').bashls.setup{}
            require('lspconfig').ansiblels.setup{}
            require('lspconfig').docker_compose_language_service.setup{}
            require('lspconfig').dockerls.setup{}
            require('lspconfig').eslint.setup{}
            require('lspconfig').jsonls.setup{}
            require('lspconfig').lua_ls.setup{
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = {'vim'}
                        }
                    }
                }
            }
            require('lspconfig').nil_ls.setup{}
            require('lspconfig').rnix.setup{}
            -- require('lspconfig').pylsp.setup{}
            -- require('lspconfig').pylyzer.setup{}
            require('lspconfig').pyright.setup{}
            require('lspconfig').yamlls.setup{}
            EOF
          '';
        }
        {
          plugin = nvim-treesitter;
          config = ''
            lua << EOF
            require('nvim-treesitter.configs').setup {
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },
            }
            EOF
          '';
        }
        {
          plugin = nvim-dap;
          config = "lua require('dap')";
        }
        {
          plugin = nvim-dap-ui;
          config = "lua require('dapui').setup()";
        }
        {
          plugin = nvim-dap-python;
          config = "lua require('dap-python')";
        }
      ];
    };
  };
}
