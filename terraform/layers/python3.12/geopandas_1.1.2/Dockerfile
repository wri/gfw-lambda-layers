FROM public.ecr.aws/lambda/python:3.12

ENV NUMPY_VERSION="2.2.6"
ENV SHAPELY_VERSION="2.1.2"
ENV PANDAS_VERSION="2.3.2"
ENV GEOPANDAS_VERSION="1.1.2"

WORKDIR /opt
RUN mkdir -p python

RUN dnf update -y && \
    dnf install -y zip findutils

RUN pip install --root-user-action=ignore \
    --only-binary pyproj,shapely,fiona \
    --no-binary geopandas \
    "numpy==${NUMPY_VERSION}" \
    "shapely==${SHAPELY_VERSION}" \
    "pandas==${PANDAS_VERSION}" \
    "geopandas==${GEOPANDAS_VERSION}" \
    -t python

# Remove packages that live in their own layers
RUN rm -rf python/numpy \
    python/numpy.libs \
    python/pandas \
    python/pandas.libs \
    python/shapely \
    python/shapely.libs \
    python/pyproj \
    python/pyproj.libs

# Precompile, remove cache dirs to shrink the layer
RUN python -m compileall -q python/ && \
    find python/ -type d -name '__pycache__' -print0 | xargs -0 rm -rf

# Don't try to strip debug symbols, it's a world of hurt due to non-standard ELF alignment that strip corrupts

COPY .lambdaignore .
RUN grep -vE '^\s*#|^\s*$' .lambdaignore | xargs zip -9qyr layer.zip python -x
