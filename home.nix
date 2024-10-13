{ ... }:
{
  imports = [
    ./custom-user
    ./programs
  ];

  custom-user.username = "struckcroissant";
  programs.backupExtension = "orig";
}