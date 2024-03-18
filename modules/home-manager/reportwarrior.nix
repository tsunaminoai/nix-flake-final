{
  inputs,
  outputs,
  pkgs,
  ...
}: {
  outputs = pkgs.nodePackages.fetchNodeModules {
    name = "reportwarrior";
    src = pkgs.fetchFromGitHub {
      owner = "StephanMeijer";
      repo = "ReportWarrior";
      rev = "v0.3.1";
      sha256 = "sha256-Y0atkJfZxjUOGPQ3goXS/YD5SsX9ZjpbM0Nc5IuaFP4=";
    };

    makeTarball = false;
    sha256 = "sha256-/x8XwHxIEYS3IxEuk1jp1wYyJIV11DdSXUU+DCkrQ1g=";
  };
}
