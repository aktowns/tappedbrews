require 'formula'

class Mono3 < Formula
  url 'http://download.mono-project.com/sources/mono/mono-3.0.0.tar.bz2'
  homepage 'http://www.mono-project.com/Release_Notes_Mono_3.0'
  md5 'f1c5619036593de7dc19d16681e3b4d1'

  def install
    args = ["--prefix=#{prefix}",
            "--with-glib=embedded",
            "--enable-nls=no"]

    args << "--host=x86_64-apple-darwin10" if MacOS.prefer_64_bit?

    system "./configure", *args
    system "make"
    system "make install"
  end
end