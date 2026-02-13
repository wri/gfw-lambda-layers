FROM public.ecr.aws/lambda/python:3.13

ENV NUMPY_VERSION="2.4.2"
ENV SHAPELY_VERSION="2.1.2"
ENV PANDAS_VERSION="2.3.3"
ENV GEOPANDAS_VERSION="1.1.2"

WORKDIR /opt
RUN mkdir -p python

RUN dnf update -y && \
    dnf install -y zip findutils

RUN pip install \
    "numpy==${NUMPY_VERSION}" \
    "shapely==${SHAPELY_VERSION}" \
    "pandas==${PANDAS_VERSION}" \
    "geopandas==${GEOPANDAS_VERSION}" \
    -t python

# Precompile all python packages and remove .py files
RUN python -m compileall .
RUN find python/ -type f -name '*.pyc' | while read f; do n=$(echo $f | sed 's/__pycache__\///' | sed 's/.cpython-313//'); cp $f $n; done;
RUN find python/ -type d -a -name '__pycache__' -print0 | xargs -0 rm -rf
RUN find python/ -type f -a -name '*.py' -print0 | xargs -0 rm -f

# Compress all source code except those files listed in .lambdaignore
COPY .lambdaignore .
RUN cat .lambdaignore | xargs zip -9qyr layer.zip python -x
