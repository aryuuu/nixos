# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager = {
    enable = true;
    connectionConfig = {
      "ipv6.ip6-privacy" = 2;
      "ipv6.method" = "disabled";
    };
    wifi.powersave = false;
  };
  networking.extraHosts = 
    ''
      127.0.0.1 localhost
      ::1 localhost
      127.0.0.2 nixos
      192.53.117.45 linode-aryuuu
    '' + ''

    ''+ (builtins.readFile ../my-hosts);

  # Set your time zone.
  time.timeZone = "Asia/Jakarta";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.blueman.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.windowManager.i3 = {
    enable = true;
    package = pkgs.i3-gaps;
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # gaming configs
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  services.xserver.videoDrivers = ["amdgpu"];

  # Enable CUPS to print documents.
  services.printing.enable = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)

    #media-session.enable = true;
  };

  virtualisation.docker = {
    enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;
  users.users.openvpn = {
    isSystemUser = pkgs.lib.mkForce true;
    description = "OpenVPN User";

    group = "openvpn";
  };
  users.groups.openvpn = {};
  services.dbus.packages = [ pkgs.openvpn3 ];
  systemd.tmpfiles.rules = [
    "d /etc/openvpn3/configs 0755 root root -"
  ];

  fonts.packages = with pkgs; [
    fira-code
    jetbrains-mono
    nerd-fonts.jetbrains-mono
    d2coding
    font-awesome
  ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.fatt = {
    isNormalUser = true;
    description = "fatt";
    extraGroups = [ "networkmanager" "wheel" "docker" "video" "wireshark" ];
    packages = with pkgs; [
      alacritty
      fzf
      slack
      postman
      go
      zig
      nodejs
      bun
      brave
      (pass-wayland.withExtensions (ext: [ 
        ext.pass-otp 
        ext.pass-update
        ext.pass-file
      ]))
      kubectl
      k9s
      terraform
      delta
      telegram-desktop
      dbeaver-bin
      mongodb-compass
      robo3t
      btop
      fastfetch
      zed-editor
      discord
      jq
      yq
      ripgrep
      nerd-fonts.droid-sans-mono
      nerd-fonts.jetbrains-mono
      jetbrains-mono
      font-awesome
      waybar
      swaybg
      swaylock-fancy
      rofi-wayland
      networkmanager_dmenu
      dmenu-wayland
      dunst
      libnotify
      zathura
      sioyek
      cliphist
      wl-clipboard
      file
      bluez
      wf-recorder
      wl-kbptr
      gimp
      ffmpeg
      blender
      lorien
      drawing
      grim
      slurp
      swappy
      tesseract
      python3
      cargo
      ranger
      ueberzug
      lf
      aws-vault
      chamber
      bat
      pulseaudio
      pavucontrol
      awscli2
      extract_url
      mpv
      feh
      tealdeer
      redli
      wireshark
      termshark
      nmap
      binwalk
      jujutsu
      docker-compose
    ];

    shell = pkgs.fish;
  };
  programs.fish.enable = true;

  # Install firefox.
  programs.firefox.enable = true;
  programs.steam = {
     enable = true;
  };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  programs.direnv.enable = true;
  programs.wireshark.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    wget
    # neovim
    git
    stow
    tmux
    gnupg
    gnumake
    d2coding
    gcc
    unzip
    ponymix
    openvpn3
    psmisc
    brightnessctl
    libsForQt5.bismuth
  ];

  environment.sessionVariables = {
     EDITOR = "nvim";
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}
