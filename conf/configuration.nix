{ config, pkgs, ... }: {

  imports = [ ./gandicloud.nix ];

  services.openssh = {
    enable = true;
    passwordAuthentication = false;
    logLevel = "VERBOSE";
    authorizedKeysFiles = [ "/etc/ssh/authorized_keys" ];
  };

  services.nginx = {
      enable = true;

      virtualHosts = let root = "/var/www"; ip = "46.226.104.150"; in {
        "${ip}" = {
          addSSL = true;
          sslCertificate = "${root}/ssl/certificate.crt";
          sslCertificateKey = "${root}/ssl/private.key";
          root = root;
          listen = [
            { addr = ip; port = 443; ssl = true; }
            { addr = ip; port = 80; }
          ];
          locations."/" = {
              index = "index.html";
          };
        };
    };
  };
  networking.firewall.allowedTCPPorts = [ 80 443 ];
  system.stateVersion = "22.05";

  environment.systemPackages = with pkgs; [
    git
    neovim
    curl
    wget
    podman-compose
  ];

  virtualisation = {
    docker.enable = false;
    podman = {
      enable = true;
      dockerSocket.enable = true;
      defaultNetwork.dnsname.enable = true;
    };
  };

  users.extraUsers.root.extraGroups = ["podman"];

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    trusted-public-keys = [
      "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
    ];
    substituters = [
      "https://cache.iog.io"
    ];
  };
}
