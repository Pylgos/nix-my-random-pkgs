{ stdenv
, src
, deb
, libX11
, autoPatchelfHook

, libcxx
, udev
, libGL
}:

stdenv.mkDerivation {
  pname = "open3d";
  version = "0.16.1";

  inherit src;

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    libGL
    libcxx
    libX11
    udev
  ];

  runtimeDependencies = [
    libGL
  ];

  installPhase = ''
    cp -a . $out
    ar x ${deb}
    tar -xzvf data.tar.gz
    cp -a usr/local/* $out
    substituteInPlace $out/bin/Open3D --replace /usr/local $out
  '';
}
