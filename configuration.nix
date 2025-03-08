# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config
, lib
, pkgs
, inputs
, ...
}:
{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  imports =
    [
      inputs.home-manager.nixosModules.home-manager
      inputs.nvf.nixosModules.default
      inputs.jovian-nixos.nixosModules.default
      inputs.nix-gaming.nixosModules.platformOptimizations
      inputs.sops-nix.nixosModules.sops
    ];


  home-manager.backupFileExtension = "backup";
  hardware = {
    graphics = {
      enable = true;
    };
    uinput.enable = true;
    bluetooth = {
      powerOnBoot = true; # powers up the default Bluetooth controller on boot
      enable = true; # enables support for Bluetooth
    };
    nvidia = {
      modesetting.enable = true;
      powerManagement.enable = true;
      powerManagement.finegrained = false;
      open = true;
      nvidiaSettings = true;
      dynamicBoost.enable = false;
      package = config.boot.kernelPackages.nvidiaPackages.beta;
      prime = {
        sync.enable = true;
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
    nvidia-container-toolkit.enable = true;

  };

  programs = {
    hyprland.enable = true;
    direnv.enable = true;

    zsh = {
      enable = true;
      interactiveShellInit = ''
        # Load Powerlevel10k
        source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      '';
    };


    steam.gamescopeSession.enable = true;
    # systemd.user.enable = true;
    gamemode = {
      enable = true;
    };

    steam = {
      enable = true;
      localNetworkGameTransfers.openFirewall = true;
    };
    git = {
      enable = true;
    };

    xwayland.enable = true;

    nvf = {
      enable = true;
      enableManpages = true;
      # your settings need to go into the settings attribute set
      # most settings are documented in the appendix
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
              path = ./programs/editor/nvim/init.lua;
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

            # Telescope
            {
              key = "<leader>ff";
              mode = "n";
              action = ''lua require('telescope.builtin').find_files()'';
            }
            {
              key = "<leader>fg";
              mode = "n";
              action = ''lua require('telescope.builtin').live_grep()'';
            }
            {
              key = "<leader>fb";
              mode = "n";
              action = ''lua require('telescope.builtin').buffers()'';
            }
            {
              key = "<leader>fh";
              mode = "n";
              action = ''lua require('telescope.builtin').help_tags()'';
            }
            {
              key = "<leader>fs";
              mode = "n";
              action = ''lua require('telescope.builtin').current_buffer_fuzzy_find()'';
            }
            {
              key = "<leader>fo";
              mode = "n";
              action = ''lua require('telescope.builtin').lsp_document_symbols()'';
            }
            {
              key = "<leader>fi";
              mode = "n";
              action = ''lua require('telescope.builtin').lsp_incoming_calls()'';
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
    # programs.neovim = {
    #
    #   enable = true; 
    #   defaultEditor = true;
    # };
  };
  sops = {
    defaultSopsFile = ./secrets/github_ssh.yaml;
    age = {
      sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
      keyFile = "/var/lib/sops-nix/key.txt";
      generateKey = true;
    };
  };




  environment.etc."gitconfig".text = ''
    [alias]
      acp = "!f() { git add . && git commit -m \"$*\" && git push; }; f"
  '';

  # sops.secrets.github_ssh_key = {
  #    key = "github_ssh_key";
  #    path = "/root/.ssh/github_id_ed25519";
  #    owner = "root";
  #    group = "root";
  #    mode = "0600";
  #  };
  sops.secrets.github_ssh_key = {
    path = "/home/undead/.ssh/id_ed25519";
    owner = "undead";
  };
  xdg.mime.defaultApplications = {

    "application/pdf" = "org.qutebrowser.qutebrowser.desktop";
  };

  xdg.portal = { enable = true; extraPortals = [ pkgs.xdg-desktop-portal-hyprland ]; };
  users.groups.uinput = { };

  systemd.services.kanata-internalKeyboard.serviceConfig = {
    SupplementaryGroups = [
      "input"
      "uinput"
    ];
  };
  # programs.nix-ld.enable = true;
  #   programs.nix-ld.libraries = with pkgs; [
  # Add any missing dynamic libraries for unpackaged programs
  # here, NOT in environment.systemPackages
  # libxkbcommon
  # xorg.libxcb
  # ];
  virtualisation.podman = {
    enable = true;
    # dockerCompat = true;
  };
  virtualisation.docker.enable = true;
  specialisation = {

    on-the-go.configuration = {
      system.nixos.tags = [ "on-the-go" ];
      hardware.nvidia = {
        prime = {
          offload.enable = lib.mkForce true;
          offload.enableOffloadCmd = lib.mkForce true;
          sync.enable = lib.mkForce false;
        };
        powerManagement.finegrained = lib.mkForce true;
      };
    };
    gaming.configuration = {
      system.nixos.tags = [ "gaming" ];
      jovian.steam = {
        enable = true;
        desktopSession = "hyprland";
        autoStart = true;
        user = "undead";
      };

      # NVIDIA-specific environment variables for gaming
      environment.sessionVariables = {
        # Core NVIDIA variables
        LIBVA_DRIVER_NAME = "nvidia";
        __GLX_VENDOR_LIBRARY_NAME = "nvidia";
        VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/nvidia_icd.x86_64.json";

        # Direct rendering
        __NV_PRIME_RENDER_OFFLOAD = "1";
        NVD_BACKEND = "direct";
        GBM_BACKEND = "nvidia-drm";

        # Steam/Gamescope specific
        STEAM_RUNTIME_PREFER_HOST_LIBRARIES = "1";
        DXVK_ASYNC = "1"; # Better performance for DXVK games
        PROTON_HIDE_NVIDIA_GPU = "0";

        # Disable compositing and VRR for maximum performance
        GAMESCOPE_DISABLE_BUFFERING = "1";
        GAMESCOPE_FORCE_FULLSCREEN = "1";
      };
      programs.steam.platformOptimizations.enable = lib.mkForce true;
      boot.kernelPackages = lib.mkForce pkgs.linuxPackages_xanmod;
    };
  };


  # Bootloader.
  boot = {
    kernelModules = [ "uinput" ];
    loader.systemd-boot.enable = true;
    binfmt.emulatedSystems = [ "aarch64-linux" ];

    loader.efi.canTouchEfiVariables = true;
  };
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.supportedLocales = [
    "en_US.UTF-8/UTF-8"
    "es_CO.UTF-8/UTF-8"
  ];

  # Configure keymap in X11
  services = {
    xserver.xkb = {
      layout = "us";
      variant = "";
    };
    fstrim.enable = true;
    blueman.enable = true;

    xserver.videoDrivers = [ "nvidia" ];
    upower.enable = true;
    pulseaudio.enable = false;
    openssh.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # Uncomment the following line if you want to use JACK applications
      # jack.enable = true;
    };

    udev.extraRules = ''
      KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"
    '';
    kanata = {
      enable = true;
      keyboards = {
        internalKeyboard = {
          devices = [
            "/dev/input/by-id/usb-SEMICO_Redgear_Shadow_Blade_Mechanical_Keyboard-event-kbd"
            "/dev/input/by-id/usb-ITE_Tech._Inc._ITE_Device_8176_-event-kbd"
            "/dev/usb/by-id/usb-SINO_WEALTH_Bluetooth_Keyboard-event-kbd"
          ];
          extraDefCfg = "process-unmapped-keys yes";
          config = ''
            ;; Define source keys to intercept (left and right hand keys)
            (defsrc
              q w e r t y u i o p
              a s d f g h j k l ;
              z x c v b n m , . /
            )

            ;; Variables for timing and key groups
            (defvar
              tap-time 100
              hold-time 110
              left-hand-keys (
                q w e r t
                a s d f g
                z x c v b
              )
              right-hand-keys (
                y u i o p
                h j k l ;
                n m , . /
              )
            )

            ;; Base layer with normal keys and special aliases
            (deflayer base
              q w e @r @t y @u i o p
              @a @s @d @f g h @j @k @l @;
              z x c v b n m , . /
            )

            ;; Nomods layer: all keys type normally
            (deflayer nomods
              q w e r t y u i o p
              a s d f g h j k l ;
              z x c v b n m , . /
            )

            ;; Numpad layer: right side becomes number pad, others transparent
            (deflayer numpad
              _ _ _ _ _ _ 7 8 9 0
              _ _ _ _ _ _ 4 5 6 .
              _ _ _ _ _ _ 1 2 3 _
            )

            ;; Symbols layer: left side becomes symbols, others transparent
            (deflayer symbols
              S-1 S-2 S-3 S-4 S-5 _ _ _ _ _
              S-6 S-7 S-8 S-9 S-0 _ _ _ _ _
              _ - = + \ _ _ _ _ _
            )

            ;; Navigation layer: left side becomes navigation keys, others transparent
            (deflayer navigation
              _ _ _ _ _ home pgdn pgup end ins  
              _ _ _ _ _ left down up right del
              _ _ _ _ _ _ _ _ _ _
            )
            ;; Fake key to return to base layer (for modifiers)
            (deffakekeys
              to-base (layer-switch base)
            )

            ;; Aliases for all special behaviors
            (defalias
              ;; Tap behavior for modifiers: type key and switch to nomods briefly
              tap (multi
                (layer-switch nomods)
                (on-idle-fakekey to-base tap 20)
              )
              ;; Left hand modifiers
              a (tap-hold-release-keys $tap-time $hold-time (multi a @tap) lmet $left-hand-keys)
              s (tap-hold-release-keys $tap-time $hold-time (multi s @tap) lalt $left-hand-keys)
              d (tap-hold-release-keys $tap-time $hold-time (multi d @tap) lctl $left-hand-keys)
              f (tap-hold-release-keys $tap-time $hold-time (multi f @tap) lsft $left-hand-keys)
              ;; Right hand modifiers
              j (tap-hold-release-keys $tap-time $hold-time (multi j @tap) rsft $right-hand-keys)
              k (tap-hold-release-keys $tap-time $hold-time (multi k @tap) rctl $right-hand-keys)
              l (tap-hold-release-keys $tap-time $hold-time (multi l @tap) ralt $right-hand-keys)
              ; (tap-hold-release-keys $tap-time $hold-time (multi ; @tap) rmet $right-hand-keys)
              ;; Layer triggers: tap to type, hold to activate layer
              r (tap-hold $tap-time $hold-time r (layer-while-held numpad))
              u (tap-hold $tap-time $hold-time u (layer-while-held symbols))
              t (tap-hold $tap-time $hold-time t (layer-while-held navigation))
            )
          '';
        };
      };
    };



  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    sops
    nm-tray
    tldr
    google-chrome
    # inputs.claude-desktop.packages.${system}.claude-desktop
    libreoffice
    distrobox
    swww
    eza
    uv
    wget
    git
    kitty
    mpv
    waybar
    yazi
    lutris
    matugen
    jq
    brightnessctl
    pavucontrol
    lm_sensors
    rofi-wayland
    qutebrowser
    zoxide
    swaynotificationcenter
    cliphist
    hyprlock
    pamixer
    zsh-powerlevel10k
    ripgrep
    playerctl
    btop
    pyprland
    firefox
    code-cursor
    # inputs.helix.packages."${pkgs.system}".helix
    # inputs.xremap.packages."${pkgs.system}".xremap
    wl-clipboard
    zsh
  ];
  fonts.packages = with pkgs; [
    nerd-fonts.droid-sans-mono
    noto-fonts
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ 22 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  security.rtkit.enable = true;
  users.defaultUserShell = pkgs.zsh;
  systemd.user.services.ssh-add-github = {
    description = "Add GitHub SSH key to ssh-agent";
    wantedBy = [ "default.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.openssh}/bin/ssh-add /home/undead/.ssh/id_ed25519";
      RemainAfterExit = true;
    };
  };
  system.activationScripts.generateGitHubPubKey = {
    text = ''
          #!/bin/sh
          # Ensure the .ssh directory exists for the user “undead”
          mkdir -p /home/undead/.ssh

          # If the public key is not already present, generate it
          if [ ! -f /home/undead/.ssh/id_ed25519.pub ]; then
            echo "Generating public key from decrypted private key..."
      ${pkgs.openssh}/bin/ssh-keygen -y -f /home/undead/.ssh/id_ed25519 > /home/undead/.ssh/id_ed25519.pub

            # Replace the default comment (e.g., root@hostname) with the desired email

            # Set correct ownership and permissions (assuming the primary group for "undead" is "users")
            chown undead:users /home/undead/.ssh/id_ed25519.pub
            chmod 644 /home/undead/.ssh/id_ed25519.pub
      ${pkgs.gnused}/bin/sed -i 's/ [^ ]*$/ priyanshu.pansari@gmail.com/' /home/undead/.ssh/id_ed25519.pub

          fi
    '';
  };
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}
