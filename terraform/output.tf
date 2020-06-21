output "eks_kubeconfig" {
  value = "${local.kubeconfig}"
  depends_on = [
    "aws_eks_cluster.tf_eks"
  ]
}

output "eks_cluster_name" {
  value = aws_eks_cluster.tf_eks.name
}
