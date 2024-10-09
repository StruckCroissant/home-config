{
  description = "Home manager base config flake";

  inputs = {
    core.url = "path:core";
  };

   outputs = { self, core, ... }: core.generate {
     username = "struckcroissant";
     userName = "Dakota Vaughn";
     host = "Hub";
     email = "32440863+StruckCroissant@users.noreply.github.com";
   };
}
