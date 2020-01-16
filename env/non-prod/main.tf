module "non-prod-bucket" {
        source						= "../../modules/s3/non-prod/"
        non_prod_user					= "${var.non_production_user}"
        buckets_non_prod_env				= "${var.buckets_env_for_non_prod}"
}
