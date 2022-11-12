locals {

  name            = basename(path.cwd)
  region          = data.aws_region.current.name
  cluster_version = "1.23"

  vpc_cidr = "10.0.0.0/16"
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)

  node_group_name = "managed-ondemand"

  #---------------------------------------------------------------
  # ARGOCD ADD-ON APPLICATION
  #---------------------------------------------------------------

  addon_application = {
    path               = "chart"
    repo_url           = "https://github.com/kubecats/eks-blueprints-add-ons.git"
    add_on_application = true
  }

  #---------------------------------------------------------------
  # ARGOCD WORKLOAD APPLICATION
  #---------------------------------------------------------------

  workload_application = {
    path               = "envs/dev"
    repo_url           = "https://github.com/kubecats/eks-blueprints-workloads.git"
    add_on_application = false
  }

  tags = {
    Blueprint  = local.name
    GithubRepo = "github.com/aws-ia/terraform-aws-eks-blueprints"
  }
}
