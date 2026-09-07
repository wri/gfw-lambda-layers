FROM public.ecr.aws/lambda/python:3.11

ENV PILLOW_VERSION="12.1.1"

WORKDIR /opt
RUN mkdir -p python

RUN yum update -y && yum install -y binutils zip && yum clean all

RUN pip install --root-user-action=ignore "pillow==${PILLOW_VERSION}" -t python

# Precompile all Python source and strip __pycache__ dirs
RUN python -m compileall -q python/ && \
    find python/ -type d -name '__pycache__' -print0 | xargs -0 rm -rf

# Strip debug symbols from native libs (both system and Python extensions)
RUN find python/ -name '*.so*' -exec strip {} \;

# Compress all source code except those files listed in .lambdaignore
COPY .lambdaignore .
RUN grep -vE '^\s*#|^\s*$' .lambdaignore | xargs zip -9qyr layer.zip python -x
