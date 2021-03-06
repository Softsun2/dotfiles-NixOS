{ config, pkgs, ... }:

{

  nix.package = pkgs.nixFlakes;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowBroken = true;

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "buffalo"; # Define your hostname.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp30s0.useDHCP = true;
  networking.interfaces.wlp33s0f3u1.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  services.xserver.videoDrivers = [ "nvidia" ];
  # monitor options, derived from the nvidia-settings tool
  services.xserver.screenSection = ''
    Option         "metamodes" "DP-0: 1920x1080_144 +1920+0 {ForceCompositionPipeline=On, ForceFullCompositionPipeline=On}, DVI-D-0: 1920x1080_60 +0+0 {ForceCompositionPipeline=On, ForceFullCompositionPipeline=On}"
  '';

  services.xserver.displayManager.startx.enable = true;
  services.xserver.windowManager.dwm.enable = true;

  # FIXME: After I am satisfied with a working version of dwm
  # make this overlay a flake input
  nixpkgs.overlays = [
    (final: prev: {
      dwm = prev.dwm.overrideAttrs (old: { src = /home/softsun2/suckless/dwm; });
    })
  ];

  # Configure keymap in X11
  services.xserver.layout = "us";
  services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ???passwd???.
  users.users.softsun2 = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" ]; # Enable ???sudo??? for the user.
    shell = pkgs.zsh;
  };

  fonts.fonts = with pkgs; [
    jetbrains-mono
    roboto
    meslo-lg
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];

  # goofy steam support
  programs.steam.enable = true;

  # docker daemon
  virtualisation.docker.enable = true;

  environment.pathsToLink = [ "/share/zsh" ];

  # List packages installed in system profile. To search, run:
  environment.systemPackages = with pkgs; [

    # Desktop 
    dwm      # window manager
    kitty    # terminal emulator
    dmenu    # dynamic menu and program launcher
    feh      # image viewer

    # Apps
    firefox
    discord
    steam

    # util
    pulsemixer
    shellcheck
    neovim   # text editor
    zsh      # z shell
    git
    wget
    tree
    exa      # better ls
    fzf      # fuzzy finder
    docker

    # lsps, not sure if I want to install these per env or globally yet
    sumneko-lua-language-server

    # nix
    nix-prefetch-git
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
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It???s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).

  system.stateVersion = "21.11"; # Did you read the comment?

}

