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

  config = let
    # This sort is consistent across machines because we set the locale.
    sort = pkgs.symlinkJoin {
      name = "sort";
      paths = [ cfg.package ];
      buildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/sort \
          --set LC_ALL C \
          --set LC_COLLATE C
      '';
    };
  in lib.mkIf cfg.enable {
    settings.formatter.sort = {
      command = "${sort}/bin/sort";
      options = [ "-uo" "${cfg.file}" "${cfg.file}" ];
      includes = [ cfg.file ];
    };
  };
}
