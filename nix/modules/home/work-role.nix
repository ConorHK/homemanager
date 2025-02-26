{
  config,
  lib,
  ...
}:
let
  script-directory = config.cli.programs.script-directory;
in
with lib;
{
  config.home = {
    sessionVariables = {
      BRAZILPYTHON_FAST_FAIL = "true";
      BRAZILPYTHON_I_KNOW_THAT_I_NEED_TO_READ_THE_ERROR_MESSAGE_CAREFULLY_AND_CHECK_THE_FAQ = "true";
      BRAZIL_RUNTIME_PACKAGES_DIR = "build/private/tmp/brazil-path/build.libfarm/lib/python3.8/site-packages";
      BRAZIL_USE_RUST = 1;
    };

    sessionPath = [
      "${config.home.homeDirectory}/.toolbox/bin"
      "/apollo/env/envImprovement/bin"
    ];

    shellAliases = {
      brazil = mkIf script-directory.enable "work-brazil";
      brazil-build = mkIf script-directory.enable "work-brazil-build";
      cr = mkIf script-directory.enable "work-cr";
      git = mkIf script-directory.enable "work-git";
      ssh = mkIf script-directory.enable "work-ssh";
      bba = "brazil-build apollo-pkg";
      bre = "brazil-runtime-exec";
      bte = "brazil-test-exec";
      brc = "brazil-recursive-cmd";
      bws = "brazil ws";
      bwsuse = "bws use --gitMode -p";
      bwscreate = "bws create -n";
      bbr = "brc brazil-build";
      bbrd = "brc --allPackages brazil-build develop";
      bball = "brc --allPackages";
      bbb = "brc --allPackages brazil-build";
      bbra = "bbr apollo-pkg";
      bbdev = "brazil-build develop";
      bb = "brazil-build";
    };
  };

  config.cli.programs.git = {
    defaultBranch = "mainline";
    email = "knoconor@amazon.com";
  };

  config.cli.programs.ssh.enable = mkForce false;
}
