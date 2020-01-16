module "prod-bucket" {
        source						= "../../modules/s3/prod/"
        prod_user					= "${var.production_user}"
        bucket_for_production				= "${var.bucket_env_for_production}"
}
