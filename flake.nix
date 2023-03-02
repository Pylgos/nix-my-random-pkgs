{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/22.11";
    flake-utils.url = "github:numtide/flake-utils";
    open3d-archive = { url = "https://github.com/isl-org/Open3D/releases/download/v0.16.0/open3d-devel-linux-x86_64-cxx11-abi-0.16.0.tar.xz"; flake = false; };
    open3d-deb = { url = "https://github.com/isl-org/Open3D/releases/download/v0.16.0/open3d-app-0.16.0-Ubuntu.deb"; flake = false; };
  };

  outputs = { self, nixpkgs, flake-utils, ... } @ inputs:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system}; in
      rec {
        packages = rec {
          open3d = pkgs.callPackage ./open3d { src = inputs.open3d-archive; deb = inputs.open3d-deb; };
        };
      }
    );
}