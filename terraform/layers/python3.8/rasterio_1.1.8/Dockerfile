FROM amazonlinux:2

ENV PYTHON_VERSION=3.8.6
ENV PROJ_VERSION=6.3.2
ENV GDAL_VERSION=3.2.0
ENV RASTERIO_VERSION=1.1.6

# install build tools and dependencies available via yum
RUN yum install -y gcc gcc-c++ make libtool file gzip zip wget openssl-devel libffi-devel \
    && yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm \
    && yum install -y netcdf-devel hdf5-devel \

# create folders for deployment package
RUN mkdir /opt/python \
    && mkdir /opt/lib \
    && mkdir /opt/lib/data

ENV PKG_CONFIG_PATH=/usr/local/lib/pkgconfig

# install python and pip
RUN wget https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz \
    && tar xzf Python-${PYTHON_VERSION}.tgz \
    && cd Python-${PYTHON_VERSION} \
    && ./configure \
    && make -j $(nproc) \
    && make install \
    && cd ..

# install sqlite
RUN wget https://www.sqlite.org/snapshot/sqlite-snapshot-202002181949.tar.gz \
    && tar xvzf sqlite-snapshot-202002181949.tar.gz \
    && cd sqlite-snapshot-202002181949 \
    && ./configure \
    && make -j $(nproc) \
    && make install \
    && cd ..

# install proj
RUN wget https://github.com/OSGeo/PROJ/releases/download/${PROJ_VERSION}/proj-${PROJ_VERSION}.tar.gz \
    && tar xvzf proj-${PROJ_VERSION}.tar.gz \
    && cd proj-${PROJ_VERSION} \
    && ./configure --datarootdir=/opt/lib/data \
    && make -j $(nproc) \
    && make install \
    && cd ..

# install gdal
RUN wget https://github.com/OSGeo/gdal/releases/download/v${GDAL_VERSION}/gdal-${GDAL_VERSION}.tar.gz \
    && tar xvzf gdal-${GDAL_VERSION}.tar.gz \
    && cd gdal-${GDAL_VERSION} \
    && ./configure --with-proj --datarootdir=/opt/lib/data > /opt/configure.txt \
    && make -j $(nproc) \
    && make install \
    && cd ../..

# copy libraries into deployment package
RUN cp /usr/local/lib/libgdal.so.28 /opt/lib/ \
    && cp /usr/local/lib/libproj.so.15 /opt/lib/ \
    && cp /usr/local/lib/libsqlite3.so.0 /opt/lib/ \
    && cp /usr/lib64/libnetcdf.so.7 /opt/lib/ \
    && cp /usr/lib64/libhdf5.so.8 /opt/lib/ \
    && cp /usr/lib64/libhdf5_hl.so.8 /opt/lib/ \
    && cp /usr/lib64/libsz.so.2 /opt/lib/ \
    && cp /usr/lib64/libaec.so.0 /opt/lib/ \
    && cp /usr/lib64/libcurl.so.4 /opt/lib/ \
    && cp /usr/lib64/libjpeg.so.62 /opt/lib/ \
    && cp /usr/lib64/libnghttp2.so.14 /opt/lib/ \
    && cp /usr/lib64/libidn2.so.0 /opt/lib/ \
    && cp /usr/lib64/libssh2.so.1 /opt/lib/ \
    && cp /usr/lib64/libldap-2.4.so.2 /opt/lib/ \
    && cp /usr/lib64/liblber-2.4.so.2 /opt/lib/ \
    && cp /usr/lib64/libunistring.so.0 /opt/lib/ \
    && cp /usr/lib64/libsasl2.so.3 /opt/lib/ \
    && cp /usr/lib64/libssl3.so /opt/lib/ \
    && cp /usr/lib64/libsmime3.so /opt/lib/ \
    && cp /usr/lib64/libnss3.so /opt/lib/ \
    && strip /opt/lib/*.so*

# install rasterio python bindings into deployment package
RUN pip3 install -t /opt/python/ rasterio[s3]==${RASTERIO_VERSION}

# FIXME: somehow this creates syntax error messages and fails. Mainly for numpy modules
#Precompile all python packages and remove .py files
#RUN python -m compileall /opt/python
#RUN find python/ -type f -name '*.pyc' | while read f; do n=$(echo $f | sed 's/__pycache__\///' | sed 's/.cpython-38//'); cp $f $n; done;
#RUN find python/ -type d -a -name '__pycache__' -print0 | xargs -0 rm -rf
#RUN find python/ -type f -a -name '*.py' -print0 | xargs -0 rm -f

# zip and deploy package
RUN cd /opt \
    && zip -r layer.zip *

CMD ["/bin/bash"]