FROM public.ecr.aws/lambda/provided:al2023 AS base

RUN --mount=type=cache,target=/var/cache/dnf \
    dnf update -y && \
    dnf install -y \
      autoconf libtool flex bison cmake make \
      tar gzip gcc gcc-c++ automake nasm \
      libxml2-devel openssl-devel curl-devel glibc-langpack-en && \
    dnf clean all

ENV LOCALE="en_US.UTF-8"
ENV LANGUAGE=${LOCALE} LC_ALL=${LOCALE} LANG=${LOCALE} LC_CTYPE=${LOCALE}

ENV PREFIX=/opt
ENV PKG_CONFIG_PATH=${PREFIX}/lib/pkgconfig/ \
    LD_LIBRARY_PATH=${PREFIX}/lib \
    PATH=${PREFIX}/bin:${PATH}

WORKDIR /tmp


# ────────────────────────────────────────────────────────────────────────────────
# STAGE: foundational libs that many others depend on (built serially in one
#        stage so downstream parallel stages can all inherit from here)
# ────────────────────────────────────────────────────────────────────────────────
FROM base AS foundations

# pkg-config
RUN mkdir pkg-config \
  && curl -sfL https://pkg-config.freedesktop.org/releases/pkg-config-0.29.2.tar.gz | tar zxf - -C pkg-config --strip-components=1 \
  && cd pkg-config \
  && CFLAGS="-O2 -Wl,-S" ./configure --prefix=${PREFIX} --with-internal-glib \
  && make -j$(nproc) --silent && make install \
  && rm -rf pkg-config

# sqlite (needed by proj, gdal)
RUN mkdir sqlite \
  && curl -sfL https://www.sqlite.org/2026/sqlite-autoconf-3510200.tar.gz | tar zxf - -C sqlite --strip-components=1 \
  && cd sqlite \
  && CFLAGS="-O2 -Wl,-S -DSQLITE_ENABLE_RTREE=1" CXXFLAGS="-O2 -Wl,-S -DSQLITE_ENABLE_RTREE=1" \
     ./configure --prefix=${PREFIX} --disable-static \
  && make -j$(nproc) --silent && make install \
  && rm -rf sqlite

# libexpat (needed by gdal)
RUN mkdir libexpat \
  && curl -sfL https://github.com/libexpat/libexpat/releases/download/R_2_7_4/expat-2.7.4.tar.gz | tar zxf - -C libexpat --strip-components=1 \
  && cd libexpat \
  && CFLAGS="-O2 -Wl,-S" CXXFLAGS="-O2 -Wl,-S" ./configure --prefix=${PREFIX} --disable-static \
  && make -j$(nproc) --silent && make install \
  && rm -rf libexpat

# nghttp2 (needed by curl)
RUN mkdir nghttp2 \
  && curl -sfL https://github.com/nghttp2/nghttp2/releases/download/v1.68.0/nghttp2-1.68.0.tar.gz | tar zxf - -C nghttp2 --strip-components=1 \
  && cd nghttp2 \
  && ./configure --enable-lib-only --prefix=${PREFIX} \
  && make -j$(nproc) --silent && make install \
  && rm -rf nghttp2

# libcurl (updated from ancient 7.73.0)
RUN mkdir libcurl \
  && curl -sfL https://curl.se/download/curl-8.12.1.tar.gz | tar zxf - -C libcurl --strip-components=1 \
  && cd libcurl \
  && ./configure --disable-manual --disable-cookies --with-nghttp2=${PREFIX} --prefix=${PREFIX} \
  && make -j$(nproc) --silent && make install \
  && rm -rf libcurl

# zstd (needed by blosc, libtiff, gdal)
RUN mkdir zstd \
  && curl -sfL https://github.com/facebook/zstd/archive/v1.5.7.tar.gz | tar zxf - -C zstd --strip-components=1 \
  && cd zstd \
  && make -j$(nproc) PREFIX=${PREFIX} ZSTD_LEGACY_SUPPORT=0 CFLAGS=-O1 --silent \
  && make install PREFIX=${PREFIX} ZSTD_LEGACY_SUPPORT=0 CFLAGS=-O1 \
  && rm -rf zstd

