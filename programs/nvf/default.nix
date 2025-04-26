# Neovim Flake (NVF) Configuration
{ config, lib, pkgs, ... }:

{
  programs.nvf = {
    enable = true;
    enableManpages = true;

    # Settings for NVF
    settings = {
      vim = {
        useSystemClipboard = true;
        viAlias = false;
        vimAlias = true;
        theme = {
          enable = true;
          name = "tokyonight";
          style = "night";
        };
        statusline.lualine.enable = true;
        telescope.enable = true;
        assistant.copilot.enable = true;
        assistant.copilot.cmp.enable = true;
        assistant.copilot.mappings.panel.open = "<leader-CR>";
        navigation.harpoon = {
          enable = true;
          # Custom mappings for Harpoon
          mappings = {
            markFile = "<leader>ha"; # Mark current file (was "<leader>a" by default)
            listMarks = "<leader>hh"; # List marked files (was "<C-e>" by default)
            file1 = "<leader>h1"; # Go to file 1 (was "<C-j>" by default)
            file2 = "<leader>h2"; # Go to file 2 (was "<C-k>" by default)
            file3 = "<leader>h3"; # Go to file 3 (was "<C-l>" by default)
            file4 = "<leader>h4"; # Go to file 4 (was "<C-;>" by default)
          };
        };
        autocomplete.nvim-cmp.enable = true;
        utility.yazi-nvim.enable = true;
        extraLuaFiles = [
          (builtins.path {
            path = ../../programs/editor/nvim/init.lua;
            name = "init-lua";
          })
        ];

        # General keymaps
        keymaps = [
          # Save and quit
          {
            key = "<leader>wq";
            mode = "n";
            action = ":wq<CR>";
          }
          # Quit without saving
          {
            key = "<leader>qq";
            mode = "n";
            action = ":q!<CR>";
          }
          # Save
          {
            key = "<leader>ww";
            mode = "n";
            action = ":w<CR>";
          }
          # Open URL under cursor
          {
            key = "gx";
            mode = "n";
            action = ":!open <c-r><c-a><CR>";
          }
          # Quit all
          {
            key = "<leader>qa";
            mode = "n";
            action = ":qa<CR>";
          }
          # Save all
          {
            key = "<leader>wa";
            mode = "n";
            action = ":wa<CR>";
          }

          # Navigate vim panes
          {
            key = "<c-k>";
            mode = "n";
            action = ":wincmd k<CR>";
          }
          {
            key = "<c-j>";
            mode = "n";
            action = ":wincmd j<CR>";
          }
          {
            key = "<c-h>";
            mode = "n";
            action = ":wincmd h<CR>";
          }
          {
            key = "<c-l>";
            mode = "n";
            action = ":wincmd l<CR>";
          }

          # Split window management
          {
            key = "<leader>sv";
            mode = "n";
            action = "<C-w>v";
          }
          {
            key = "<leader>sg";
            mode = "n";
            action = "<C-w>s";
          }
          {
            key = "<leader>se";
            mode = "n";
            action = "<C-w>=";
          }
          {
            key = "<leader>sx";
            mode = "n";
            action = ":close<CR>";
          }
          {
            key = "<leader>sj";
            mode = "n";
            action = "<C-w>-";
          }
          {
            key = "<leader>sk";
            mode = "n";
            action = "<C-w>+";
          }
          {
            key = "<leader>sl";
            mode = "n";
            action = "<C-w>>5";
          }
          {
            key = "<leader>sh";
            mode = "n";
            action = "<C-w><5";
          }

          # Tab management
          {
            key = "<leader>to";
            mode = "n";
            action = ":tabnew<CR>";
          }
          {
            key = "<leader>tx";
            mode = "n";
            action = ":tabclose<CR>";
          }
          {
            key = "<leader>tn";
            mode = "n";
            action = ":tabn<CR>";
          }
          {
            key = "<leader>tp";
            mode = "n";
            action = ":tabp<CR>";
          }
          {
            key = "<leader>1";
            mode = "n";
            action = ":tabn 1<CR>";
          }
          {
            key = "<leader>2";
            mode = "n";
            action = ":tabn 2<CR>";
          }
          {
            key = "<leader>3";
            mode = "n";
            action = ":tabn 3<CR>";
          }
          {
            key = "<leader>4";
            mode = "n";
            action = ":tabn 4<CR>";
          }
          {
            key = "<leader>5";
            mode = "n";
            action = ":tabn 5<CR>";
          }
          {
            key = "<leader>6";
            mode = "n";
            action = ":tabn 6<CR>";
          }
          {
            key = "<leader>7";
            mode = "n";
            action = ":tabn 7<CR>";
          }
          {
            key = "<leader>8";
            mode = "n";
            action = ":tabn 8<CR>";
          }
          {
            key = "<leader>9";
            mode = "n";
            action = ":tabn 9<CR>";
          }

          # Diff keymaps
          {
            key = "<leader>cc";
            mode = "n";
            action = ":diffput<CR>";
          }
          {
            key = "<leader>cj";
            mode = "n";
            action = ":diffget 1<CR>";
          }
          {
            key = "<leader>ck";
            mode = "n";
            action = ":diffget 3<CR>";
          }
          {
            key = "<leader>cn";
            mode = "n";
            action = "]c";
          }
          {
            key = "<leader>cp";
            mode = "n";
            action = "[c";
          }

          # Quickfix keymaps
          {
            key = "<leader>qo";
            mode = "n";
            action = ":copen<CR>";
          }
          {
            key = "<leader>qf";
            mode = "n";
            action = ":cfirst<CR>";
          }
          {
            key = "<leader>qn";
            mode = "n";
            action = ":cnext<CR>";
          }
          {
            key = "<leader>qp";
            mode = "n";
            action = ":cprev<CR>";
          }
          {
            key = "<leader>ql";
            mode = "n";
            action = ":clast<CR>";
          }
          {
            key = "<leader>qc";
            mode = "n";
            action = ":cclose<CR>";
          }
        ];

        languages = {
          enableLSP = true;
          enableTreesitter = true;
          nix.enable = true;
          nix.treesitter.enable = true;
          ts.enable = true;
          python.enable = true;
          lua.enable = true;
        };

        options = {
          tabstop = 2;
          shiftwidth = 2;
        };
      };
    };
  };
}
