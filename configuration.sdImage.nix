{ config, pkgs, lib, modulesPath, ... }:
{

  imports = [
    (modulesPath + "/installer/sd-card/sd-image-aarch64-installer.nix")

    # For nixpkgs cache
    # (modulesPath + "/installer/cd-dvd/channel.nix")

    # (modulesPath + "/profiles/base.nix")
    # (modulesPath + "/installer/sd-card/sd-image.nix")
  ];

  sdImage.compressImage = true;


  # NixOS wants to enable GRUB by default
  boot.loader.grub.enable = false;
  # Enables the generation of /boot/extlinux/extlinux.conf
  boot.loader.generic-extlinux-compatible.enable = true;

  # !!! Set to specific linux kernel version
  boot.kernelPackages = pkgs.linuxPackages_5_4;

  # !!! Needed for the virtual console to work on the RPi 3, as the default of 16M doesn't seem to be enough.
  # If X.org behaves weirdly (I only saw the cursor) then try increasing this to 256M.
  # On a Raspberry Pi 4 with 4 GB, you should either disable this parameter or increase to at least 64M if you want the USB ports to work.
  boot.kernelParams = [ "cma=256M" ];

  # Settings above are the bare minimum
  # All settings below are customized depending on your needs

  # systemPackages
  environment.systemPackages = with pkgs; [ vim curl wget ];

  # services.openssh = {
  #   enable = false;
  # };

  networking.firewall.enable = true;

  users.groups = {
    nixos = {
      gid = 1000;
      name = "nixos";
    };
  };
  users.users = {
    nixos = {
      uid = 1000;
      home = "/home/nixos";
      name = "nixos";
      group = "nixos";
      shell = pkgs.zsh;
      extraGroups = [ ];
    };
  };

  users.extraUsers.root.openssh.authorizedKeys.keys = [
    # Your ssh key
  ];
}