FROM public.ecr.aws/lambda/python:3.11

ENV NUMPY_VERSION="1.26.4"
ENV SHAPELY_VERSION="1.8.5.post1"
ENV PANDAS_VERSION="1.5.3"
ENV GEOPANDAS_VERSION="0.14.4"

WORKDIR /opt
RUN mkdir -p python

RUN yum update && yum install -y binutils zip && yum clean all

RUN pip install --root-user-action=ignore \
    "numpy==${NUMPY_VERSION}" \
    "shapely==${SHAPELY_VERSION}" \
    "pandas==${PANDAS_VERSION}" \
    "geopandas==${GEOPANDAS_VERSION}" \
    -t python

# Precompile all Python source and strip __pycache__ dirs
RUN python -m compileall -q python/ && \
    find python/ -type d -name '__pycache__' -print0 | xargs -0 rm -rf

# Strip debug symbols from native libs (both system and Python extensions)
RUN find lib -name '*.so*' -exec strip {} \; && \
    find python/ -name '*.so*' -exec strip {} \;

# Compress all source codes except files listed in .lambdaignore
COPY .lambdaignore .
RUN zip -9qyr layer.zip python -x@.lambdaignore
