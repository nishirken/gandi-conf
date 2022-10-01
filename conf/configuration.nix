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
      neovim
      curl
      wget
  ];
}
