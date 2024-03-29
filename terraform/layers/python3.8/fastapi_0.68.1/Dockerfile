FROM lambci/lambda:build-python3.8

ENV WORKDIR=/opt
ENV \
    FASTAPI_VERSION=0.68.1 \
    MANGUM_VERSION=0.12.2 \
    UVICORN_VERSION=0.15 \
    CFLAGS="-Os"

WORKDIR $WORKDIR
RUN mkdir -p $WORKDIR/python

# Install dependencies to build package
RUN pip3.8 install fastapi==${FASTAPI_VERSION} mangum==${MANGUM_VERSION} uvicorn==${UVICORN_VERSION} -t python

# Precompile all python packages and remove .py files
RUN python -m compileall .
RUN find python/ -type f -name '*.pyc' | while read f; do n=$(echo $f | sed 's/__pycache__\///' | sed 's/.cpython-38//'); cp $f $n; done;
RUN find python/ -type d -a -name '__pycache__' -print0 | xargs -0 rm -rf
RUN find python/ -type d -a -name '*.dist-info' -print0 | xargs -0 rm -rf
RUN find python/ -type d -a -name 'tests' -print0 | xargs -0 rm -rf
RUN find python/ -type f -a -name '*.py' -print0 | xargs -0 rm -f
RUN strip -s -R .comment -R .gnu.version python/pydantic/*.so

# Zip and deploy package
RUN cd $WORKDIR \
    && zip -r layer.zip *

CMD ["/bin/bash"]