module "metadata" {
  source      = "git::https://github.com/fayezosaadi/techforlife-azure-terraform-labels.git?ref=06fe850743d945f5c10494dcdf5d1961300b10d3"
  environment = local.environment
}