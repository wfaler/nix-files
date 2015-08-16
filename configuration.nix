# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the gummiboot efi boot loader.
  boot.loader.gummiboot.enable = true;
  boot.loader.gummiboot.timeout = 5;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices = [{name = "root"; device = "/dev/sda2"; preLVM = true;}];

  # networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Select internationalisation properties.
  # i18n = {
  #   consoleFont = "Lat2-Terminus16";
  #   consoleKeyMap = "us";
  #   defaultLocale = "en_US.UTF-8";
  # };

  # Set your time zone.
  # time.timeZone = "Europe/Amsterdam";

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
   environment.systemPackages = with pkgs; [
     gitFull
     jdk
     sbt
     nox
     clementine
     hexchat
     darktable
     unzip
     wget
     p7zip
     emacs
     terminator
     tmux
     spotify
     gnupg
     acpi
     bind
     binutils
     firefoxWrapper
     dmenu
     cifs_utils
     pidgin
     transmission
     transmission_gtk
     keepassx
     vlc
     xdg_utils
     xlibs.xev
     xlibs.xset
     thunderbird
     xscreensaver
     xlibs.xmodmap
     gnome3.gnome-calculator
     linuxPackages.virtualbox
     vagrant
     pkgs.haskellPackages.cabal2nix
     pkgs.haskellPackages.xmobar
     pkgs.haskellPackages.xmonad-contrib
     pkgs.haskellPackages.xmonad-extras
     ranger
     vim
     evince
     chromium
     libreoffice
     openvpn
     nixops
     xclip
     ansible
     file
     cpufrequtils
   ];


  programs.light.enable = true;



  services.xserver = {
    enable = true;
    
    vaapiDrivers = [ pkgs.vaapiIntel ];

    desktopManager.default = "none";
    desktopManager.xterm.enable = false;
    displayManager = {
      desktopManagerHandlesLidAndPower = false;
      lightdm.enable = true;
      sessionCommands = ''
        ${pkgs.xlibs.xsetroot}/bin/xsetroot -cursor_name left_ptr
      '';
    };
    windowManager.default = "xmonad";
    windowManager.xmonad.enable = true;
    windowManager.xmonad.enableContribAndExtras = true;
#    windowManager.xmonad.extraPackages = haskellPackages: [
#      haskellPackages.taffybar
#    ];

    # TODO: Use the mtrack driver but do better than this.
    # multitouch.enable = true;
    # multitouch.invertScroll = true;

    synaptics.additionalOptions = ''
      Option "VertScrollDelta" "-100"
      Option "HorizScrollDelta" "-100"
    '';
    synaptics.buttonsMap = [ 1 3 2 ];
    synaptics.enable = true;
    synaptics.tapButtons = false;
    synaptics.fingersMap = [ 0 0 0 ];
    synaptics.twoFingerScroll = true;
    synaptics.vertEdgeScroll = false;

    videoDrivers = [ "nvidia" ];

    screenSection = ''
      Option "DPI" "96 x 96"
      Option "NoLogo" "TRUE"
      Option "nvidiaXineramaInfoOrder" "DFP-2"
 #     Option "metamodes" "HDMI-0: nvidia-auto-select +0+0, DP-2: nvidia-auto-select +1920+0 {viewportin=1680x1050}"
    '';

    xkbOptions = "terminate:ctrl_alt_bksp, ctrl:nocaps";
  };


  users.extraUsers.wfaler = {
    name = "wfaler";
    group = "users";
    uid = 1000;
    extraGroups = [ "wheel" "vboxusers" ];
    createHome = true;
    home = "/home/wfaler";
    shell = "/run/current-system/sw/bin/bash";
  };
  security.sudo.enable = true;

  nixpkgs.config = {
    allowUnfree = true;
    firefox = {

    };

    chromium = {
     enablePepperFlash = true; # Chromium's non-NSAPI alternative to Adobe Flash
     enablePepperPDF = true;
     # enableWidevine = true;
    };

  };
  users.extraGroups.docker.members = ["wfaler"];
  networking.firewall.allowedTCPPorts = [ 22 80 443 5900];
  networking.hostName = "wfaler-nixos";
  networking.wireless.enable = true;
  hardware.bluetooth.enable = true;
  #services.hardware.pommed.enable = true;
  services.upower.enable = true;
  services.nginx.enable = true;
  services.nginx.user = "wfaler";
  services.nginx.config = pkgs.lib.readFile /etc/nginx/nginx.conf;
  services.nixosManual.showManual = true;
  services.virtualboxHost.enable = true;
  services.openssh.enable = true;
  services.tlp.enable = true;

  services.postgresql.enable = true;
  services.postgresql.package = pkgs.postgresql94;
  services.postgresql.dataDir = "/data/postgresql";

  virtualisation.docker.enable =true;

  programs.ssh.agentTimeout = "12h";

  # List services that you want to enable:

  # Enable CUPS to print documents.
  services.printing = {
      enable = true;
      drivers = [ pkgs.hplipWithPlugin ];
  };

  systemd.services."my-pre-suspend" = 
  {   description = "Pre-Suspend Actions";
      wantedBy = [ "suspend.target" ];
      before = [ "systemd-suspend.service" ];
      script = ''
	# sync filesystems if suspend fails
	/run/current-system/sw/bin/sync 
	# lock screen
	/run/current-system/sw/bin/xscreensaver-command -lock 
	sleep 3
      '';

      serviceConfig.Type = "simple";
  };

}