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

  boot.kernelPackages = pkgs.linuxPackages_3_17;
  boot.loader.gummiboot.enable = true;
  boot.loader.gummiboot.timeout = 5;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.cleanTmpDir = true;

  time.timeZone = "Europe/London";

  fonts.enableCoreFonts = true;

  nix.binaryCaches = [ http://cache.nixos.org http://hydra.nixos.org ];

  environment.systemPackages = with pkgs; [
    acpi
    bind
    binutils
    chromium
    firefox
    dmenu
    emacs
    evince
    gitFull
    (haskellPackages.hoogleLocal.override {
      packages = hsPackages;
    })
    keepassx
    vlc
    openconnect
    oraclejdk8
    sbt
    vagrant
    wpa_supplicant_gui
    xdg_utils
    xlibs.xev
    xlibs.xset
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
      Option "metamodes" "HDMI-0: nvidia-auto-select +0+0, DP-2: nvidia-auto-select +1920+0 {viewportin=1680x1050}"
    '';

    xkbOptions = "terminate:ctrl_alt_bksp, ctrl:nocaps";
  };

  nixpkgs.config = {
    allowUnfree = true;
    chromium.enablePepperFlash = true;
    chromium.enablePepperPDF = true;

    packageOverrides = pkgs: {
      jre = pkgs.oraclejre8;
      jdk = pkgs.oraclejdk8;
      linux_3_17 = pkgs.linux_3_17.override {
        extraConfig =
        ''
          THUNDERBOLT m
        '';
      };
    };
  };

#  users.mutableUsers = true;

  users.extraUsers.wfaler = {
    name = "wfaler";
    group = "users";
    uid = 1000;
    extraGroups = [ "wheel" ];
    createHome = true;
    home = "/home/wfaler";
    shell = "/run/current-system/sw/bin/bash";
  };

#  users.extraGroups.docker.members = [ "wfaler" ];

  # Should I use this instead? Both are currently broken.
  # networking.networkmanager.enable = true;
  # networking.connman.enable = true;

  # Sadly wicd worked less than wpa_supplicant
  # networking.interfaceMonitor.enable = false;
  # networking.useDHCP = false;
  # networking.wicd.enable = true;

  networking.hostName = "wfaler-nixos";
  networking.wireless.enable = true;
  hardware.bluetooth.enable = true;

  services.upower.enable = true;

  services.nixosManual.showManual = true;

  services.openssh.enable = true;
  programs.ssh.agentTimeout = "12h";

#  virtualisation.docker.enable = true;

}
