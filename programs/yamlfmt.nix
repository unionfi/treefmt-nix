{ lib, pkgs, config, ... }:
let
  cfg = config.programs.yamlfmt;
  yamlExts = [ "*.yaml" "*.yml" ];
in
{
  options.programs.yamlfmt = {
    enable = lib.mkEnableOption "yamlfmt";
    package = lib.mkPackageOption pkgs "yamlfmt" { };
    includes = lib.mkOption {
      description = "Path / file patterns to include for yamlfmt";
      type = lib.types.listOf lib.types.str;
      example = yamlExts;
      default = yamlExts;
    };

    excludes = lib.mkOption {
      description = "Path / file patterns to exclude for yamlfmt";
      type = lib.types.listOf lib.types.str;
      example = [ "**/vendor/**" ];
      default = [ ];
    };

    config = lib.mkOption {
      description = "Config for yamlfmt. Will be passed verbatim to `yamlfmt -conf`.";
      type = lib.types.nullOr lib.types.attrs;
      example = { retain_line_breaks = true; };
      default = null;
    };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.yamlfmt = {
      inherit (cfg) includes excludes;
      command = cfg.package;
      options = [ "-no_global_conf" ] ++ (
        if cfg.config != null
        then [ "-conf" "${pkgs.writeText "yamlfmt.yaml" (builtins.toJSON { formatter = cfg.config; })}" ]
        else { }
      );
    };
  };
}
