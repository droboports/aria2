### ZLIB ###
_build_zlib() {
local VERSION="1.2.8"
local FOLDER="zlib-${VERSION}"
local FILE="${FOLDER}.tar.gz"
local URL="http://zlib.net/${FILE}"

_download_tgz "${FILE}" "${URL}" "${FOLDER}"
pushd "target/${FOLDER}"
./configure --prefix="${DEPS}" --libdir="${DEST}/lib" --shared
make
make install
popd
}

### OPENSSL ###
_build_openssl() {
local VERSION="1.0.2d"
local FOLDER="openssl-${VERSION}"
local FILE="${FOLDER}.tar.gz"
local URL="http://mirror.switch.ch/ftp/mirror/openssl/source/${FILE}"

_download_tgz "${FILE}" "${URL}" "${FOLDER}"
cp -vf "src/${FOLDER}-parallel-build.patch" "target/${FOLDER}/"
pushd "target/${FOLDER}"
patch -p1 -i "${FOLDER}-parallel-build.patch"
./Configure --prefix="${DEPS}" --openssldir="${DEST}/etc/ssl" \
  zlib-dynamic --with-zlib-include="${DEPS}/include" --with-zlib-lib="${DEPS}/lib" \
  shared threads linux-armv4 -DL_ENDIAN ${CFLAGS} ${LDFLAGS} -Wa,--noexecstack -Wl,-z,noexecstack
sed -i -e "s/-O3//g" Makefile
make
make install_sw
cp -vfaR "${DEPS}/lib"/* "${DEST}/lib/"
rm -vfr "${DEPS}/lib"
rm -vf "${DEST}/lib/libcrypto.a" "${DEST}/lib/libssl.a"
sed -i -e "s|^exec_prefix=.*|exec_prefix=${DEST}|g" "${DEST}/lib/pkgconfig/openssl.pc"
popd
}

### SQLITE ###
_build_sqlite() {
local VERSION="3081101"
local FOLDER="sqlite-autoconf-${VERSION}"
local FILE="${FOLDER}.tar.gz"
local URL="http://sqlite.org/$(date +%Y)/${FILE}"

_download_tgz "${FILE}" "${URL}" "${FOLDER}"
pushd "target/${FOLDER}"
./configure --host="${HOST}" --prefix="${DEPS}" --libdir="${DEST}/lib" --disable-static
make
make install
popd
}

### LIBXML2 ###
_build_libxml2() {
local VERSION="2.9.2"
local FOLDER="libxml2-${VERSION}"
local FILE="${FOLDER}.tar.gz"
local URL="ftp://xmlsoft.org/libxml2/${FILE}"

_download_tgz "${FILE}" "${URL}" "${FOLDER}"
pushd "target/${FOLDER}"
./configure --host="${HOST}" --prefix="${DEPS}" --libdir="${DEST}/lib" --disable-static --with-zlib="${DEPS}" --without-python LIBS="-lz"
make
make install
popd
}

### C-ARES ###
_build_cares() {
local VERSION="1.10.0"
local FOLDER="c-ares-${VERSION}"
local FILE="${FOLDER}.tar.gz"
local URL="http://c-ares.haxx.se/download/${FILE}"

_download_tgz "${FILE}" "${URL}" "${FOLDER}"
pushd "target/${FOLDER}"
./configure --host="${HOST}" --prefix="${DEPS}" --libdir="${DEST}/lib" --disable-static
make
make install
popd
}

### ARIA2 ###
_build_aria2() {
# The Drobo5N toolchain cannot compile Aria2 >= 1.18.0
local VERSION="1.17.1"
local FOLDER="aria2-${VERSION}"
local FILE="${FOLDER}.tar.xz"
local URL="http://sourceforge.net/projects/aria2/files/stable/${FOLDER}/${FILE}"

_download_xz "${FILE}" "${URL}" "${FOLDER}"
pushd "target/${FOLDER}"
PKG_CONFIG_PATH="${DEST}/lib/pkgconfig" \
  XML2_CONFIG="${DEPS}/bin/xml2-config" \
  ./configure --host="${HOST}" --prefix="${DEST}" --mandir="${DEST}/man" \
    --disable-static --enable-libaria2 \
    --with-libz --with-openssl --with-sqlite3 --with-libxml2 --with-libcares \
    --without-libuv --without-appletls --without-gnutls --without-libnettle \
    --without-libgmp --without-libgcrypt --without-libexpat \
    --with-ca-bundle="${DEST}/etc/ssl/certs/ca-certificates.crt"
make
make install
popd
}

### CERTIFICATES ###
_build_certificates() {
# update CA certificates on a Debian/Ubuntu machine:
#sudo update-ca-certificates
cp -vf /etc/ssl/certs/ca-certificates.crt "${DEST}/etc/ssl/certs/"
ln -vfs certs/ca-certificates.crt "${DEST}/etc/ssl/cert.pem"
}

### WEBUI ###
_build_webui() {
local COMMIT="96b882f75ae3809fb01e6a7063383549e798a3d8"
local FOLDER="webui-aria2-${COMMIT}"
local FILE="${FOLDER}.zip"
local URL="https://github.com/ziahamza/webui-aria2/archive/${COMMIT}.zip"

_download_zip "${FILE}" "${URL}" "${FOLDER}"
patch "target/${FOLDER}/js/services/rpc/rpc.js" "src/webui-aria2-rpc-token-warning.patch"
mkdir -p "${DEST}/app"
cp -vfaR "target/${FOLDER}/"* "${DEST}/app/"
}

_build() {
  _build_zlib
  _build_openssl
  _build_sqlite
  _build_libxml2
  _build_cares
  _build_aria2
  _build_certificates
  _build_webui
  _package
}
