FROM ghcr.io/lambgeo/lambda-gdal:3.8-python3.10

ENV NUMPY_VERSION=1.26.4
ENV RASTERIO_VERSION=1.4.3

WORKDIR /opt
RUN mkdir -p python

RUN yum install -y gzip make tar zip

# Build SQLite from source with the symbols we need
# sqlite3_trace_v2 was added in SQLite 3.14.0, so we use a modern version
RUN mkdir /tmp/sqlite \
  && curl -sfL https://www.sqlite.org/2026/sqlite-autoconf-3510200.tar.gz | tar zxf - -C /tmp/sqlite --strip-components=1 \
  && cd /tmp/sqlite \
  && CFLAGS="-O2 -Wl,-S -DSQLITE_ENABLE_RTREE=1" CXXFLAGS="-O2 -Wl,-S -DSQLITE_ENABLE_RTREE=1" ./configure --prefix=/opt --disable-static \
  && make -j $(nproc) --silent && make install && make clean \
  && rm -rf /tmp/sqlite

# Install rasterio from source because the binary pulls in its own GDAL
# subset, and we already have it. Otherwise install binary packages,
# because they tend to be smaller than those you build yourself.
RUN pip install --root-user-action=ignore --upgrade pip setuptools
RUN pip install --root-user-action=ignore NumPy==${NUMPY_VERSION} rasterio==${RASTERIO_VERSION} --no-binary rasterio -t python

# Precompile all python packages and remove .py files
RUN find python/ -type f -name '*.pyc' | while read f; do n=$(echo $f | sed 's/__pycache__\///' | sed 's/.cpython-310//'); cp $f $n; done;
RUN find python/ -type d -a -name '__pycache__' -print0 | xargs -0 rm -rf

# Reduce size of the C libs
# TODO: Try stripping bin as well?
RUN find lib -name \*.so\* -exec strip {} \;

# Compress all source codes except files listed in .lambdaignore
COPY .lambdaignore .
RUN cat .lambdaignore | xargs zip -r9q layer.zip python -x && \
    cat .lambdaignore | xargs zip -r9q --symlinks layer.zip lib/*.so* share -x && \
    zip -r9q --symlinks layer.zip bin/gdal* bin/ogr* bin/geos* bin/nearblack
