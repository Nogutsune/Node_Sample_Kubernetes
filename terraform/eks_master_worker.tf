# module "eks" {
#   source                       = "terraform-aws-modules/eks/aws"
#   version                      = "v7.0.1"
#   cluster_name                 = local.cluster_name
#   subnets                      = module.vpc.private_subnets
#   manage_cluster_iam_resources = false
#   cluster_iam_role_name        = aws_iam_role.eks-master-node-role.name
#   # manage_worker_iam_resources       = false
#   #worker_iam_instance_profile_names = aws_iam_instance_profile.node.name
#   cluster_create_security_group = false
#   cluster_security_group_id     = aws_security_group.master-node-sg.id
#   worker_create_security_group  = false
#   worker_security_group_id      = aws_security_group.worker-node-sg.id
#   tags = {
#     Environment = "Insider"
#   }
#
#   vpc_id = module.vpc.vpc_id
#
#   worker_groups = [
#     {
#       name                 = "worker-group-1"
#       instance_type        = "t2.small"
#       additional_userdata  = "echo foo bar"
#       asg_desired_capacity = 2
#     }
#   ]
# }
#
# data "aws_eks_cluster" "cluster" {
#   name = module.eks.cluster_id
# }
#
# data "aws_eks_cluster_auth" "cluster" {
#   name = module.eks.cluster_id
# }
