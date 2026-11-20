# 📦 Small AWS Infra - Terraform & Docker Compose
**Running Demo Wordpress + MySQL setup**

ℹ️ Solution using github actions to build / destroy a given infrastructure in the cloud\
(Not made to run locally)

## Setup

### A. Make TF State Persistent

> ℹ️ **terraform state**: \
> file listing all ressources created by terraform to keep track of things to needs to be modified or removed, anything not in that state is ignored by terraform (so will not be destroyed for example)

We need to setup persistent state so that each runner shares the same state file.

1. Log into AWS console
2. Create a bucket (private)
3. Update tf backend settings at `src/environments/dev/backend.tf` & `src/environments/prod/backend.tf` 

```tf
terraform {

  # Setup for storage of state in s3 bucket
  # (have to be in the root module)
  backend "s3" {
    bucket  = "<BUCKET-NAME>"
    key     = "<BUCKET-NAME>/<ENVIRONMENT>/terraform.tfstate"
    region  = "eu-north-1"
    encrypt = true
  }
}
```

4. Commit & push the "bucket update" modifications so that the github runner has access to up-to-date informations

> ⚠️ DO NOT FORGET to destroy the bucket, otherwise it will be billed 💶.

### B. Create Dedicated IAM User

We need to setup a dedicated "terraform" user in AWS to perform those actions:

1. Go to 👉 AWS > 👉 IAM > 👉 Create User
2. Attach a permission policy (use `AdministratorAccess` for tests but never in a real situation)
3. Click on 👉 the created user > 👉 Create access key > 👉 Third-party service
4. Set the secrets in the github repo (`AWS_IAM_ACCESS_KEY` & `AWS_IAM_SECRET_ACCESS_KEY`)

> ⚠️ DO NOT FORGET to revoke those users when not using them anymore.

### C. Checklist of required secrets

| sercret | description |
| - | - |
| `AWS_IAM_ACCESS_KEY` | AWS IAM user credentials (created above) |
| `AWS_IAM_SECRET_ACCESS_KEY` | AWS IAM user credentials (created above) |
| `DATABASE` | Name of the database dedicated to wordpress |
| `DB_ROOT_PASSWORD` | Database root user password |
| `DB_USER` | Dedicated wordpress database user |
| `DB_USER_PASSWORD` | Dedicated wordpress database user password |
| `SSH_PRIVATE_KEY` | Private SSH key (to connect to EC2 instance) |
| `SSH_PUBLIC_KEY` | Public SSH key (to connect to EC2 instance) |