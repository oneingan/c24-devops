{
  inputs,
  cell,
}: {
  pkgs,
  config,
  lib,
  ...
}: let
  user = "check24es";
  fqdn = "check24.local";
  dataDir = "${config.users.users.${user}.home}/www";
  version = pkgs.php.version;
  poolName = "php${version}-${user}";
in {
  services.phpfpm.pools.${poolName} = {
    user = user;
    group = "nginx";
    settings = {
      "listen.owner" = config.services.nginx.user;
      "pm" = "dynamic";
      "pm.max_children" = 32;
      "pm.max_requests" = 500;
      "pm.start_servers" = 2;
      "pm.min_spare_servers" = 2;
      "pm.max_spare_servers" = 5;
      "php_admin_value[error_log]" = "stderr";
      "php_admin_flag[log_errors]" = true;
      "catch_workers_output" = true;
    };
    phpEnv."PATH" = lib.makeBinPath [ pkgs.php ];
  };
  
  services.nginx = {
    enable = true;
    virtualHosts.${fqdn} = {
      root = dataDir;
      locations."/".extraConfig = ''
        rewrite ^ /index.php;
      '';
      locations."~ \\.php$".extraConfig = ''
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass unix:${config.services.phpfpm.pools.${poolName}.socket};
        include ${config.services.nginx.package}/conf/fastcgi.conf;
        include ${config.services.nginx.package}/conf/fastcgi_params;
      '';
      extraConfig = ''
        try_files $uri /index.php;
      '';
    };
  };

  networking.firewall.allowedTCPPorts = [ 80 ];

  users.users.${user} = {
    isSystemUser = true;
    createHome = true;
    home = "/home/${user}";
    group  = "nginx";
  };

  systemd.tmpfiles.rules = [
    "d ${dataDir} 0755 ${user} nginx 10d"
    "f ${dataDir}/index.php 0644 ${user} nginx - <?php phpinfo(); ?>"
  ];
}
