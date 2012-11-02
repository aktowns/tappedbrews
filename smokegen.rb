require 'formula'

class Smokegen < Formula
  homepage 'git://anongit.kde.org/smokegen'
  url ''
  head 'git://anongit.kde.org/smokegen'
  sha1 ''
  version '0.0'

  depends_on 'aktowns/tappedbrews/mono3'
  depends_on 'cmake' => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make install" 
    #"#{share}/smokegen/".install 'cmake'
    system "cp -rv cmake #{prefix}/share/smokegen/" 
  end

  def test
  end
end