# libjpeg-turbo (needed by libtiff, openjpeg, gdal)
RUN mkdir jpeg \
  && curl -sfL https://github.com/libjpeg-turbo/libjpeg-turbo/archive/3.1.0.tar.gz | tar zxf - -C jpeg --strip-components=1 \
  && cd jpeg && mkdir build && cd build \
  && cmake .. \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX:PATH=${PREFIX} \
    -DCMAKE_INSTALL_LIBDIR:PATH=lib \
    -DCMAKE_C_FLAGS="-O2 -Wl,-S" \
    -DCMAKE_CXX_FLAGS="-O2 -Wl,-S" \
  && make -j$(nproc) --silent && make install \
  && rm -rf jpeg

# libpng (needed by gdal)
RUN mkdir png \
  && curl -sfL https://github.com/glennrp/libpng/archive/v1.6.47.tar.gz | tar zxf - -C png --strip-components=1 \
  && cd png \
  && CFLAGS="-O2 -Wl,-S" CXXFLAGS="-O2 -Wl,-S" ./configure --prefix=${PREFIX} \
  && make -j$(nproc) --silent && make install \
  && rm -rf png

# libdeflate (needed by libtiff)
RUN mkdir libdeflate \
  && curl -sfL https://github.com/ebiggers/libdeflate/archive/v1.23.tar.gz | tar zxf - -C libdeflate --strip-components=1 \
  && cd libdeflate && mkdir build && cd build \
  && cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=${PREFIX} -DCMAKE_INSTALL_LIBDIR=lib \
  && make -j$(nproc) --silent && make install \
  && rm -rf libdeflate

# lerc (needed by libtiff for its LERC TIFF codec; GDAL now builds LERC internally)
RUN mkdir lerc \
  && curl -sfL https://github.com/Esri/lerc/archive/v4.0.4.tar.gz | tar zxf - -C lerc --strip-components=1 \
  && cd lerc \
  && cmake . \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX:PATH=${PREFIX} \
    -DCMAKE_INSTALL_LIBDIR:PATH=lib \
    -DCMAKE_C_FLAGS="-O2 -Wl,-S" \
    -DCMAKE_CXX_FLAGS="-O2 -Wl,-S" \
  && make -j$(nproc) --silent && make install \
  && rm -rf lerc

# libtiff (needed by gdal)
RUN mkdir libtiff \
  && curl -sfL https://download.osgeo.org/libtiff/tiff-4.7.0.tar.gz | tar zxf - -C libtiff --strip-components=1 \
  && cd libtiff \
  && LDFLAGS="-Wl,-rpath,'\$\$ORIGIN'" CFLAGS="-O2 -Wl,-S" CXXFLAGS="-O2 -Wl,-S" ./configure \
    --prefix=${PREFIX} \
    --disable-static \
    --enable-rpath \
    --with-lerc-lib-dir=${PREFIX}/lib \
    --with-lerc-include-dir=${PREFIX}/include \
    --with-libdeflate-lib-dir=${PREFIX}/lib \
    --with-libdeflate-include-dir=${PREFIX}/include \
    --with-jpeg-lib-dir=${PREFIX}/lib \
    --with-jpeg-include-dir=${PREFIX}/include \
  && make -j$(nproc) --silent && make install \
  && rm -rf libtiff

# webp (needed by gdal)
RUN mkdir webp \
  && curl -sfL https://storage.googleapis.com/downloads.webmproject.org/releases/webp/libwebp-1.5.0.tar.gz | tar zxf - -C webp --strip-components=1 \
  && cd webp \
  && CFLAGS="-O2 -Wl,-S" ./configure --prefix=${PREFIX} \
  && make -j$(nproc) --silent && make install \
  && rm -rf webp

