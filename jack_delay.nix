{ lib
, stdenv
, fetchurl
, libjack2
, alsa-lib
}:

stdenv.mkDerivation rec {
  pname = "jack_delay";
  version = "0.4.2";

  src = fetchurl {
    url = "https://kokkinizita.linuxaudio.org/linuxaudio/downloads/${pname}-${version}.tar.bz2";
    hash = "sha256-oNWzY68wnDF9rVOriEiCu3FPlfihHL0hks/p1PwaubY=";
  };

  buildInputs = [ libjack2 alsa-lib ];

  postPatch = ''
    sed -e '/march=native/d' -i source/Makefile
  '';

  buildPhase = ''
    runHook preBuild
    make -C source
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    make PREFIX=$out DESTDIR="" install -C source
    install -vDm 644 AUTHORS README -t "$out/share/doc/${pname}/"
    runHook postInstall
  '';

  meta = with lib; {
    description = "Measure the round-trip latency of a soundcard";
    homepage = "https://kokkinizita.linuxaudio.org/linuxaudio/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ];
    mainProgram = "jack_delay";
  };
}
