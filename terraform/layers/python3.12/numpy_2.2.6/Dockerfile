FROM public.ecr.aws/lambda/python:3.12

# Cap numpy at 2.2.x — the last series with manylinux2014 wheels, so it installs
# cleanly on the AL2 base ^

ENV NUMPY_VERSION="2.2.6"

WORKDIR /opt
RUN mkdir -p python

RUN dnf update -y && \
    dnf install -y zip findutils

RUN pip install --root-user-action=ignore "numpy==${NUMPY_VERSION}" -t python

# Compile to .pyc and remove .py source files
RUN python -m compileall .
RUN find python/ -type f -name '*.pyc' | while read f; do \
      n=$(echo $f | sed 's/__pycache__\///' | sed 's/.cpython-312//'); \
      cp $f $n; \
    done
RUN find python/ -type d -a -name '__pycache__' -print0 | xargs -0 rm -rf
RUN find python/ -type f -a -name '*.py' -print0 | xargs -0 rm -f

# Don't try to strip debug symbols, it's a world of hurt due to non-standard ELF alignment that strip corrupts

COPY .lambdaignore .
RUN grep -vE '^\s*#|^\s*$' .lambdaignore | xargs zip -9qyr layer.zip python -x
