require 'formula'

class Smokeqt < Formula
  homepage 'git://anongit.kde.org/smokeqt'
  url ''
  sha1 ''
  head 'git://anongit.kde.org/smokeqt'
  version '0.0'

  depends_on 'cmake' => :build
  depends_on 'aktowns/tappedbrews/mono3'
  depends_on 'qt'
  depends_on 'aktowns/tappedbrews/smokegen'
  env :std

  def install
    system "cmake", "-DSmoke_DIR=/usr/local/share/smokegen/cmake", ".", *std_cmake_args
    system "echo QT_NO_ACCESSIBILITY >> qtdefines"
    system "make install"
  end

  def test
  end
end
