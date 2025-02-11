{
  services,
  pkgs,
  ...
}: {
  config = {
    services.podman.enable = true;
  };
}
