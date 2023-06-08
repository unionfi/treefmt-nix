{ lib, pkgs, config, ... }:
let
  cfg = config.programs.sort;
in
{
  options.programs.sort = {
    enable = lib.mkEnableOption "sort";
    package = lib.mkPackageOption pkgs "coreutils" { };
    file = lib.mkOption {
      type = lib.types.str;
      description = "The file to sort";
    };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.sort = {
      command = "${cfg.package}/bin/sort";
      options = [ "-uo" "${cfg.file}" "${cfg.file}" ];
      includes = [ cfg.file ];
    };
  };
}
