FROM lambci/lambda:build-python3.8

ENV WORKDIR=/opt
ENV \
    FASTAPI_VERSION=0.68.0 \
    MANGUM_VERSION=0.12.1 \
    UVICORN_VERSION=0.14


#ARG BUCKET
#ARG KEY

WORKDIR $WORKDIR
RUN mkdir -p $WORKDIR/python

# Install dependencies to build package
RUN pip3.8 install fastapi==${FASTAPI_VERSION} mangum==${MANGUM_VERSION} uvicorn[standard]==${UVICORN_VERSION} -t python

# Precompile all python packages and remove .py files
RUN python -m compileall .
RUN find python/ -type f -name '*.pyc' | while read f; do n=$(echo $f | sed 's/__pycache__\///' | sed 's/.cpython-38//'); cp $f $n; done;
RUN find python/ -type d -a -name '__pycache__' -print0 | xargs -0 rm -rf
RUN find python/ -type f -a -name '*.py' -print0 | xargs -0 rm -f

# Zip and deploy package
RUN cd $WORKDIR \
    && zip -r layer.zip *

RUN pip3.8 install awscli
#CMD ["aws", "s3", "cp", "$WORKDIR/layer.zip", "s3://$BUCKET/$KEY"]
