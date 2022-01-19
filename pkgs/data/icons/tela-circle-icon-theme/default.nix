{ lib
, stdenvNoCC
, fetchFromGitHub
, gtk3
, hicolor-icon-theme
, jdupes
, allColorVariants ? false
, circularFolder ? false
, colorVariants ? [] # default is standard
}:

let
  pname = "tela-circle-icon-theme";
in
lib.checkListOfEnum "${pname}: color variants" [ "standard" "black" "blue" "brown" "green" "grey" "orange" "pink" "purple" "red" "yellow" "manjaro" "ubuntu" ] colorVariants

stdenvNoCC.mkDerivation rec {
  inherit pname;
  version = "unstable-2021-12-24";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = pname;
    rev = "aa1f1446b6dbc6acfe3ee247e6841369c68e1495";
    sha256 = "03f79h6kv5vbf92fhpi1wivzvcrfvvdvkhbmy805x4b4wl7qynki";
  };

  nativeBuildInputs = [
    gtk3
    jdupes
  ];

  propagatedBuildInputs = [
    hicolor-icon-theme
  ];

  dontDropIconThemeCache = true;

  # These fixup steps are slow and unnecessary for this package.
  # Package may installs almost 400 000 small files.
  dontPatchELF = true;
  dontRewriteSymlinks = true;

  installPhase = ''
    runHook preInstall

    patchShebangs install.sh

    ./install.sh -d $out/share/icons \
      ${lib.optionalString circularFolder "-c"} \
      ${if allColorVariants then "-a" else builtins.toString colorVariants}

    jdupes -L -r $out/share/icons

    runHook postInstall
  '';

  meta = with lib; {
    description = "Flat and colorful personality icon theme";
    homepage = "https://github.com/vinceliuice/Tela-circle-icon-theme";
    license = licenses.gpl3Only;
    platforms = platforms.unix;
    maintainers = with maintainers; [ romildo ];
  };
}
