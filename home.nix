{ ... }:
{
  imports = [
    ./home
    ./programs
  ];

  home.username = "struckcroissant";
  programs.backupExtension = "orig";

  programs.git.userName = "Struck Croissant";
  programs.git.userEmail = "32440863+StruckCroissant@users.noreply.github.com";
}
