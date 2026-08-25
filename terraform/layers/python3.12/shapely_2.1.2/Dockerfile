FROM public.ecr.aws/lambda/python:3.12

ENV NUMPY_VERSION="2.2.6" \
    PYAML_VERSION="6.0.1" \
    SHAPELY_VERSION="2.1.2"

WORKDIR /opt
RUN mkdir -p python

RUN dnf update -y && \
    dnf install -y zip findutils

RUN pip install --root-user-action=ignore "NumPy==${NUMPY_VERSION}" "PyYAML==${PYYAML_VERSION}" "shapely==${SHAPELY_VERSION}" -t python

# Precompile, remove source and cache dirs to shrink the layer
RUN python -m compileall -q python/ && \
    find python/ -type d -name '__pycache__' -print0 | xargs -0 rm -rf

# Strip debug symbols from pandas' native extensions
RUN find python/ -name '*.so*' -exec strip {} \;

# Compress all source codes except files listed in .lambdaignore
COPY .lambdaignore .
RUN grep -vE '^\s*#|^\s*$' .lambdaignore | xargs zip -9qyr layer.zip python -x
