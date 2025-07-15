{ pkgs, ... }:
let src = ./.;
in {
  systemd.targets."docker-build-plane-images" = {
    unitConfig = {
      Description = "Target to build docker images needed by plane.";
    };
  };
  # Builds
  systemd.services."docker-build-admin" = {
    path = [ pkgs.docker pkgs.git ];
    serviceConfig = {
      Type = "oneshot";
      TimeoutSec = 300;
    };
    script = ''
      cd ${src}
      docker build -t compose2nix/admin --build-arg DOCKER_BUILDKIT=1 -f ./apps/admin/Dockerfile.admin .
    '';
    wantedBy = [ "docker-build-plane-images.target" ];
  };
  systemd.services."docker-build-api" = {
    path = [ pkgs.docker pkgs.git ];
    serviceConfig = {
      Type = "oneshot";
      TimeoutSec = 300;
    };
    script = ''
      cd ${src}/apps/api
      docker build -t compose2nix/api --build-arg DOCKER_BUILDKIT=1 -f Dockerfile.api .
    '';
    wantedBy = [ "docker-build-plane-images.target" ];
  };
  systemd.services."docker-build-beatworker" = {
    path = [ pkgs.docker pkgs.git ];
    serviceConfig = {
      Type = "oneshot";
      TimeoutSec = 300;
    };
    script = ''
      cd ${src}/apps/api
      docker build -t compose2nix/beatworker --build-arg DOCKER_BUILDKIT=1 -f Dockerfile.api .
    '';
    wantedBy = [ "docker-build-plane-images.target" ];
  };
  systemd.services."docker-build-bgworker" = {
    path = [ pkgs.docker pkgs.git ];
    serviceConfig = {
      Type = "oneshot";
      TimeoutSec = 300;
    };
    script = ''
      cd ${src}/apps/api
      docker build -t compose2nix/bgworker --build-arg DOCKER_BUILDKIT=1 -f Dockerfile.api .
    '';
    wantedBy = [ "docker-build-plane-images.target" ];
  };
  systemd.services."docker-build-plane-live" = {
    path = [ pkgs.docker pkgs.git ];
    serviceConfig = {
      Type = "oneshot";
      TimeoutSec = 300;
    };
    script = ''
      cd ${src}
      docker build -t compose2nix/plane-live --build-arg DOCKER_BUILDKIT=1 -f ./apps/live/Dockerfile.live .
    '';
    wantedBy = [ "docker-build-plane-images.target" ];
  };
  systemd.services."docker-build-plane-migrator" = {
    path = [ pkgs.docker pkgs.git ];
    serviceConfig = {
      Type = "oneshot";
      TimeoutSec = 300;
    };
    script = ''
      cd ${src}/apps/api
      docker build -t compose2nix/plane-migrator --build-arg DOCKER_BUILDKIT=1 -f Dockerfile.api .
    '';
    wantedBy = [ "docker-build-plane-images.target" ];
  };
  systemd.services."docker-build-proxy" = {
    path = [ pkgs.docker pkgs.git ];
    serviceConfig = {
      Type = "oneshot";
      TimeoutSec = 300;
    };
    script = ''
      cd ${src}/apps/proxy
      docker build -t compose2nix/proxy -f Dockerfile.ce .
    '';
  };
  systemd.services."docker-build-space" = {
    path = [ pkgs.docker pkgs.git ];
    serviceConfig = {
      Type = "oneshot";
      TimeoutSec = 300;
    };
    script = ''
      cd ${src}
      docker build -t compose2nix/space --build-arg DOCKER_BUILDKIT=1 -f ./apps/space/Dockerfile.space .
    '';
    wantedBy = [ "docker-build-plane-images.target" ];
  };
  systemd.services."docker-build-web" = {
    path = [ pkgs.docker pkgs.git ];
    serviceConfig = {
      Type = "oneshot";
      TimeoutSec = 300;
    };
    script = ''
      cd ${src}
      docker build -t compose2nix/web --build-arg DOCKER_BUILDKIT=1 -f ./apps/web/Dockerfile.web .
    '';
    wantedBy = [ "docker-build-plane-images.target" ];
  };
}
