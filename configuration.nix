# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
 #and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  hsPackages = with pkgs.haskellPackages; [
    cabal2nix
    cabalInstall
    ghc
    ghcCore
    hlint
    happy
    alex
    ghcMod
    pandoc
    purescript
    stylishHaskell
    taffybar
    xmobar
    yeganesh
  ];
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the gummiboot efi boot loader.
  boot.kernelPackages = pkgs.linuxPackages_3_17;
  boot.loader.gummiboot.enable = true;
  boot.loader.gummiboot.timeout = 5;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices = [
    { name = "root"; device = "/dev/sda4"; preLVM = true; }];

  #  networking.hostName = "nixos"; # Define your hostname.
#  networking.hostId = "d27401ca";
  # networking.wireless.enable = true;  # Enables wireless.
  boot.cleanTmpDir = true;

  time.timeZone = "Europe/London";

  fonts.enableCoreFonts = true;

  nix.binaryCaches = [ http://cache.nixos.org http://hydra.nixos.org ];

  # Select internationalisation properties.
  #  i18n = {
  #    consoleFont = "lat9w-16";
  #    consoleKeyMap = "us";
  #    defaultLocale = "en_UK.UTF-8";
   # };

   # services.hardware.pommed.enable = true;
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
   environment.systemPackages = with pkgs; [
     terminator
     tmux
     s3cmd
     wget
     gnupg
     emacs
     gitFull
     acpi
     bind
     binutils
     chromium
     firefoxWrapper
     libreoffice
     dmenu
     emacs
     ansible
     cifs_utils
     xfce.thunar
     evince
     pidgin
     transmission
     transmission_gtk
     gitFull
     (haskellPackages.hoogleLocal.override {
      packages = hsPackages;
      })
      keepassx
      vlc
      openconnect
      jdk
      sbt
      nodejs
      nodePackages.npm
#      tigervnc
      linuxPackages.virtualbox
      vagrant
      xdg_utils
      xlibs.xev
      xlibs.xset
      thunderbird
      xscreensaver
      xlibs.xmodmap
      gnome3.gnome-calculator
  ] ++ hsPackages;


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
    windowManager.xmonad.extraPackages = haskellPackages: [
      haskellPackages.taffybar
    ];

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


  nixpkgs.config = {
    allowUnfree = true;
    firefox = {
     enableGoogleTalkPlugin = true;
     enableAdobeFlash = true;
    };

    chromium = {
      enablePepperFlash = true;
      enablePepperPDF = true;
    };
  };

#  users.mutableUsers = true;

  users.extraUsers.wfaler = {
    name = "wfaler";
    group = "users";
    uid = 1000;
    extraGroups = [ "wheel" "vboxusers" ];
    createHome = true;
    home = "/home/wfaler";
    shell = "/run/current-system/sw/bin/bash";
  };

  users.extraGroups.docker.members = ["wfaler"];
 # networking.firewall.allowedTCPPorts = [ 80 443 5900];
  networking.hostName = "wfaler-nixos";
  networking.wireless.enable = true;
  hardware.bluetooth.enable = true;
  #services.hardware.pommed.enable = true;
  services.upower.enable = true;

  services.nixosManual.showManual = true;
  services.virtualboxHost.enable = true;
  services.openssh.enable = true;
  virtualisation.docker.enable =true;

  programs.ssh.agentTimeout = "12h";

  # List services that you want to enable:

  # Enable CUPS to print documents.
  # services.printing.enable = true;

}
