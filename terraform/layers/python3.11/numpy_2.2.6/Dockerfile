FROM public.ecr.aws/lambda/python:3.11

# Cap numpy at 2.2.x — the last series with manylinux2014 wheels, so it installs
# cleanly on the AL2 base ^

ENV NUMPY_VERSION="2.2.6"

RUN yum update && yum install -y binutils zip && yum clean all

WORKDIR /opt
RUN mkdir -p python

RUN pip install --root-user-action=ignore "numpy==${NUMPY_VERSION}" -t python

# Compile to .pyc and remove .py source files
RUN python -m compileall .
RUN find python/ -type f -name '*.pyc' | while read f; do \
      n=$(echo $f | sed 's/__pycache__\///' | sed 's/.cpython-311//'); \
      cp $f $n; \
    done
RUN find python/ -type d -a -name '__pycache__' -print0 | xargs -0 rm -rf
RUN find python/ -type f -a -name '*.py' -print0 | xargs -0 rm -f

# Strip debug symbols from numpy's native extensions
# Exclude OpenBLAS — it uses non-standard ELF alignment that strip corrupts
RUN find python/ -name '*.so*' \
    ! -name 'libscipy_openblas*' \
    ! -name 'libopenblas*' \
    -exec strip --strip-debug {} \;

COPY .lambdaignore .
RUN grep -vE '^\s*#|^\s*$' .lambdaignore | xargs zip -9qyr layer.zip python -x
