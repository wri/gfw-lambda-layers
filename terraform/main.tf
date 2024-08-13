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

module "py310_geopandas_0144" {
  source         = "./modules/lambda_layer"
  bucket         = data.terraform_remote_state.core.outputs.pipelines_bucket
  name           = "geopandas"
  module_version = "0.14.4"
  runtime        = "python3.10"
  layer_path     = "${path.root}/layers/python3.10/geopandas_0.14.4/"
}

module "py310_mercantile_121" {
  source         = "./modules/lambda_layer"
  bucket         = data.terraform_remote_state.core.outputs.pipelines_bucket
  name           = "mercantile"
  module_version = "1.2.1"
  runtime        = "python3.10"
  layer_path     = "${path.root}/layers/python3.10/mercantile_1.2.1/"
}

module "py310_numpy_1264" {
  source         = "./modules/lambda_layer"
  bucket         = data.terraform_remote_state.core.outputs.pipelines_bucket
  name           = "numpy"
  module_version = "1.26.4"
  runtime        = "python3.10"
  layer_path     = "${path.root}/layers/python3.10/numpy_1.26.4/"
}

module "py310_pandas_153" {
  source         = "./modules/lambda_layer"
  bucket         = data.terraform_remote_state.core.outputs.pipelines_bucket
  name           = "pandas"
  module_version = "1.5.3"
  runtime        = "python3.10"
  layer_path     = "${path.root}/layers/python3.10/pandas_1.5.3/"
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

# These are temporary:
module "py310_geopandas_no_numpy_no_pandas" {
  source         = "./modules/lambda_layer"
  bucket         = data.terraform_remote_state.core.outputs.pipelines_bucket
  name           = "geopandas_no_numpy_no_pandas"
  module_version = "0.14.4"
  runtime        = "python3.10"
  layer_path     = "${path.root}/layers/python3.10/geopandas_no_numpy_no_pandas/"
}

module "py310_numpy" {
  source         = "./modules/lambda_layer"
  bucket         = data.terraform_remote_state.core.outputs.pipelines_bucket
  name           = "numpy"
  module_version = "1.26.4"
  runtime        = "python3.10"
  layer_path     = "${path.root}/layers/python3.10/numpy/"
}

module "py310_pandas_no_numpy" {
  source         = "./modules/lambda_layer"
  bucket         = data.terraform_remote_state.core.outputs.pipelines_bucket
  name           = "pandas_no_numpy"
  module_version = "1.5.3"
  runtime        = "python3.10"
  layer_path     = "${path.root}/layers/python3.10/pandas_no_numpy/"
}

module "py310_rasterio_no_numpy" {
  source         = "./modules/lambda_layer"
  bucket         = data.terraform_remote_state.core.outputs.pipelines_bucket
  name           = "rasterio_no_numpy"
  module_version = "1.3.8"
  runtime        = "python3.10"
  layer_path     = "${path.root}/layers/python3.10/rasterio_no_numpy/"
}

module "py310_shapely_no_numpy" {
  source         = "./modules/lambda_layer"
  bucket         = data.terraform_remote_state.core.outputs.pipelines_bucket
  name           = "shapely_no_numpy"
  module_version = "1.8.5"
  runtime        = "python3.10"
  name_suffix    = local.name_suffix
  layer_path     = "${path.root}/layers/python3.10/shapely_no_numpy/"
}