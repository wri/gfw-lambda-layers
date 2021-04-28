FROM lambci/lambda:build-python3.8

ENV WORKDIR=/opt
ENV PILLOW_VERSION=8.1.1

#ARG BUCKET
#ARG KEY

WORKDIR $WORKDIR
RUN mkdir -p python

# installing dependencies to build package
RUN pip3.8 install pillow==${PILLOW_VERSION} -t python

#Precompile all python packages and remove .py files
RUN python -m compileall .
RUN find python/ -type f -name '*.pyc' | while read f; do n=$(echo $f | sed 's/__pycache__\///' | sed 's/.cpython-38//'); cp $f $n; done;
RUN find python/ -type d -a -name '__pycache__' -print0 | xargs -0 rm -rf
RUN find python/ -type f -a -name '*.py' -print0 | xargs -0 rm -f

# zip and deploy package
RUN cd /opt \
    && zip -r layer.zip *

RUN pip3.8 install awscli
#CMD ["aws", "s3", "cp", "/opt/layer.zip", "s3://$BUCKET/$KEY"]