# blosc (needed by zarr/gdal)
RUN mkdir blosc \
  && curl -sfL https://github.com/Blosc/c-blosc/archive/refs/tags/v1.21.6.tar.gz | tar zxf - -C blosc --strip-components=1 \
  && cd blosc \
  && cmake -G"Unix Makefiles" \
    -DCMAKE_INSTALL_PREFIX:PATH=${PREFIX} \
    -DCMAKE_INSTALL_LIBDIR:PATH=lib \
    -DCMAKE_INSTALL_RPATH="$ORIGIN" \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_C_FLAGS="-O2 -Wl,-S" \
    -DCMAKE_CXX_FLAGS="-O2 -Wl,-S" \
    -DBUILD_SHARED=ON \
    -DBUILD_STATIC=OFF \
    -DBUILD_BENCHMARKS=OFF \
    -DBUILD_FUZZERS=OFF \
    -DBUILD_TESTS=OFF \
    -DPREFER_EXTERNAL_LZ4=ON \
    -DPREFER_EXTERNAL_ZLIB=ON \
    -DPREFER_EXTERNAL_ZSTD=ON \
    -DDEACTIVATE_SNAPPY=OFF . \
  && make -j$(nproc) --silent && make install \
  && rm -rf blosc

# cryptopp (needed by gdal for GCS access)
RUN mkdir cryptopp \
  && curl -sfL https://github.com/weidai11/cryptopp/archive/refs/tags/CRYPTOPP_8_9_0.tar.gz | tar zxf - -C cryptopp --strip-components=1 \
  && cd cryptopp \
  && make -j$(nproc) --silent && make install PREFIX=${PREFIX} \
  && rm -rf cryptopp

# brotli (HTTP compression, used by curl/gdal)
RUN mkdir brotli \
  && curl -sfL https://github.com/google/brotli/archive/refs/tags/v1.1.0.tar.gz | tar zxf - -C brotli --strip-components=1 \
  && cd brotli && mkdir build && cd build \
  && cmake .. \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=${PREFIX} \
    -DCMAKE_INSTALL_LIBDIR=lib \
    -DCMAKE_C_FLAGS="-O2 -Wl,-S" \
    -DCMAKE_CXX_FLAGS="-O2 -Wl,-S" \
  && cmake --build . -j$(nproc) \
  && cmake --build . --target install \
  && rm -rf brotli

# libpq only (needed by gdal for PostGIS — no need for the full server)
RUN mkdir postgres \
  && curl -sfL https://ftp.postgresql.org/pub/source/v17.4/postgresql-17.4.tar.gz | tar zxf - -C postgres --strip-components=1 \
  && cd postgres \
  && CFLAGS="-O2 -Wl,-S" CXXFLAGS="-O2 -Wl,-S" ./configure \
    --prefix=${PREFIX} \
    --with-openssl \
    --without-readline \
    --without-icu \
    --without-ldap \
    --without-gssapi \
    --without-pam \
    --without-systemd \
    --without-zlib \
  && make -j$(nproc) --silent -C src/interfaces/libpq \
  && make install -C src/interfaces/libpq \
  && make -j$(nproc) --silent -C src/bin/pg_config \
  && make install -C src/bin/pg_config \
  && make install -C src/include \
  && rm -rf postgres


# ────────────────────────────────────────────────────────────────────────────────
# PARALLEL STAGE A: geos (no deps on proj/geotiff)
# ────────────────────────────────────────────────────────────────────────────────
FROM foundations AS build-geos

RUN mkdir /tmp/geos \
  && curl -sfL https://github.com/libgeos/geos/archive/refs/tags/3.13.1.tar.gz | tar zxf - -C /tmp/geos --strip-components=1 \
  && cd /tmp/geos && mkdir build && cd build \
  && cmake .. \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX:PATH=${PREFIX} \
    -DCMAKE_INSTALL_LIBDIR:PATH=lib \
    -DCMAKE_C_FLAGS="-O2 -Wl,-S" \
    -DCMAKE_CXX_FLAGS="-O2 -Wl,-S" \
  && make -j$(nproc) --silent && make install \
  && rm -rf /tmp/geos


