FROM public.ecr.aws/lambda/python:3.11

ENV GEOPANDAS_VERSION="1.1.2" \
    NUMPY_VERSION="2.2.6" \
    SHAPELY_VERSION="2.1.2" \
    PANDAS_VERSION="2.3.3"

RUN yum update && yum install -y zip binutils && yum clean all

WORKDIR /opt
RUN mkdir -p python

RUN pip install --root-user-action=ignore --upgrade pip && \
    pip install --root-user-action=ignore \
      --only-binary pyproj,shapely,fiona \
      --no-binary geopandas \
      geopandas==${GEOPANDAS_VERSION} \
      numpy==${NUMPY_VERSION} \
      shapely==${SHAPELY_VERSION} \
      pandas==${PANDAS_VERSION} \
      -t python

# Remove packages that live in their own layers
RUN rm -rf python/numpy \
           python/numpy.libs \
           python/pandas \
           python/pandas.libs \
           python/shapely \
           python/shapely.libs

# Precompile, remove cache dirs to shrink the layer
RUN python -m compileall -q python/ && \
    find python/ -type d -name '__pycache__' -print0 | xargs -0 rm -rf

# Don't try to strip debug symbols, it's a world of hurt due to non-standard ELF alignment that strip corrupts

COPY .lambdaignore .
RUN grep -vE '^\s*#|^\s*$' .lambdaignore | xargs zip -9qyr layer.zip python -x
