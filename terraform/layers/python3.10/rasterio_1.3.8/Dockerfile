FROM ghcr.io/lambgeo/lambda-gdal:3.6-python3.10

ENV RASTERIO_VERSION=1.3.8

WORKDIR /opt
RUN mkdir -p python

# Install rasterio from source because the binary pulls in its own GDAL
# subset, and we already have it. Otherwise install binary packages,
# because they tend to be smaller than those you build yourself.
RUN pip install rasterio==${RASTERIO_VERSION} --no-binary rasterio -t python

# Reduce size of the C libs
# TODO: Try stripping bin as well?
RUN find lib -name \*.so\* -exec strip {} \;

# Compress all source codes except files listed in .lambdaignore
RUN yum install -y zip
COPY .lambdaignore .
RUN cat .lambdaignore | xargs zip -r9q layer.zip python -x && \
    cat .lambdaignore | xargs zip -r9q --symlinks layer.zip lib/*.so* share -x && \
    zip -r9q --symlinks layer.zip bin/gdal* bin/ogr* bin/geos* bin/nearblack