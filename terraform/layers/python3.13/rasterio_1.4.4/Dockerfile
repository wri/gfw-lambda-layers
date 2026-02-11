FROM public.ecr.aws/lambda/python:3.13

ENV GDAL_VERSION="3.12.2"
ENV NUMPY_VERSION="2.4.2"
ENV RASTERIO_VERSION="1.4.4"

SHELL ["/bin/bash", "-c"]

ENV PREFIX=/opt
WORKDIR /opt
RUN mkdir -p python

RUN dnf update -y && \
    dnf install -y expat-devel gcc gcc-c++ wget cmake proj-devel sqlite-devel tar libcurl-devel libtiff-devel libpng-devel libjpeg-devel libxml2-devel zlib-devel pkgconfig findutils zip && \
    dnf clean all

# Build gdal from source
RUN mkdir -p /tmp/gdal \
  && curl -sfL https://github.com/OSGeo/gdal/archive/refs/tags/v${GDAL_VERSION}.tar.gz | tar zxf - -C /tmp/gdal --strip-components=1 \
  && cd /tmp/gdal \
  && mkdir build \
  && cd build \
  && cmake3 .. \
    -DGDAL_USE_EXTERNAL_LIBS=ON \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX:PATH=${PREFIX} \
    -DCMAKE_INSTALL_LIBDIR:PATH=lib \
    -DCMAKE_C_FLAGS="-O2 -Wl,-S" \
    -DCMAKE_CXX_FLAGS="-O2 -Wl,-S" \
    -DGDAL_SET_INSTALL_RELATIVE_RPATH=ON \
    -DGDAL_USE_TIFF_INTERNAL=OFF \
    -DGDAL_USE_GEOTIFF_INTERNAL=OFF \
    -DGDAL_USE_LERC_INTERNAL=OFF \
    -DBUILD_PYTHON_BINDINGS=OFF \
  && make -j $(nproc) --silent \
  && make install \
  && rm -rf /tmp/gdal

# Build rasterio from source because the binary pulls in its own GDAL
# subset, and we already have it. Otherwise install binary packages,
# because they tend to be smaller than those you build yourself.
 RUN pip install NumPy==${NUMPY_VERSION} rasterio==${RASTERIO_VERSION} --no-binary rasterio -t /opt/python

# Reduce size of the C libs
# TODO: Try stripping bin as well?
RUN cd /opt && \
    find lib -name \*.so\* -exec strip {} \;

# Compress all files except those listed in .lambdaignore
COPY .lambdaignore .
RUN cat .lambdaignore | xargs zip -r9q layer.zip python -x && \
    cat .lambdaignore | xargs zip -r9q --symlinks layer.zip lib/*.so* share -x && \
    zip -r9q --symlinks layer.zip bin/gdal* bin/ogr* bin/geos* bin/nearblack