# ────────────────────────────────────────────────────────────────────────────────
# PARALLEL STAGE B: proj (depends on sqlite, curl — both in foundations)
# ────────────────────────────────────────────────────────────────────────────────
FROM foundations AS build-proj

RUN mkdir /tmp/proj \
  && curl -sfL https://github.com/OSGeo/proj/archive/9.5.1.tar.gz | tar zxf - -C /tmp/proj --strip-components=1 \
  && cd /tmp/proj && mkdir build && cd build \
  && cmake .. \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX:PATH=${PREFIX} \
    -DCMAKE_INSTALL_LIBDIR:PATH=lib \
    -DCMAKE_INSTALL_INCLUDEDIR:PATH=include \
    -DBUILD_TESTING=OFF \
    -DCMAKE_C_FLAGS="-O2 -Wl,-S" \
    -DCMAKE_CXX_FLAGS="-O2 -Wl,-S" \
  && make -j$(nproc) --silent && make install \
  && rm -rf /tmp/proj


# ────────────────────────────────────────────────────────────────────────────────
# PARALLEL STAGE C: openjpeg (depends on libjpeg, libpng, zstd — all foundations)
# ────────────────────────────────────────────────────────────────────────────────
FROM foundations AS build-openjpeg

RUN mkdir /tmp/openjpeg \
  && curl -sfL https://github.com/uclouvain/openjpeg/archive/v2.5.3.tar.gz | tar zxf - -C /tmp/openjpeg --strip-components=1 \
  && cd /tmp/openjpeg && mkdir build && cd build \
  && cmake .. \
    -DBUILD_THIRDPARTY:BOOL=ON \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX:PATH=${PREFIX} \
    -DCMAKE_INSTALL_LIBDIR:PATH=lib \
    -DCMAKE_C_FLAGS="-O2 -Wl,-S" \
    -DCMAKE_CXX_FLAGS="-O2 -Wl,-S" \
  && make -j$(nproc) --silent && make install \
  && rm -rf /tmp/openjpeg


# ────────────────────────────────────────────────────────────────────────────────
# STAGE: GDAL — depends on everything
# ────────────────────────────────────────────────────────────────────────────────
FROM foundations AS build-gdal

# Merge all parallel build outputs
COPY --from=build-geos    ${PREFIX}/lib/     ${PREFIX}/lib/
COPY --from=build-geos    ${PREFIX}/include/ ${PREFIX}/include/
COPY --from=build-geos    ${PREFIX}/bin/     ${PREFIX}/bin/

COPY --from=build-proj    ${PREFIX}/lib/     ${PREFIX}/lib/
COPY --from=build-proj    ${PREFIX}/include/ ${PREFIX}/include/
COPY --from=build-proj    ${PREFIX}/bin/     ${PREFIX}/bin/
COPY --from=build-proj    ${PREFIX}/share/   ${PREFIX}/share/

COPY --from=build-openjpeg ${PREFIX}/lib/     ${PREFIX}/lib/
COPY --from=build-openjpeg ${PREFIX}/include/ ${PREFIX}/include/

RUN mkdir /tmp/gdal \
  && curl -sfL https://github.com/OSGeo/gdal/archive/refs/tags/v3.12.4.tar.gz | tar zxf - -C /tmp/gdal --strip-components=1 \
  && cd /tmp/gdal && mkdir build && cd build \
  && cmake .. \
    -DGDAL_USE_EXTERNAL_LIBS=ON \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX:PATH=${PREFIX} \
    -DCMAKE_INSTALL_LIBDIR:PATH=lib \
    -DCMAKE_C_FLAGS="-O2 -Wl,-S" \
    -DCMAKE_CXX_FLAGS="-O2 -Wl,-S" \
    -DGDAL_SET_INSTALL_RELATIVE_RPATH=ON \
    -DGDAL_USE_TIFF_INTERNAL=OFF \
    -DGDAL_USE_GEOTIFF_INTERNAL=ON \
    -DGDAL_USE_LERC_INTERNAL=ON \
    -DGDAL_USE_HDF4=OFF \
    -DGDAL_USE_HDF5=OFF \
    -DGDAL_USE_NETCDF=OFF \
    -DPNG_PNG_INCLUDE_DIR=${PREFIX}/include \
    -DPNG_LIBRARY_RELEASE=${PREFIX}/lib/libpng.so \
    -DBUILD_PYTHON_BINDINGS=OFF \
  && cmake --build . -j$(nproc) \
  && cmake --build . --target install \
  && rm -rf /tmp/gdal


