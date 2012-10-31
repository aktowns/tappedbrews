require 'formula'

class Qyoto < Formula
  homepage 'http://techbase.kde.org/Development/Languages/Qyoto'
  url ''
  head 'git://gitorious.org/assemblygen/assemblygen.git'
  sha1 '3475389f9c4fb195b8843bb09e1e618223b4fe56'

  depends_on 'cmake' => :build
  depends_on 'qt'
  depends_on 'aktowns/tappedbrews/mono3'
  depends_on 'aktowns/tappedbrews/smokeqt'

  def install
    system "cmake", "-DCMAKE_OSX_ARCHITECTURES:STRING=x86_64", ".", *std_cmake_args
    system "make install"
  end

  def test
  end
end
