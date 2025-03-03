{ config, lib, pkgs, ... }:

let
  defaultUserName = "alice";
in
{
  imports = [
    ./phosh.nix
    ../common-configuration.nix
  ];

  config = {
    users.users."${defaultUserName}" = {
      isNormalUser = true;
      password = "1234";
      extraGroups = [
        "dialout"
        "feedbackd"
        "networkmanager"
        "video"
        "wheel"
      ];
    };

    services.xserver.desktopManager.phosh = {
      user = defaultUserName;
    };
  
    # Ensures any rndis config from stage-1 is not clobbered by NetworkManager
    networking.networkmanager.unmanaged = [ "rndis0" "usb0" ];

    # Setup USB gadget networking in initrd...
    mobile.boot.stage-1.networking.enable = lib.mkDefault true;
    


    services.openssh.enable = true;
    
  };
}
