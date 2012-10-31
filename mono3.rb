require 'formula'

class Fsharp < Formula
  homepage 'http://fsharp.github.com/fsharp/'
  url 'https://nodeload.github.com/fsharp/fsharp/zipball/3.0.11'
end

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

    Fsharp.new.brew do
      system "./autogen.sh --prefix=#{prefix}"
      system "make install"
    end
  end

  def caveats 
    "Compiling may fail on static pthread error, try using --use-llvm"
  end
end
