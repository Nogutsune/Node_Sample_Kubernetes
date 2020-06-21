resource "aws_eks_cluster" "tf_eks" {
  name     = "insider-master-node"
  role_arn = aws_iam_role.eks-master-node-role.arn

  vpc_config {
    security_group_ids = [aws_security_group.master-node-sg.id]
    subnet_ids         = module.vpc.private_subnets
  }

  depends_on = [
    "aws_iam_role_policy_attachment.tf-cluster-AmazonEKSClusterPolicy",
    "aws_iam_role_policy_attachment.tf-cluster-AmazonEKSServicePolicy",
  ]
}
