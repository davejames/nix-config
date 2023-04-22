{  lib, config, pkgs, ... }:
with lib;
let
    cfg = config.modules.nvim;

    copilot-lua = pkgs.vimUtils.buildVimPlugin {
        name = "copilot-lua";
        src = pkgs.fetchFromGitHub {
            owner = "zbirenbaum";
            repo = "copilot.lua";
            rev = "a4a37dda9e48986e5d2a90d6a3cbc88fca241dbb";
            # sha256 = pkgs.lib.fakeSha256;
            sha256 = "sha256-ttF9LW6PNKk/BBWET2BUqtq5f7OIZ7ohtQevAaP8srg=";
        };
    };

    # custom-neovim = pkgs.neovim.overrideAttrs (oldAttrs: {
    #     version = "0.8.3";
    #     src = pkgs.fetchFromGitHub {
    #         owner = "neovim";
    #         repo = "neovim";
    #         rev = "v0.8.3";
    #         sha256 = "sha256-ItJ8aX/WUfcAovxRsXXyWKBAI92hFloYIZiv7viPIdQ=";
    #     };
    #     buildInputs = pkgs.neovim.buildInputs ++ [ pkgs.python3 ];
    # });

    custom-nvim-lspconfig = pkgs.vimPlugins.nvim-lspconfig.overrideAttrs (oldAttrs: {
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
            #sha256 = lib.fakeSha256;
            sha256 = "sha256-Kori/wRtg/bz4luU5esUwIaZ+4G6Ilb4T02xE0J+hYU=";
        };
    });

    vimPlugins = pkgs.vimPlugins // { 
        nvim-lspconfig = custom-nvim-lspconfig; 
        symbols-outline-nvim = custom-symbols-outline-nvim;
    };

in {
    options.modules.nvim = { enable = mkEnableOption "nvim"; };
    config = mkIf cfg.enable {

        home.file.".config/nvim/settings.lua".source = ./init.lua;
        
        home.packages = with pkgs; [
            rnix-lsp nixfmt nil # Nix
            sumneko-lua-language-server stylua # Lua
            nnn # file manager
            ripgrep
            xclip
            fd
            nodejs-slim
            nodePackages.pyright
        ];

        programs.fish = {
            #initExtra = ''
            #    export EDITOR="nvim"
            #'';

            # shellAliases = {
            #     h = "nvim -i NONE";
            #     vim = "nvim -i NONE";
            #     nvim = "nvim -i NONE";
            # };
        };

        programs.neovim = {
            enable = true;
            # package = custom-neovim;
            plugins = with vimPlugins; [ 
                vim-nix
                plenary-nvim
                nvim-web-devicons
                {
                    plugin = tokyonight-nvim;
                    config = "colorscheme tokyonight-storm";
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
                    plugin = telescope-nvim;
                    #config = "lua require('telescope').setup()";
                }
                {
                    plugin = telescope-file-browser-nvim;
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
                    config = "lua require('indent_blankline').setup()";
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

            extraConfig = ''
                luafile ~/.config/nvim/settings.lua
            '';
        };
    };
}
