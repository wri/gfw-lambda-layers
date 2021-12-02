FROM lambgeo/lambda-gdal:3.2-python3.8

ENV RASTERIO_VERSION=1.2.0

ENV PACKAGE_PREFIX=/opt

# Install some requirements to `/var/task` (using `-t` option)
RUN pip install rasterio==${RASTERIO_VERSION} --no-binary :all: -t ${PACKAGE_PREFIX}/python

# Reduce size of the C libs
RUN cd $PACKAGE_PREFIX && find lib -name \*.so\* -exec strip {} \;

# Create layer.zip
RUN cd $PACKAGE_PREFIX && zip -r9q /opt/layer.zip python
RUN cd $PACKAGE_PREFIX && zip -r9q --symlinks /opt/layer.zip lib/*.so* share
RUN cd $PACKAGE_PREFIX && zip -r9q --symlinks /opt/layer.zip bin/gdal* bin/ogr* bin/geos* bin/nearblack