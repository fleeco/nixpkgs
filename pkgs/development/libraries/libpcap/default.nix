{ lib, stdenv, fetchurl, flex, bison, bluez, pkg-config, withBluez ? false }:

with lib;

stdenv.mkDerivation rec {
  pname = "libpcap";
  version = "1.10.1";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "https://www.tcpdump.org/release/${pname}-${version}.tar.gz";
    sha256 = "sha256-7ShfSsyvBTRPkJdXV7Pb/ncrpB0cQBwmSLf6RbcRvdQ=";
  };

  nativeBuildInputs = [ flex bison ]
    ++ optionals withBluez [ bluez.dev pkg-config ];

  # We need to force the autodetection because detection doesn't
  # work in pure build environments.
  configureFlags = [
    "--with-pcap=${if stdenv.isLinux then "linux" else "bpf"}"
  ] ++ optionals stdenv.isDarwin [
    "--disable-universal"
  ] ++ optionals (stdenv.hostPlatform == stdenv.buildPlatform)
    [ "ac_cv_linux_vers=2" ];

  postInstall = ''
    if [ "$dontDisableStatic" -ne "1" ]; then
      rm -f $out/lib/libpcap.a
    fi

    moveToOutput "bin/pcap-config" "$dev"
  '';

  meta = {
    homepage = "https://www.tcpdump.org";
    description = "Packet Capture Library";
    platforms = platforms.unix;
    maintainers = with maintainers; [ fpletz ];
    license = licenses.bsd3;
  };
}
