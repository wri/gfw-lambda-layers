FROM public.ecr.aws/lambda/python:3.13

ENV PILLOW_VERSION="12.1.0"

WORKDIR /opt
RUN mkdir -p python

RUN dnf update -y && \
    dnf install -y zip findutils

RUN pip install --root-user-action "pillow==${PILLOW_VERSION}" -t python

# Precompile all python packages and remove .py files
RUN python -m compileall .
RUN find python/ -type f -name '*.pyc' | while read f; do n=$(echo $f | sed 's/__pycache__\///' | sed 's/.cpython-313//'); cp $f $n; done;
RUN find python/ -type d -a -name '__pycache__' -print0 | xargs -0 rm -rf
RUN find python/ -type f -a -name '*.py' -print0 | xargs -0 rm -f

# Compress all source code except those files listed in .lambdaignore
COPY .lambdaignore .
RUN cat .lambdaignore | xargs zip -9qyr layer.zip python -x
