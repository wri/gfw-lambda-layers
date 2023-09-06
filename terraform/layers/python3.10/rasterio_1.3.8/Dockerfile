FROM ghcr.io/lambgeo/lambda-gdal:3.6-python3.10

ENV RASTERIO_VERSION=1.3.8

ENV PACKAGE_PREFIX=/opt

# Install rasterio from source because the binary pulls in its own GDAL
# subset, and we already have it. Otherwise install binary packages,
# because they tend to be smaller than those you build yourself.
RUN pip install rasterio==${RASTERIO_VERSION} --no-binary rasterio -t ${PACKAGE_PREFIX}/python

# Reduce size of the C libs
RUN cd $PACKAGE_PREFIX && find lib -name \*.so\* -exec strip {} \;

RUN yum install -y zip

# Create layer.zip
RUN cd $PACKAGE_PREFIX && \
    zip -r9q /opt/layer.zip python && \
    zip -r9q --symlinks /opt/layer.zip lib/*.so* share && \
    zip -r9q --symlinks /opt/layer.zip bin/gdal* bin/ogr* bin/geos* bin/nearblack