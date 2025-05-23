{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  meson,
  ninja,
  nixos-artwork,
  glib,
  pkg-config,
  dbus,
  polkit,
  accountsservice,
}:

stdenv.mkDerivation rec {
  pname = "elementary-default-settings";
  version = "8.1.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "default-settings";
    rev = version;
    sha256 = "sha256-GUq7kXaidzvqbyeVh4ihcxRqZXOzZO3WMXEe8lf477I=";
  };

  nativeBuildInputs = [
    glib # glib-compile-schemas
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    accountsservice
    dbus
    polkit
  ];

  mesonFlags = [
    "--sysconfdir=${placeholder "out"}/etc"
    "-Ddefault-wallpaper=${nixos-artwork.wallpapers.simple-dark-gray.gnomeFilePath}"
    # Do not ship elementary OS specific config files.
    "-Dapparmor-profiles=false"
    "-Dgeoclue=false"
  ];

  postFixup = ''
    # https://github.com/elementary/default-settings/issues/55
    rm -r $out/share/cups
    rm -r $out/share/applications
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Default settings and configuration files for elementary";
    homepage = "https://github.com/elementary/default-settings";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    teams = [ teams.pantheon ];
  };
}
