locals {
  layer_path = "${path.root}/layers/${var.runtime}/${var.name}_${var.module_version}/"
  layer_name = substr("${var.runtime}-${var.name}_${var.module_version}${var.name_suffix}", 0, 64)
}

data "local_file" "dockerfile" {
  filename = "${local.layer_path}Dockerfile"
}


# Calculate hash of the Docker image source contents
data "external" "touch" {
  program = [coalesce(var.touch_script, "${path.module}/scripts/touch.sh"), var.bucket, "lambda_layers/${local.layer_name}.zip", "${local.layer_path}layer.zip"]
}



# Build the Docker image and copy ZIP file to local folder
resource "null_resource" "build" {
  triggers = {
    hash = filemd5(data.local_file.dockerfile.filename)
  }

  provisioner "local-exec" {
    command     = "${coalesce(var.build_script, "${path.module}/scripts/build.sh")} ${local.layer_path} ${local.layer_name}"
    interpreter = ["bash", "-c"]
  }

  depends_on = [data.external.touch]
}

resource "aws_s3_bucket_object" "default" {
  bucket = var.bucket
  key    = "lambda_layers/${local.layer_name}.zip"
  source = lookup(data.external.touch.result, "source")
  etag   = filemd5(data.local_file.dockerfile.filename)

  depends_on = [null_resource.build]
}

resource "aws_lambda_layer_version" "default" {
  layer_name          = replace(local.layer_name, ".", "")
  s3_bucket           = aws_s3_bucket_object.default.bucket
  s3_key              = aws_s3_bucket_object.default.key
  compatible_runtimes = [var.runtime]
  source_code_hash    = filemd5(data.local_file.dockerfile.filename)

}
