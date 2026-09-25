{ pkgs }:

pkg: binNames: pkgs.symlinkJoin {
  name = "${pkg.pname or pkg.name}-ja";
  paths = [ pkg ];
  postBuild = builtins.concatStringsSep "\n" (map (binName: ''
    wrapProgram $out/bin/${binName} --set LANGUAGE ja_JP.UTF-8 --set LANG ja_JP.UTF-8
  '') binNames);
  nativeBuildInputs = [ pkgs.makeWrapper ];
}
