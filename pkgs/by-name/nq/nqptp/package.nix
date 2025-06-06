{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  gitUpdater,
}:

stdenv.mkDerivation rec {
  version = "1.2.4";
  pname = "nqptp";

  src = fetchFromGitHub {
    owner = "mikebrady";
    repo = "nqptp";
    tag = version;
    hash = "sha256-roTNcr3v2kzE6vQ5plAVtlw1+2yJplltOYsGGibtoZo=";
  };

  patches = [
    # these patches should be removed when > 1.2.4
    ./remove-setcap.patch
    ./systemd-service-capability.patch
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  passthru.updateScript = gitUpdater {
    ignoredVersions = ".*(-dev|d0)";
  };

  postInstall = ''
    mkdir -p $out/lib/systemd/system
    cp nqptp.service $out/lib/systemd/system
  '';

  meta = {
    homepage = "https://github.com/mikebrady/nqptp";
    description = "Daemon and companion application to Shairport Sync that monitors timing data from any PTP clocks";
    license = lib.licenses.gpl2Only;
    mainProgram = "nqptp";
    maintainers = with lib.maintainers; [
      jordanisaacs
      adamcstephens
    ];
    platforms = lib.platforms.linux ++ lib.platforms.freebsd;
  };
}
