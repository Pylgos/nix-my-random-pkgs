{ pkgs, inputs }:
let
  inherit (inputs) uv2nix pyproject-nix pyproject-build-systems;
  workspace = uv2nix.lib.workspace.loadWorkspace { workspaceRoot = inputs.serena-src; };
  uvLockedOverlay = workspace.mkPyprojectOverlay {
    sourcePreference = "wheel";
  };
  pythonSet =
    (pkgs.callPackage pyproject-nix.build.packages {
      python = pkgs.python311;
    }).overrideScope
      (
        pkgs.lib.composeManyExtensions [
          pyproject-build-systems.overlays.default
          uvLockedOverlay
        ]
      );
  inherit (pkgs.callPackages pyproject-nix.build.util { }) mkApplication;
in
mkApplication {
  venv = pythonSet.mkVirtualEnv "application-env" workspace.deps.default;
  package = pythonSet.serena-agent;
}
