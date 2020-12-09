# GFW Lambda Layers

This repo describes GFW's lambda layers on AWS using Terraform framework.

GFW has three deployment environments
- dev
- staging
- production

Each environment has its own terraform backend.
Other repos can access state of core infrastructure and build on top of it.

## Prerequisites

This repo expects environment to be specified in environment variable `ENV`. If `ENV` is not set, default is `dev`.

You will need to have AWS credentials for the different environments stored in your ~/.aws folder.
Profile names must be
- gfw-dev
- gfw-staging
- gfw-production
respectively. 


## Run

```bash
./script plan
./script apply
```

Always run `plan` before running `apply` and make sure you are working in the right environment. 
Verify plan results to assure the correct changes are made before running apply.
