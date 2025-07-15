# Auto-generated using compose2nix v0.3.2-pre.

{ pkgs, lib, ... }:

{
  # Runtime
  virtualisation.docker = {
    enable = true;
    autoPrune.enable = true;
  };
  virtualisation.oci-containers.backend = "docker";

  # Containers
  virtualisation.oci-containers.containers."admin" = {
    image = "compose2nix/admin";
    dependsOn = [ "api" "web" ];
    log-driver = "journald";
    extraOptions = [ "--network-alias=admin" "--network=plane_default" ];
  };
  systemd.services."docker-admin" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
    after = [ "docker-network-plane_default.service" ];
    requires = [ "docker-network-plane_default.service" ];
    partOf = [ "docker-compose-plane-root.target" ];
    wantedBy = [ "docker-compose-plane-root.target" ];
  };
  virtualisation.oci-containers.containers."api" = {
    image = "compose2nix/api";
    cmd = [ "./bin/docker-entrypoint-api.sh" ];
    dependsOn = [ "plane-db" "plane-redis" ];
    log-driver = "journald";
    extraOptions = [ "--network-alias=api" "--network=plane_default" ];
  };
  systemd.services."docker-api" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
    after = [ "docker-network-plane_default.service" ];
    requires = [ "docker-network-plane_default.service" ];
    partOf = [ "docker-compose-plane-root.target" ];
    wantedBy = [ "docker-compose-plane-root.target" ];
  };
  virtualisation.oci-containers.containers."beatworker" = {
    image = "compose2nix/beatworker";
    cmd = [ "./bin/docker-entrypoint-beat.sh" ];
    dependsOn = [ "api" "plane-db" "plane-redis" ];
    log-driver = "journald";
    extraOptions = [ "--network-alias=beat-worker" "--network=plane_default" ];
  };
  systemd.services."docker-beatworker" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
    after = [ "docker-network-plane_default.service" ];
    requires = [ "docker-network-plane_default.service" ];
    partOf = [ "docker-compose-plane-root.target" ];
    wantedBy = [ "docker-compose-plane-root.target" ];
  };
  virtualisation.oci-containers.containers."bgworker" = {
    image = "compose2nix/bgworker";
    cmd = [ "./bin/docker-entrypoint-worker.sh" ];
    dependsOn = [ "api" "plane-db" "plane-redis" ];
    log-driver = "journald";
    extraOptions = [ "--network-alias=worker" "--network=plane_default" ];
  };
  systemd.services."docker-bgworker" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
    after = [ "docker-network-plane_default.service" ];
    requires = [ "docker-network-plane_default.service" ];
    partOf = [ "docker-compose-plane-root.target" ];
    wantedBy = [ "docker-compose-plane-root.target" ];
  };
  virtualisation.oci-containers.containers."plane-db" = {
    image = "postgres:15.7-alpine";
    environment = {
      "PGDATA" = "/var/lib/postgresql/data";
      "POSTGRES_DB" = "";
      "POSTGRES_PASSWORD" = "";
      "POSTGRES_USER" = "";
    };
    volumes = [ "plane_pgdata:/var/lib/postgresql/data:rw" ];
    cmd = [ "postgres" "-c" "max_connections=1000" ];
    log-driver = "journald";
    extraOptions = [ "--network-alias=plane-db" "--network=plane_default" ];
  };
  systemd.services."docker-plane-db" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
    after = [
      "docker-network-plane_default.service"
      "docker-volume-plane_pgdata.service"
    ];
    requires = [
      "docker-network-plane_default.service"
      "docker-volume-plane_pgdata.service"
    ];
    partOf = [ "docker-compose-plane-root.target" ];
    wantedBy = [ "docker-compose-plane-root.target" ];
  };
  virtualisation.oci-containers.containers."plane-live" = {
    image = "compose2nix/plane-live";
    log-driver = "journald";
    extraOptions = [ "--network-alias=live" "--network=plane_default" ];
  };
  systemd.services."docker-plane-live" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
    after = [ "docker-network-plane_default.service" ];
    requires = [ "docker-network-plane_default.service" ];
    partOf = [ "docker-compose-plane-root.target" ];
    wantedBy = [ "docker-compose-plane-root.target" ];
  };
  virtualisation.oci-containers.containers."plane-migrator" = {
    image = "compose2nix/plane-migrator";
    cmd = [ "./bin/docker-entrypoint-migrator.sh" ];
    dependsOn = [ "plane-db" "plane-redis" ];
    log-driver = "journald";
    extraOptions = [ "--network-alias=migrator" "--network=plane_default" ];
  };
  systemd.services."docker-plane-migrator" = {
    serviceConfig = { Restart = lib.mkOverride 90 "no"; };
    after = [ "docker-network-plane_default.service" ];
    requires = [ "docker-network-plane_default.service" ];
    partOf = [ "docker-compose-plane-root.target" ];
    wantedBy = [ "docker-compose-plane-root.target" ];
  };
  virtualisation.oci-containers.containers."plane-minio" = {
    image = "minio/minio";
    environment = {
      "MINIO_ROOT_PASSWORD" = "";
      "MINIO_ROOT_USER" = "";
    };
    volumes = [ "plane_uploads:/export:rw" ];
    cmd = [ "server" "/export" "--console-address" ":9090" ];
    log-driver = "journald";
    extraOptions = [ "--network-alias=plane-minio" "--network=plane_default" ];
  };
  systemd.services."docker-plane-minio" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
    after = [
      "docker-network-plane_default.service"
      "docker-volume-plane_uploads.service"
    ];
    requires = [
      "docker-network-plane_default.service"
      "docker-volume-plane_uploads.service"
    ];
    partOf = [ "docker-compose-plane-root.target" ];
    wantedBy = [ "docker-compose-plane-root.target" ];
  };
  virtualisation.oci-containers.containers."plane-mq" = {
    image = "rabbitmq:3.13.6-management-alpine";
    environment = {
      "RABBITMQ_DEFAULT_PASS" = "";
      "RABBITMQ_DEFAULT_USER" = "";
      "RABBITMQ_DEFAULT_VHOST" = "";
    };
    volumes = [ "plane_rabbitmq_data:/var/lib/rabbitmq:rw" ];
    log-driver = "journald";
    extraOptions = [ "--network-alias=plane-mq" "--network=plane_default" ];
  };
  systemd.services."docker-plane-mq" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
    after = [
      "docker-network-plane_default.service"
      "docker-volume-plane_rabbitmq_data.service"
    ];
    requires = [
      "docker-network-plane_default.service"
      "docker-volume-plane_rabbitmq_data.service"
    ];
    partOf = [ "docker-compose-plane-root.target" ];
    wantedBy = [ "docker-compose-plane-root.target" ];
  };
  virtualisation.oci-containers.containers."plane-redis" = {
    image = "valkey/valkey:7.2.5-alpine";
    volumes = [ "plane_redisdata:/data:rw" ];
    log-driver = "journald";
    extraOptions = [ "--network-alias=plane-redis" "--network=plane_default" ];
  };
  systemd.services."docker-plane-redis" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
    after = [
      "docker-network-plane_default.service"
      "docker-volume-plane_redisdata.service"
    ];
    requires = [
      "docker-network-plane_default.service"
      "docker-volume-plane_redisdata.service"
    ];
    partOf = [ "docker-compose-plane-root.target" ];
    wantedBy = [ "docker-compose-plane-root.target" ];
  };
  virtualisation.oci-containers.containers."proxy" = {
    image = "compose2nix/proxy";
    environment = {
      "BUCKET_NAME" = "uploads";
      "FILE_SIZE_LIMIT" = "5242880";
    };
    ports = [ "80/tcp" "443/tcp" ];
    dependsOn = [ "admin" "api" "space" "web" ];
    log-driver = "journald";
    extraOptions = [ "--network-alias=proxy" "--network=plane_default" ];
  };
  systemd.services."docker-proxy" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
    after = [ "docker-network-plane_default.service" ];
    requires = [ "docker-network-plane_default.service" ];
    partOf = [ "docker-compose-plane-root.target" ];
    wantedBy = [ "docker-compose-plane-root.target" ];
  };
  virtualisation.oci-containers.containers."space" = {
    image = "compose2nix/space";
    dependsOn = [ "api" "web" ];
    log-driver = "journald";
    extraOptions = [ "--network-alias=space" "--network=plane_default" ];
  };
  systemd.services."docker-space" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
    after = [ "docker-network-plane_default.service" ];
    requires = [ "docker-network-plane_default.service" ];
    partOf = [ "docker-compose-plane-root.target" ];
    wantedBy = [ "docker-compose-plane-root.target" ];
  };
  virtualisation.oci-containers.containers."web" = {
    image = "compose2nix/web";
    dependsOn = [ "api" ];
    log-driver = "journald";
    extraOptions = [ "--network-alias=web" "--network=plane_default" ];
  };
  systemd.services."docker-web" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
    after = [ "docker-network-plane_default.service" ];
    requires = [ "docker-network-plane_default.service" ];
    partOf = [ "docker-compose-plane-root.target" ];
    wantedBy = [ "docker-compose-plane-root.target" ];
  };

  # Networks
  systemd.services."docker-network-plane_default" = {
    path = [ pkgs.docker ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStop = "docker network rm -f plane_default";
    };
    script = ''
      docker network inspect plane_default || docker network create plane_default
    '';
    partOf = [ "docker-compose-plane-root.target" ];
    wantedBy = [ "docker-compose-plane-root.target" ];
  };

  # Volumes
  systemd.services."docker-volume-plane_pgdata" = {
    path = [ pkgs.docker ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      docker volume inspect plane_pgdata || docker volume create plane_pgdata
    '';
    partOf = [ "docker-compose-plane-root.target" ];
    wantedBy = [ "docker-compose-plane-root.target" ];
  };
  systemd.services."docker-volume-plane_rabbitmq_data" = {
    path = [ pkgs.docker ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      docker volume inspect plane_rabbitmq_data || docker volume create plane_rabbitmq_data
    '';
    partOf = [ "docker-compose-plane-root.target" ];
    wantedBy = [ "docker-compose-plane-root.target" ];
  };
  systemd.services."docker-volume-plane_redisdata" = {
    path = [ pkgs.docker ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      docker volume inspect plane_redisdata || docker volume create plane_redisdata
    '';
    partOf = [ "docker-compose-plane-root.target" ];
    wantedBy = [ "docker-compose-plane-root.target" ];
  };
  systemd.services."docker-volume-plane_uploads" = {
    path = [ pkgs.docker ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      docker volume inspect plane_uploads || docker volume create plane_uploads
    '';
    partOf = [ "docker-compose-plane-root.target" ];
    wantedBy = [ "docker-compose-plane-root.target" ];
  };

  # Root service
  # When started, this will automatically create all resources and start
  # the containers. When stopped, this will teardown all resources.
  systemd.targets."docker-compose-plane-root" = {
    unitConfig = { Description = "Root target generated by compose2nix."; };
    wantedBy = [ "multi-user.target" ];
  };
}

