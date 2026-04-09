{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    whitesur-src = {
      url = "github:vinceliuice/WhiteSur-icon-theme";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, whitesur-src }:
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    packages.${system}.default = (pkgs.whitesur-icon-theme.override {
      alternativeIcons = true;
      boldPanelIcons = true;
    }).overrideAttrs (old: {
      version = "latest";
      src = whitesur-src;
      dontCheckForBrokenSymlinks = true;
      postPatch = (old.postPatch or "") + ''
        echo "Injecting custom icons into source..."
        cp --no-preserve=mode ${self}/apps/scalable/*.svg src/apps/scalable/
        '';
    });
  };
}