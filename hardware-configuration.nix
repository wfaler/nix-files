# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, ... }:

{
  imports =
    [ <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    ];

  boot.initrd.availableKernelModules = [ "xhci_hcd" "ahci" "usbhid" "usb_storage" ];
  boot.kernelModules = [ "kvm-intel" "wl" "applesmc"];
  boot.extraModulePackages = [ config.boot.kernelPackages.broadcom_sta
  			       config.boot.kernelPackages.v4l2loopback];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/db50303f-cb50-4aac-bb45-122fc67dfc23";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/67E3-17ED";
      fsType = "vfat";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/aafa4aa2-73bd-4ba4-b814-306f1ac6f676"; }
    ];

  nix.maxJobs = 8;
}
