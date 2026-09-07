FROM ghcr.io/lambgeo/lambda-gdal:3.8-python3.11

ENV UV_VERSION="0.10.8" \
    NUMPY_VERSION="2.2.6"

WORKDIR /opt
RUN mkdir -p python

RUN yum update -y && yum install -y curl gzip make tar zip && yum clean all

# Build SQLite from source — sqlite3_trace_v2 requires >= 3.14.0
RUN mkdir /tmp/sqlite \
  && curl -sfL https://www.sqlite.org/2026/sqlite-autoconf-3510200.tar.gz | tar zxf - -C /tmp/sqlite --strip-components=1 \
  && cd /tmp/sqlite \
  && CFLAGS="-O2 -Wl,-S -DSQLITE_ENABLE_RTREE=1" CXXFLAGS="-O2 -Wl,-S -DSQLITE_ENABLE_RTREE=1" \
     ./configure --prefix=/opt --disable-static \
  && make -j$(nproc) --silent && make install \
  && rm -rf /tmp/sqlite

# Install uv
RUN curl -LsSf https://astral.sh/uv/install.sh | UV_UNMANAGED_INSTALL="/root/.local/bin" sh
ENV PATH="/root/.local/bin:$PATH"

COPY pyproject.toml uv.lock ./

# Phase 1: install numpy into the system environment so rasterio's build
# system can find it (required because no-build-isolation-package skips
# the isolated build env).
RUN uv pip install --system "numpy==${NUMPY_VERSION}"

# Phase 2: install rasterio from source, linked against the layer's GDAL.
# --no-binary rasterio: force source build (no bundled GDAL wheel)
# --no-build-isolation-package rasterio: use system numpy from phase 1
# --build-constraint: prevent build deps from pulling in numpy 2.3+
RUN uv export --frozen --no-dev -o /tmp/requirements.txt && \
    echo "numpy==${NUMPY_VERSION}" > /tmp/build-constraints.txt && \
    uv pip install --system \
        --no-binary rasterio \
        --no-build-isolation-package rasterio \
        --build-constraint /tmp/build-constraints.txt \
        --target python \
        -r /tmp/requirements.txt

# Remove numpy from target dir — it lives in the numpy layer
RUN rm -rf python/numpy python/numpy.libs

# Precompile and strip __pycache__
RUN python -m compileall -q python/ && \
    find python/ -type d -name '__pycache__' -print0 | xargs -0 rm -rf

# Strip debug symbols
RUN find lib -name '*.so*' -exec strip {} \; && \
    find python/ -name '*.so*' -exec strip {} \;

# Package layer
COPY .lambdaignore .
RUN grep -vE '^\s*#|^\s*$' .lambdaignore | xargs zip -r9q layer.zip python -x && \
    grep -vE '^\s*#|^\s*$' .lambdaignore | xargs zip -r9q --symlinks layer.zip lib/*.so* share -x && \
    zip -r9q --symlinks layer.zip bin/gdal* bin/ogr* bin/geos* bin/nearblack
