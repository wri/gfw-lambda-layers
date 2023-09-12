FROM public.ecr.aws/lambda/python:3.10

ENV PILLOW_VERSION=9.5.0

WORKDIR /opt
RUN mkdir -p python

RUN pip3.10 install pillow==${PILLOW_VERSION} -t python

# Precompile all python packages and remove .py files
RUN python -m compileall .
RUN find python/ -type f -name '*.pyc' | while read f; do n=$(echo $f | sed 's/__pycache__\///' | sed 's/.cpython-310//'); cp $f $n; done;
RUN find python/ -type d -a -name '__pycache__' -print0 | xargs -0 rm -rf
RUN find python/ -type f -a -name '*.py' -print0 | xargs -0 rm -f

# Compress all source codes except files listed in .lambdaignore
RUN yum install -y zip
COPY .lambdaignore .
RUN cat .lambdaignore | xargs zip -9qyr layer.zip python -x