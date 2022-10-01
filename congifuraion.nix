{ config, pkgs, ... }: {

  imports = [ ./gandicloud.nix ];

  services.openssh = {
    enable = true;
    passwordAuthentication = false;
  };

  services.nginx = let root = "/var/calendar"; ip = "46.226.104.150"; in {
    enable = true;

    virtualHosts = {
      "${ip}" = {
          addSSL = true;
          sslCertificate = "${root}/ssl/certificate.crt";
          sslCertificateKey = "${root}/ssl/private.key";
          root = root;
          listen = [
            { addr = ip; port = 80; }
            { addr = ip; port = 443; ssl = true; }
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
    neovim
    curl
    wget
  ];
}
