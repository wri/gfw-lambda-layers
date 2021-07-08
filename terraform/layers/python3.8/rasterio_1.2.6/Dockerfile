FROM lambgeo/lambda-gdal:3.3-python3.8

ENV RASTERIO_VERSION=1.2.6
ENV PACKAGE_PREFIX=/var/task

# Install some requirements to `/var/task` (using `-t` otpion)
RUN pip install rasterio==${RASTERIO_VERSION} --no-binary :all: -t ${PACKAGE_PREFIX}/

# Reduce size of the C libs
RUN cd $PREFIX && find lib -name \*.so\* -exec strip {} \;

# Create layer.zip
RUN cd $PACKAGE_PREFIX && zip -r9q /opt/layer.zip *
RUN cd $PREFIX && zip -r9q --symlinks /opt/layer.zip lib/*.so* share
RUN cd $PREFIX && zip -r9q --symlinks /opt/layer.zip bin/gdal* bin/ogr* bin/geos* bin/nearblack