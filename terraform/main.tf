terraform {
  backend "s3" {
    region         = "us-east-1"
    key            = "lambda-layers.tfstate"
    dynamodb_table = "aws-locks"
    encrypt        = true
  }
}

data "terraform_remote_state" "core" {
  backend = "s3"
  config = {
    bucket = local.tf_state_bucket
    region = "us-east-1"
    key    = "core.tfstate"
  }
}

module "py310_mercantile_121" {
  source         = "./modules/lambda_layer"
  bucket         = data.terraform_remote_state.core.outputs.pipelines_bucket
  name           = "mercantile"
  module_version = "1.2.1"
  runtime        = "python3.10"
  layer_path     = "${path.root}/layers/python3.10/mercantile_1.2.1/"
}

module "py310_pandas_153" {
  source         = "./modules/lambda_layer"
  bucket         = data.terraform_remote_state.core.outputs.pipelines_bucket
  name           = "pandas"
  module_version = "1.5.3"
  runtime        = "python3.10"
  layer_path     = "${path.root}/layers/python3.10/pandas_1.5.3/"
}

module "py310_pandas_214" {
  source         = "./modules/lambda_layer"
  bucket         = data.terraform_remote_state.core.outputs.pipelines_bucket
  name           = "pandas"
  module_version = "2.1.4"
  runtime        = "python3.10"
  layer_path     = "${path.root}/layers/python3.10/pandas_2.1.4/"
}

module "py310_pillow_950" {
  source         = "./modules/lambda_layer"
  bucket         = data.terraform_remote_state.core.outputs.pipelines_bucket
  name           = "pillow"
  module_version = "9.5.0"
  runtime        = "python3.10"
  layer_path     = "${path.root}/layers/python3.10/pillow_9.5.0/"
}

module "py310_rasterio_138" {
  source         = "./modules/lambda_layer"
  bucket         = data.terraform_remote_state.core.outputs.pipelines_bucket
  name           = "rasterio"
  module_version = "1.3.8"
  runtime        = "python3.10"
  layer_path     = "${path.root}/layers/python3.10/rasterio_1.3.8/"
}

module "py310_shapely_185" {
  source         = "./modules/lambda_layer"
  bucket         = data.terraform_remote_state.core.outputs.pipelines_bucket
  name           = "shapely"
  module_version = "1.8.5"
  runtime        = "python3.10"
  name_suffix    = local.name_suffix
  layer_path     = "${path.root}/layers/python3.10/shapely_1.8.5post1/"
}