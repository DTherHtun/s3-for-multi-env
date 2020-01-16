# AWS S3 create Bitcket with terraform fro multi env

s3 bucket create for non-prod and prod using terraform

```bash
$ cd evn/prod
$ # edit terraform.tfvars
$ terraform init
$ terraform plan
$ terraform apply 
if error happen retry *terraform apply*
$ terraform apply
```
