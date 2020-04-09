# Require TF version to be same as or greater than 0.12.13
terraform {
  required_version = ">=0.12.13"
  backend "s3" {
    region         = "us-east-1"
    key            = "lambda-layers.tfstate"
    dynamodb_table = "aws-locks"
    encrypt        = true
  }
}

# Download any stable version in AWS provider of 2.36.0 or higher in 2.36 train
provider "aws" {
  region  = "us-east-1"
  version = "~> 2.54.0"
}



data "terraform_remote_state" "core" {
  backend = "s3"
  config = {
    bucket = local.tf_state_bucket
    region = "us-east-1"
    key    = "core.tfstate"
  }
}

resource "aws_s3_bucket_object" "shapely_pyyaml" {
  bucket = data.terraform_remote_state.core.outputs.pipelines_bucket
  key    = "lambda_layers/shapely_pyyaml.zip"
  source = "../docker/shapely_pyyaml/layer.zip"
  etag   = filemd5("../docker/shapely_pyyaml/layer.zip")
}

resource "aws_lambda_layer_version" "shapely_pyyaml" {
  layer_name          = substr("${local.project}-shapely_pyyaml", 0, 64)
  s3_bucket           = aws_s3_bucket_object.shapely_pyyaml.bucket
  s3_key              = aws_s3_bucket_object.shapely_pyyaml.key
  compatible_runtimes = ["python3.7"]
}

resource "aws_s3_bucket_object" "rasterio" {
  bucket = data.terraform_remote_state.core.outputs.pipelines_bucket
  key    = "lambda_layers/rasterio.zip"
  source = "../docker/rasterio/layer.zip"
  etag   = filemd5("../docker/rasterio/layer.zip")
}

resource "aws_lambda_layer_version" "rasterio" {
  layer_name          = substr("${local.project}-rasterio", 0, 64)
  s3_bucket           = aws_s3_bucket_object.rasterio.bucket
  s3_key              = aws_s3_bucket_object.rasterio.key
  compatible_runtimes = ["python3.6"]
}
