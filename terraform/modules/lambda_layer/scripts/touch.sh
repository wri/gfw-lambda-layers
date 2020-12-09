#!/bin/bash

# First make attempt to download layer.zip from S3
#
# We use the hash of the dockerfile to determine changes and to trigger S3 objects and lambda layers.
# However, it seems that Terraform replaces our hash values later with the actual hashes for local and remote files.
# Hence, it will always try to upload the layer.zip, even if we did not update it.
# By having the old copy locally, we play it save and don't risk overwriting data with an empty file.

set +e
aws s3 cp "s3://${1}/${2}" "${3}" >/dev/null 2>&1

# In case there is not yet a file on S3 assure that we have an (empty) local file available.
#
# This is necessary so that Terraform can execute plan for aws_s3_bucket_object
set -e
touch "$3"

echo '{ "source": "'"$3"'" }'

