{
  config,
  services,
  pkgs,
  ...
}: {
    options.services.podman.enable = true;
}
