class Armadillo < Formula
  homepage "http://arma.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-5.000.1.tar.gz"
  sha256 "8ca55fbfce220517374a879ddc0c79e1afd3993f89cc58621aa502e9533f3cdb"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    sha256 "9712787fe66c895ff57fe760f4fa0a540deef898d16d924b0b039b61117f560a" => :yosemite
    sha256 "bfa579b94034650b382b668978b23cca288cab961d5d6fdfd3ce757cb8478ceb" => :mavericks
    sha256 "68c3825c08ee6fbf542de429596a03925b33957af1326631c8c2f94f171289a7" => :mountain_lion
  end

  option "with-hdf5", "Enable the ability to save and load matrices stored in the HDF5 format"

  depends_on "cmake" => :build
  depends_on "arpack"
  depends_on "superlu"
  depends_on "hdf5" => :optional
  depends_on "openblas" if OS.linux?

  option :cxx11

  def install
    ENV.cxx11 if build.cxx11?

    args = std_cmake_args
    args << "-DDETECT_HDF5=ON" if build.with? "hdf5"

    system "cmake", ".", *args
    system "make", "install"

    prefix.install "examples"
  end

  test do
    (testpath/"test.cpp").write <<-EOS
      #include <iostream>
      #include <armadillo>
      using namespace std;
      using namespace arma;

      int main(int argc, char** argv)
        {
        cout << arma_version::as_string() << endl;
        }
    EOS
    system ENV.cxx, "test.cpp", "-I#{include}", "-L#{lib}", "-larmadillo", "-o", "test"
    assert_equal `./test`.to_i, version.to_s.to_i
  end
end
