{
  lib,
  stdenv,
  fetchFromGitHub,
  darwin,
  git,
  nim,
  pkg-config,
  taskopen,
  makeWrapper,
}:
stdenv.mkDerivation (finalAttrs: rec {
  pname = "taskopen";

  version = "v2.0.1";

  src = fetchFromGitHub {
    owner = "jschlatow";
    repo = "taskopen";
    rev = "refs/tags/${version}";
    hash = "sha256-Gy0QS+FCpg5NGSctVspw+tNiBnBufw28PLqKxnaEV7I=";
  };

  sourceRoot = "${finalAttrs.src.name}/";

  nativeBuildInputs = [makeWrapper];
  buildInputs = [nim git];

  postPatch = ''
    # We don't need a DESTDIR and an empty string results in an absolute path
    # (due to the trailing slash) which breaks the build.
    sed 's|$(DESTDIR)/||' -i Makefile
  '';
  buildPhase = ''
    export HOME=$(pwd)
  '';
  installPhase = ''
    make PREFIX=$out install
  '';

  doCheck = true;

  meta = {
    inherit (taskopen.meta) description homepage license maintainers;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
