require 'formula'

class Usbmuxd < Formula
  homepage 'http://marcansoft.com/blog/iphonelinux/usbmuxd/'
  url 'http://www.libimobiledevice.org/downloads/usbmuxd-1.0.8.tar.bz2'
  sha1 '56bd90d5ff94c1d9c528f8b49deffea25b7384e8'

  head 'http://cgit.sukimashita.com/usbmuxd.git'

  depends_on 'cmake' => :build
  depends_on 'pkg-config' => :build

  depends_on 'libusb'
  depends_on 'libplist'

  def patches
    DATA
  end

  def install
    libusb = Formula.factory 'libusb'
    inreplace 'Modules/VersionTag.cmake', '"sh"', '"bash"'
    ENV.universal_binary
    
    # The CMake scripts responsible for locating libusb headers are broken. So,
    # we explicitly point the build script at the proper directory.
    mkdir 'build' do
      system "cmake", "..",
                      "-DLIB_SUFFIX=",
                      "-DUSB_INCLUDE_DIR=#{libusb.include.children.first}",
                      *std_cmake_args
      system 'make install'
    end
  end
end

__END__
diff --git a/libusbmuxd/CMakeLists.txt b/libusbmuxd/CMakeLists.txt
index 737eb02..5716479 100644
--- a/libusbmuxd/CMakeLists.txt 
+++ b/libusbmuxd/CMakeLists.txt
@@ -11,6 +11,8 @@ endif()
 endif(WANT_INOTIFY)
 
 add_library (libusbmuxd SHARED libusbmuxd.c sock_stuff.c ${CMAKE_SOURCE_DIR}/common/utils.c)
+add_library (libusbmuxdstatic STATIC libusbmuxd.c sock_stuff.c ${CMAKE_SOURCE_DIR}/common/utils.c)
+
 find_library (PTHREAD pthread)
 
 if (HAVE_PLIST)
@@ -22,6 +24,8 @@ if(WIN32)
 endif()
 include_directories(${OPT_INCLUDES})
 target_link_libraries (libusbmuxd ${CMAKE_THREAD_LIBS_INIT} ${OPT_LIBS})
+target_link_libraries (libusbmuxdstatic ${CMAKE_THREAD_LIBS_INIT} ${OPT_LIBS})
+
 
 # 'lib' is a UNIXism, the proper CMake target is usbmuxd
 # But we can't use that due to the conflict with the usbmuxd daemon,
@@ -29,12 +33,17 @@ target_link_libraries (libusbmuxd ${CMAKE_THREAD_LIBS_INIT} ${OPT_LIBS})
 set_target_properties(libusbmuxd PROPERTIES OUTPUT_NAME usbmuxd)
 set_target_properties(libusbmuxd PROPERTIES VERSION ${LIBUSBMUXD_VERSION})
 set_target_properties(libusbmuxd PROPERTIES SOVERSION ${LIBUSBMUXD_SOVERSION})
+set_target_properties(libusbmuxdstatic PROPERTIES OUTPUT_NAME usbmuxd)
+set_target_properties(libusbmuxdstatic PROPERTIES VERSION ${LIBUSBMUXD_VERSION})
+set_target_properties(libusbmuxdstatic PROPERTIES SOVERSION ${LIBUSBMUXD_SOVERSION})
 
 if(APPLE)
   set_target_properties(libusbmuxd PROPERTIES INSTALL_NAME_DIR "${CMAKE_INSTALL_PREFIX}/lib${LIB_SUFFIX}")
+  set_target_properties(libusbmuxdstatic PROPERTIES INSTALL_NAME_DIR "${CMAKE_INSTALL_PREFIX}/lib${LIB_SUFFIX}")
 endif()
 if(WIN32)
   set_target_properties(libusbmuxd PROPERTIES PREFIX "lib" IMPORT_PREFIX "lib")
+  set_target_properties(libusbmuxdstatic PROPERTIES PREFIX "lib" IMPORT_PREFIX "lib")
 endif()
 
 install(TARGETS libusbmuxd
@@ -42,4 +51,9 @@ install(TARGETS libusbmuxd
  ARCHIVE DESTINATION lib${LIB_SUFFIX}
  LIBRARY DESTINATION lib${LIB_SUFFIX}
 )
+install(TARGETS libusbmuxdstatic
+  RUNTIME DESTINATION bin
+  ARCHIVE DESTINATION lib${LIB_SUFFIX}
+  LIBRARY DESTINATION lib${LIB_SUFFIX}
+)
 install(FILES usbmuxd.h usbmuxd-proto.h DESTINATION include)
