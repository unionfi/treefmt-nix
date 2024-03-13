{ lib
, pkgs
, config
, ...
}:
let
  l = lib // builtins;
  t = l.types;
  p = pkgs;

  cfg = config.programs.forge;
in
{
  options.programs.forge = {
    enable = l.mkEnableOption "forge";
    package = l.mkPackageOption p "forge" { };

    includes = l.mkOption {
      description = "Path / file patterns to include for forge fmt";
      type = t.listOf t.str;
      example = [ "*.sol" ];
      default = [ "*.sol" ];
    };

    excludes = l.mkOption {
      description = "Path / file patterns to exclude for forge fmt";
      type = t.listOf t.str;
      example = [ "generated/*" ];
      default = [ ];
    };
  };

  config = l.mkIf cfg.enable {
    settings.formatter.forge = {
      command = l.getExe cfg.package;

      inherit (cfg) includes excludes;

      options = [ "fmt" ];
    };
  };
}
