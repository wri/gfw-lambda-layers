FROM lambci/lambda:build-python3.7

ENV WORKDIR=/opt
ENV PANDAS_VERSION=1.1.0

WORKDIR $WORKDIR
RUN mkdir -p python

# Make the dir and to install all packages into packages/
COPY .lambdaignore .

# installing dependencies to build package
RUN pip install pandas==${PANDAS_VERSION} -t python

#Precompile all python packages and remove .py files
RUN python -m compileall .
RUN find python/ -type f -name '*.pyc' | while read f; do n=$(echo $f | sed 's/__pycache__\///' | sed 's/.cpython-37//'); cp $f $n; done;
RUN find python/ -type d -a -name '__pycache__' -print0 | xargs -0 rm -rf
RUN find python/ -type f -a -name '*.py' -print0 | xargs -0 rm -f

# Compress all source codes expect files listed in .lambdaignore
RUN cat .lambdaignore | xargs zip -9qyr layer.zip python -x

CMD ["/bin/bash"]