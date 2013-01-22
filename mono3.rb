require 'formula'

class Fsharp < Formula
  homepage 'http://fsharp.github.com/fsharp/'
  url 'https://github.com/fsharp/fsharp/archive/3.0.25.zip'
end

class Mono3 < Formula
  url 'http://download.mono-project.com/sources/mono/mono-3.0.3.tar.bz2'
  homepage 'http://www.mono-project.com/Release_Notes_Mono_3.0'
  md5 'c1e9fb125f620597a9bc1cdc1fee9288'
  version '3.0.3'

  depends_on 'automake' => :build
  depends_on 'pkg-config'

  def install
    args = ["--prefix=#{prefix}",
            "--with-glib=embedded",
            "--enable-nls=no"]

    args << "--host=x86_64-apple-darwin10" if MacOS.prefer_64_bit?

    system "./configure", *args
    system "make"
    system "make install"

    Fsharp.new.brew do
      ENV.prepend 'PATH', "#{bin}:"
      ENV.prepend 'PKG_CONFIG_PATH', "PKG_CONFIG_PATH=#{lib}/pkgconfig/:"

      system "./autogen.sh --prefix=#{prefix} --with-gacdir=#{lib}/mono/gac/"
      system "make"
      system "make install"
    end
  end

  def caveats 
    "Compiling may fail on static pthread error, try using --use-llvm"
  end
end
