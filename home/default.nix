{
  config,
  pkgs,
  specialArgs,
  ...
}:
let
  inherit (specialArgs) role;
  if-exists = f: builtins.pathExists f;
  existing-imports = imports: builtins.filter if-exists imports;
in
{
  imports =
    [
      ./common
    ]
    ++ existing-imports [
      ./${role}
    ];

  home = {
    packages = with pkgs; [

    ];
  };
}
