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
    environment = {
      "ADMIN_BASE_PATH" = "/god-mode";
      "ADMIN_BASE_URL" = "http://localhost:3001";
      "API_KEY_RATE_LIMIT" = "60/minute";
      "APP_BASE_PATH" = "";
      "APP_BASE_URL" = "http://localhost:3000";
      "AWS_ACCESS_KEY_ID" = "access-key";
      "AWS_REGION" = "";
      "AWS_S3_BUCKET_NAME" = "uploads";
      "AWS_S3_ENDPOINT_URL" = "http://localhost:9000";
      "AWS_SECRET_ACCESS_KEY" = "secret-key";
      "CORS_ALLOWED_ORIGINS" =
        "http://localhost:3000,http://localhost:3001,http://localhost:3002,http://localhost:3100";
      "DATABASE_URL" = "postgresql://plane:plane@plane-db:5432/plane";
      "DEBUG" = "0";
      "DOCKERIZED" = "1";
      "FILE_SIZE_LIMIT" = "5242880";
      "GUNICORN_WORKERS" = "2";
      "HARD_DELETE_AFTER_DAYS" = "60";
      "LIVE_BASE_PATH" = "/live";
      "LIVE_BASE_URL" = "http://localhost:3100";
      "LIVE_SERVER_SECRET_KEY" = "secret-key";
      "MINIO_ENDPOINT_SSL" = "0";
      "POSTGRES_DB" = "plane";
      "POSTGRES_HOST" = "plane-db";
      "POSTGRES_PASSWORD" = "plane";
      "POSTGRES_PORT" = "5432";
      "POSTGRES_USER" = "plane";
      "RABBITMQ_HOST" = "plane-mq";
      "RABBITMQ_PASSWORD" = "plane";
      "RABBITMQ_PORT" = "5672";
      "RABBITMQ_USER" = "plane";
      "RABBITMQ_VHOST" = "plane";
      "REDIS_HOST" = "plane-redis";
      "REDIS_PORT" = "6379";
      "REDIS_URL" = "redis://plane-redis:6379/";
      "SECRET_KEY" = "1laga6wg2n1xggukj64us3jf1ubw59p0te5xsxql3ca1o9vawj";
      "SPACE_BASE_PATH" = "/spaces";
      "SPACE_BASE_URL" = "http://localhost:3002";
      "USE_MINIO" = "0";
      "WEB_URL" = "http://localhost:8000";
    };
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
    environment = {
      "ADMIN_BASE_PATH" = "/god-mode";
      "ADMIN_BASE_URL" = "http://localhost:3001";
      "API_KEY_RATE_LIMIT" = "60/minute";
      "APP_BASE_PATH" = "";
      "APP_BASE_URL" = "http://localhost:3000";
      "AWS_ACCESS_KEY_ID" = "access-key";
      "AWS_REGION" = "";
      "AWS_S3_BUCKET_NAME" = "uploads";
      "AWS_S3_ENDPOINT_URL" = "http://localhost:9000";
      "AWS_SECRET_ACCESS_KEY" = "secret-key";
      "CORS_ALLOWED_ORIGINS" =
        "http://localhost:3000,http://localhost:3001,http://localhost:3002,http://localhost:3100";
      "DATABASE_URL" = "postgresql://plane:plane@plane-db:5432/plane";
      "DEBUG" = "0";
      "DOCKERIZED" = "1";
      "FILE_SIZE_LIMIT" = "5242880";
      "GUNICORN_WORKERS" = "2";
      "HARD_DELETE_AFTER_DAYS" = "60";
      "LIVE_BASE_PATH" = "/live";
      "LIVE_BASE_URL" = "http://localhost:3100";
      "LIVE_SERVER_SECRET_KEY" = "secret-key";
      "MINIO_ENDPOINT_SSL" = "0";
      "POSTGRES_DB" = "plane";
      "POSTGRES_HOST" = "plane-db";
      "POSTGRES_PASSWORD" = "plane";
      "POSTGRES_PORT" = "5432";
      "POSTGRES_USER" = "plane";
      "RABBITMQ_HOST" = "plane-mq";
      "RABBITMQ_PASSWORD" = "plane";
      "RABBITMQ_PORT" = "5672";
      "RABBITMQ_USER" = "plane";
      "RABBITMQ_VHOST" = "plane";
      "REDIS_HOST" = "plane-redis";
      "REDIS_PORT" = "6379";
      "REDIS_URL" = "redis://plane-redis:6379/";
      "SECRET_KEY" = "1laga6wg2n1xggukj64us3jf1ubw59p0te5xsxql3ca1o9vawj";
      "SPACE_BASE_PATH" = "/spaces";
      "SPACE_BASE_URL" = "http://localhost:3002";
      "USE_MINIO" = "0";
      "WEB_URL" = "http://localhost:8000";
    };
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
    environment = {
      "ADMIN_BASE_PATH" = "/god-mode";
      "ADMIN_BASE_URL" = "http://localhost:3001";
      "API_KEY_RATE_LIMIT" = "60/minute";
      "APP_BASE_PATH" = "";
      "APP_BASE_URL" = "http://localhost:3000";
      "AWS_ACCESS_KEY_ID" = "access-key";
      "AWS_REGION" = "";
      "AWS_S3_BUCKET_NAME" = "uploads";
      "AWS_S3_ENDPOINT_URL" = "http://localhost:9000";
      "AWS_SECRET_ACCESS_KEY" = "secret-key";
      "CORS_ALLOWED_ORIGINS" =
        "http://localhost:3000,http://localhost:3001,http://localhost:3002,http://localhost:3100";
      "DATABASE_URL" = "postgresql://plane:plane@plane-db:5432/plane";
      "DEBUG" = "0";
      "DOCKERIZED" = "1";
      "FILE_SIZE_LIMIT" = "5242880";
      "GUNICORN_WORKERS" = "2";
      "HARD_DELETE_AFTER_DAYS" = "60";
      "LIVE_BASE_PATH" = "/live";
      "LIVE_BASE_URL" = "http://localhost:3100";
      "LIVE_SERVER_SECRET_KEY" = "secret-key";
      "MINIO_ENDPOINT_SSL" = "0";
      "POSTGRES_DB" = "plane";
      "POSTGRES_HOST" = "plane-db";
      "POSTGRES_PASSWORD" = "plane";
      "POSTGRES_PORT" = "5432";
      "POSTGRES_USER" = "plane";
      "RABBITMQ_HOST" = "plane-mq";
      "RABBITMQ_PASSWORD" = "plane";
      "RABBITMQ_PORT" = "5672";
      "RABBITMQ_USER" = "plane";
      "RABBITMQ_VHOST" = "plane";
      "REDIS_HOST" = "plane-redis";
      "REDIS_PORT" = "6379";
      "REDIS_URL" = "redis://plane-redis:6379/";
      "SECRET_KEY" = "1laga6wg2n1xggukj64us3jf1ubw59p0te5xsxql3ca1o9vawj";
      "SPACE_BASE_PATH" = "/spaces";
      "SPACE_BASE_URL" = "http://localhost:3002";
      "USE_MINIO" = "0";
      "WEB_URL" = "http://localhost:8000";
    };
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
      "API_KEY_RATE_LIMIT" = "60/minute";
      "AWS_ACCESS_KEY_ID" = "access-key";
      "AWS_REGION" = "";
      "AWS_S3_BUCKET_NAME" = "uploads";
      "AWS_S3_ENDPOINT_URL" = "http://plane-minio:9000";
      "AWS_SECRET_ACCESS_KEY" = "secret-key";
      "CERT_ACME_DNS" = "";
      "DOCKERIZED" = "1";
      "FILE_SIZE_LIMIT" = "5242880";
      "GPT_ENGINE" = "gpt-3.5-turbo";
      "LISTEN_HTTPS_PORT" = "2031";
      "LISTEN_HTTP_PORT" = "2030";
      "MINIO_ENDPOINT_SSL" = "0";
      "OPENAI_API_BASE" = "https://api.openai.com/v1";
      "OPENAI_API_KEY" = "sk-";
      "PGDATA" = "/var/lib/postgresql/data";
      "POSTGRES_DB" = "";
      "POSTGRES_PASSWORD" = "";
      "POSTGRES_USER" = "";
      "RABBITMQ_HOST" = "plane-mq";
      "RABBITMQ_PASSWORD" = "plane";
      "RABBITMQ_PORT" = "5672";
      "RABBITMQ_USER" = "plane";
      "RABBITMQ_VHOST" = "plane";
      "REDIS_HOST" = "plane-redis";
      "REDIS_PORT" = "6379";
      "TRUSTED_PROXIES" = "127.0.0.1/0";
      "USE_MINIO" = "1";
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
    environment = {
      "ADMIN_BASE_PATH" = "/god-mode";
      "ADMIN_BASE_URL" = "http://localhost:3001";
      "API_KEY_RATE_LIMIT" = "60/minute";
      "APP_BASE_PATH" = "";
      "APP_BASE_URL" = "http://localhost:3000";
      "AWS_ACCESS_KEY_ID" = "access-key";
      "AWS_REGION" = "";
      "AWS_S3_BUCKET_NAME" = "uploads";
      "AWS_S3_ENDPOINT_URL" = "http://localhost:9000";
      "AWS_SECRET_ACCESS_KEY" = "secret-key";
      "CORS_ALLOWED_ORIGINS" =
        "http://localhost:3000,http://localhost:3001,http://localhost:3002,http://localhost:3100";
      "DATABASE_URL" = "postgresql://plane:plane@plane-db:5432/plane";
      "DEBUG" = "0";
      "DOCKERIZED" = "1";
      "FILE_SIZE_LIMIT" = "5242880";
      "GUNICORN_WORKERS" = "2";
      "HARD_DELETE_AFTER_DAYS" = "60";
      "LIVE_BASE_PATH" = "/live";
      "LIVE_BASE_URL" = "http://localhost:3100";
      "LIVE_SERVER_SECRET_KEY" = "secret-key";
      "MINIO_ENDPOINT_SSL" = "0";
      "POSTGRES_DB" = "plane";
      "POSTGRES_HOST" = "plane-db";
      "POSTGRES_PASSWORD" = "plane";
      "POSTGRES_PORT" = "5432";
      "POSTGRES_USER" = "plane";
      "RABBITMQ_HOST" = "plane-mq";
      "RABBITMQ_PASSWORD" = "plane";
      "RABBITMQ_PORT" = "5672";
      "RABBITMQ_USER" = "plane";
      "RABBITMQ_VHOST" = "plane";
      "REDIS_HOST" = "plane-redis";
      "REDIS_PORT" = "6379";
      "REDIS_URL" = "redis://plane-redis:6379/";
      "SECRET_KEY" = "1laga6wg2n1xggukj64us3jf1ubw59p0te5xsxql3ca1o9vawj";
      "SPACE_BASE_PATH" = "/spaces";
      "SPACE_BASE_URL" = "http://localhost:3002";
      "USE_MINIO" = "0";
      "WEB_URL" = "http://localhost:8000";
    };
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
      "API_KEY_RATE_LIMIT" = "60/minute";
      "AWS_ACCESS_KEY_ID" = "access-key";
      "AWS_REGION" = "";
      "AWS_S3_BUCKET_NAME" = "uploads";
      "AWS_S3_ENDPOINT_URL" = "http://plane-minio:9000";
      "AWS_SECRET_ACCESS_KEY" = "secret-key";
      "CERT_ACME_DNS" = "";
      "DOCKERIZED" = "1";
      "FILE_SIZE_LIMIT" = "5242880";
      "GPT_ENGINE" = "gpt-3.5-turbo";
      "LISTEN_HTTPS_PORT" = "443";
      "LISTEN_HTTP_PORT" = "2030";
      "MINIO_ENDPOINT_SSL" = "0";
      "OPENAI_API_BASE" = "https://api.openai.com/v1";
      "OPENAI_API_KEY" = "sk-";
      "PGDATA" = "/var/lib/postgresql/data";
      "POSTGRES_DB" = "plane";
      "POSTGRES_PASSWORD" = "plane";
      "POSTGRES_USER" = "plane";
      "RABBITMQ_DEFAULT_PASS" = "";
      "RABBITMQ_DEFAULT_USER" = "";
      "RABBITMQ_DEFAULT_VHOST" = "";
      "RABBITMQ_HOST" = "plane-mq";
      "RABBITMQ_PASSWORD" = "plane";
      "RABBITMQ_PORT" = "5672";
      "RABBITMQ_USER" = "plane";
      "RABBITMQ_VHOST" = "plane";
      "REDIS_HOST" = "plane-redis";
      "REDIS_PORT" = "6379";
      "TRUSTED_PROXIES" = "127.0.0.1/0";
      "USE_MINIO" = "1";
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
