{ stdenv, fetchFromGitHub, cmake, ncurses }:

stdenv.mkDerivation rec{
  pname = "ninvaders";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "sf-refugees";
    repo = pname;
    rev = "v${version}";
    sha256 = "1wmwws1zsap4bfc2439p25vnja0hnsf57k293rdxw626gly06whi";
  };

  buildInputs = [ cmake ncurses ];

  meta = with stdenv.lib; {
    description = "Space Invaders clone based on ncurses";
    homepage = "http://ninvaders.sourceforge.net/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ maintainers."1000101" ];
    platforms = platforms.all;
  };
}
