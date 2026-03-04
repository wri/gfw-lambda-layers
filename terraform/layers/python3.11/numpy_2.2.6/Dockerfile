FROM public.ecr.aws/lambda/python:3.11

# Cap numpy at 2.2.x — the last series with manylinux2014 wheels, so it installs
# cleanly on the AL2 base ^

ENV NUMPY_VERSION="2.2.6"

RUN yum update && yum install -y binutils zip && yum clean all

WORKDIR /opt
RUN mkdir -p python

RUN pip install --root-user-action=ignore "numpy==${NUMPY_VERSION}" -t python

# numpy 1.26.4's runtime is almost entirely in compiled .so extensions;
# compiling yields negligible benefit and can fail on some of numpy's
# generated pure-Python stubs. Exclude .py and .pyi files via .lambdaignore
# instead.

# Strip debug symbols from numpy's native extensions
RUN find python/ -name '*.so*' -exec strip {} \;

COPY .lambdaignore .
RUN cat .lambdaignore | xargs zip -9qyr layer.zip python -x
