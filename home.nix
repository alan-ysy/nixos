{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "arlan";
  home.homeDirectory = "/home/arlan";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.11"; # Please read the comment before changing.
  
  nixpkgs.config.allowUnfree = true;
  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')

    # Core
    brightnessctl
    pamixer
    btop
    hyprpaper
    fastfetch
    libnotify # Needed for dunst
    jdk21

    # My packages
    comma # This was some really cool thing Linux Club showed
    imagemagick
    feh # Thanks Corbin Covault
    gimp2
    vesktop
    hyprshot
    # distrobox
    # fzf
    # yazi
    # zoxide
    # wireshark
    jetbrains.idea
    openssl
    obsidian

    inkscape
    unzip
    xfce.thunar
    
    # Fonts
    noto-fonts

    steam
    steam-run

    ida-free
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/arlan/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  programs.bash = {
    enable = true;
    shellAliases = {
      ls = "ls --color=auto"; # Restore color to ls
      ll = "ls -l";
      la = "ls -a";
      ".." = "cd ..";
      arlan-rebuild-nixos = "sudo nixos-rebuild switch --flake ~/.my-nixos#nixos";
      arlan-rebuild-home = "home-manager switch --flake ~/.my-nixos#arlan";
    };

    # Add my own shell prompt
    bashrcExtra = ''
      PS1='[\[\e[94m\]\u\[\e[0m\]@\[\e[94m\]\h\[\e[0m\]:\[\e[94m\]\w\[\e[0m\]]\\$ '
    '';
  };

  # Restore color to ls
  #programs.dircolors = {
  #  enable = true;
  #  enableBashIntegration = true;
  #};

  # Cursor setup
  home.pointerCursor = {
    name = "Adwaita";
    package = pkgs.adwaita-icon-theme;
    size = 24;
  };


  # Hyprland configuration
  wayland.windowManager.hyprland = {
    enable = true;
    
    # Just in case?
    xwayland.enable = true;

    settings = {
      monitor = "eDP-1, preferred, auto, 1"; # name, res, pos, scale

      "$mainMod" = "SUPER";
      bind = [
        "$mainMod, RETURN, exec, kitty"
        "$mainMod, T, exec, kitty"
        "$mainMod, C, killactive"
        "$mainMod, V, togglefloating"
        "$mainMod, F, exec, firefox"
        "$mainMod, P, exec, firefox --private-window"
        "$mainMod, Print, exec, hyprshot -m region -o ~/Pictures/Screenshots"

        "$mainMod, X, exec, dunstify --raw_icon=\"/home/arlan/Pictures/Shuai_Xu.jpg\" \"Hi I'm Dr. Xu\""

        # tofi needs to be piped to properly run I think:
        "$mainMod, SPACE, exec, tofi-run | xargs hyprctl dispatch exec --"

        # Workspace bindings
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"

        # Brightness
        ", XF86MonBrightnessUp, exec, brightnessctl set +10%"
        ", XF86MonBrightnessDown, exec, brightnessctl set 10%-"

        # Volume
        ", XF86AudioRaiseVolume, exec, pamixer --increase 5"
        ", XF86AudioLowerVolume, exec, pamixer --decrease 5"
        ", XF86AudioMute, exec, pamixer --toggle-mute"
      ];

      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      general = {
        gaps_in = 3;
        gaps_out = 1;
      };

      decoration = {
        rounding = 5;
      };

      animations = {
        enabled = true;
      };

      xwayland = {
        force_zero_scaling = true; # Fix VSCode pixelization
      };

      # Launch these on startup
      exec-once = [
        "waybar"
        "hyprpaper"
      ];
    };
  };

  # Kitty configuration
  programs.kitty = {
    enable = true;

    settings = {
      # Set TERM variable to this to make ssh cooperate
      term = "xterm-256color";

      # Font
      font_family = "Iosevka Nerd Font Mono";
      font_size = 14;

      # Windows
      window_margin_width = 5;

      # Background
      background_opacity = 0.9;
      background_blur = 2;

      # Cursor
      cursor_trail = 10;
      cursor_trail_start_threshold = 0;
      shell_integration = "no-cursor";
      cursor_trail_decay = "0.01 0.15";
      cursor_shape = "block";
      cursor_blink = "true";

      # Color theme
      # Taken from moonfly
      background = "#080808";
      foreground = "#bdbdbd";
      cursor = "#9e9e9e";
      url_color = "#79dac8";

      color0 = "#323437";
      color1 = "#ff5d5d";
      color2 = "#8cc85f";
      color3 = "#e3c78a";
      color4 = "#80a0ff";
      color5 = "#cf87e8";
      color6 = "#79dac8";
      color7 = "#c6c6c6";
      color8 = "#949494";
      color9 = "#ff5189";
      color10 = "#36c692";
      color11 = "#c6c684";
      color12 = "#74b2ff";
      color13 = "#ae81ff";
      color14 = "#85dc85";
      color15 = "#e4e4e4";

      selection_background = "#b2ceee";
      selection_foreground = "#080808";

      active_tab_foreground = "#080808";
      active_tab_background = "#80a0ff";

      inactive_tab_foreground = "#b2b2b2";
      inactive_tab_background = "#323437";

      active_border_color = "#80a0ff";
      inactive_border_color = "#323437";
    };
  };

  # Waybar configuration
  programs.waybar = {
    enable = true;

    settings = {
      mainBar = {
        layer = "top";
        position = "top";

        modules-left = [ "hyprland/workspaces" ];
        modules-center = [ "clock" ];
        modules-right = [
          "pulseaudio"
          "custom/bar"
          "backlight"
          "custom/bar"
          "network"
          "custom/bar"
          "battery"
        ];

        "hyprland/workspaces" = {
          format = "{name}";
          all-outputs = true;
          on-click = "hyprctl dispatch workspace {name}";
        };

        # Backlight (brightness)
        backlight = {
          device = "intel_backlight"; # or check yours with: ls /sys/class/backlight
          format = "BRT: {percent}%";
          # format-icons = [""];
        };

        # Volume (pulseaudio/pipewire)
        pulseaudio = {
          format = "VOL: {volume}%";
          format-muted = "VOL: MUT";
          scroll-step = 5;
        };

        clock = {
          format = "{:%Y-%m-%d | %H:%M}";
        };

        network = {
          format = "NET: {essid}";
          format-disconnected = "NET: N/A";
          tooltip = false;
        };

        battery = {
          format = "BAT: {capacity}%";
          format-charging = "BAT: {capacity}% (CHRG)";
          format-plugged = "BAT: {capacity}% (PLUG)";
          tooltip = false;
        };

        # Literally just a vertical bar for separation
        "custom/bar" = {
          format = "|";
        };
      };
    };

    style = ''
      * {
        font-family: "Iosevka Nerd Font Mono", monospace;
        font-size: 14px;
        padding: 0;
        margin: 0;
        color: #bdbdbd;
      }

      window#waybar {
        background: #080808;
        min-height: 20px;
      }

      #workspaces {
        padding-left: 2px;
      }

      #workspaces button {
        color: #bdbdbd;
        min-width: 18px;
        min-height: 18px;
        padding: 0;
        margin: 0;
        border-radius: 0;
        background: transparent;
      }

      #workspaces button.active,
      #workspaces button.active label {
        background: #bdbdbd;
        color: #080808;     /* need "label" to correctly target text */
      }

      #backlight,
      #pulseaudio,
      #clock,
      #battery,
      #network {
        padding: 0 5px;
      }

      /* Brightness */
      #backlight {
        color: #bdbdbd;
      }

      /* Volume */
      #pulseaudio {
        color: #bdbdbd;
      }

      #pulseaudio.muted {
        color: #888;
      }

      #network.disconnected {
        color: #bdbdbd;
      }
    '';
  };

  # tofi configuration
  programs.tofi = {
    enable = true;

    settings = {
      # Appearance
      font = "Iosevka Nerd Font Mono 12";
      background = "#080808";
      text-color = "#bdbdbd";
      prompt-text = "run: ";

      # Layout & behavior
      width = "50%";
      height = "200px";
      border-width = "2px";
      border-color = "#bdbdbd";

      # Style for matching
      selection-color = "#080808";
      selection-background = "#bdbdbd";
    };
  };

  # hyprpaper configuration
  # Set up config file to load wallpaper
  home.file.".config/hypr/hyprpaper.conf".text = ''
    preload = ~/Pictures/Wallpapers/thought_cabinet_bw.png
    wallpaper = eDP-1, ~/Pictures/Wallpapers/thought_cabinet_bw.png
  '';
  # wallhaven-73ol39_dithered.png - whirling in rags
  # wallhaven-831dk2_dithered.png - thought cabinet
  # wallhaven-ey1e9k_dithered.png - church
  # wallhaven-l82kpr_ditheredUpscale.jpg -zelda
  # thought_cabinet_bw.png - Disco Elysium thought cabinet black/white

  # dunst configuration
  # Needs the libnotify package to work
  services.dunst = {
    enable = true;
    settings = {
      global = {
        follow = "keyboard";

        mouse_right_click = "do_action, close_current";

        # Looks
        font = "Iosevka Nerd Font Mono";
        background = "#080808";
        foreground = "#bdbdbd";
        frame_width = 1;
        frame_color = "#80a0ff";
        highlight = "#80a0ff";
        corner_radius = 3;

        origin = "top-right";
        offset = "(10,10)";

        min_icon_size = 200;
      };
    };
    waylandDisplay = "wayland-1";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
