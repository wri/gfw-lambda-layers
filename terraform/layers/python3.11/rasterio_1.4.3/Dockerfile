FROM ghcr.io/lambgeo/lambda-gdal:3.8-python3.11

ENV NUMPY_VERSION=2.2.6 \
    RASTERIO_VERSION=1.4.3

WORKDIR /opt
RUN mkdir -p python

RUN yum install -y gzip make tar zip && yum clean all

# Build SQLite from source — sqlite3_trace_v2 requires >= 3.14.0
RUN mkdir /tmp/sqlite \
  && curl -sfL https://www.sqlite.org/2026/sqlite-autoconf-3510200.tar.gz | tar zxf - -C /tmp/sqlite --strip-components=1 \
  && cd /tmp/sqlite \
  && CFLAGS="-O2 -Wl,-S -DSQLITE_ENABLE_RTREE=1" CXXFLAGS="-O2 -Wl,-S -DSQLITE_ENABLE_RTREE=1" \
     ./configure --prefix=/opt --disable-static \
  && make -j$(nproc) --silent && make install \
  && rm -rf /tmp/sqlite

# Install rasterio from source so it links against the layer's GDAL
# rather than pulling in its own bundled subset
RUN pip install --root-user-action=ignore --upgrade pip setuptools && \
    pip install --root-user-action=ignore \
      numpy==${NUMPY_VERSION} \
      rasterio==${RASTERIO_VERSION} \
      --no-binary rasterio \
      -t python

# Precompile all Python source and strip __pycache__ dirs
RUN python -m compileall -q python/ && \
    find python/ -type d -name '__pycache__' -print0 | xargs -0 rm -rf

# Strip debug symbols from native libs (both system and Python extensions)
RUN find lib -name '*.so*' -exec strip {} \; && \
    find python/ -name '*.so*' -exec strip {} \;

# Compress all files except those listed in .lambdaignore
COPY .lambdaignore .
RUN cat .lambdaignore | xargs zip -r9q layer.zip python -x && \
    cat .lambdaignore | xargs zip -r9q --symlinks layer.zip lib/*.so* share -x && \
    zip -r9q --symlinks layer.zip bin/gdal* bin/ogr* bin/geos* bin/nearblack \