# ────────────────────────────────────────────────────────────────────────────────
# STAGE: patchelf + Python — run in parallel with GDAL build
# ────────────────────────────────────────────────────────────────────────────────
FROM foundations AS build-python

# patchelf
RUN mkdir /tmp/patchelf \
  && curl -sfL https://github.com/NixOS/patchelf/archive/0.18.0.tar.gz | tar zxf - -C /tmp/patchelf --strip-components=1 \
  && cd /tmp/patchelf && ./bootstrap.sh && ./configure \
  && make -j$(nproc) --silent && make install \
  && rm -rf /tmp/patchelf

ENV USR_LOCAL_BIN="/usr/local/bin"
ENV UV_LINK_MODE=copy \
    UV_COMPILE_BYTECODE=1 \
    UV_UNMANAGED_INSTALL=${USR_LOCAL_BIN} \
    PATH=${USR_LOCAL_BIN}:${PATH}

RUN curl -LsSf https://github.com/astral-sh/uv/releases/download/0.12.5/uv-installer.sh | sh && \
    uv pip install \
      numpy==2.2.6 \
      rasterio==1.5.1 \
      --no-binary rasterio \
      -p 3.12 \
      -t ${PREFIX}/python


# ────────────────────────────────────────────────────────────────────────────────
# FINAL ASSEMBLY STAGE
# ────────────────────────────────────────────────────────────────────────────────
FROM public.ecr.aws/lambda/provided:al2023 AS runner

RUN --mount=type=cache,target=/var/cache/dnf \
    dnf update -y && dnf install -y findutils zip && dnf clean all

ENV PREFIX=/opt
WORKDIR ${PREFIX}

COPY --from=build-gdal   ${PREFIX}/lib/     ${PREFIX}/lib/
COPY --from=build-gdal   ${PREFIX}/include/ ${PREFIX}/include/
COPY --from=build-gdal   ${PREFIX}/share/   ${PREFIX}/share/
COPY --from=build-gdal   ${PREFIX}/bin/     ${PREFIX}/bin/
COPY --from=build-python ${PREFIX}/python/  ${PREFIX}/python/

# patchelf is in /usr/local/bin in build-python stage
COPY --from=build-python /usr/local/bin/patchelf /usr/local/bin/patchelf

# Clean up libs not used by GDAL
RUN rm -f ${PREFIX}/lib/libturbojpeg.so* \
          ${PREFIX}/lib/libwebpmux.so* \
          ${PREFIX}/lib/libwebpdemux.so* \
          ${PREFIX}/lib/libwebpdecoder.so*

# Fix RPATHs so libs are found relative to their location at runtime
RUN for i in ${PREFIX}/bin/*;     do patchelf --force-rpath --set-rpath '$ORIGIN/../lib' "$i"; done && \
    for i in ${PREFIX}/lib/*.so*; do patchelf --force-rpath --set-rpath '$ORIGIN'        "$i" 2>/dev/null || true; done

ENV GDAL_DATA=${PREFIX}/share/gdal \
    PROJ_LIB=${PREFIX}/share/proj \
    GDAL_CONFIG=${PREFIX}/bin/gdal-config \
    GEOS_CONFIG=${PREFIX}/bin/geos-config \
    PATH=${PREFIX}/bin:${PATH}

# Compress all files except those listed in .lambdaignore
COPY .lambdaignore .
RUN cat .lambdaignore | xargs zip -r9q layer.zip python -x && \
    cat .lambdaignore | xargs zip -r9q --symlinks layer.zip lib/*.so* share -x && \
    zip -r9q --symlinks layer.zip bin/gdal* bin/ogr* bin/geos* bin/nearblack
