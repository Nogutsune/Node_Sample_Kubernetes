########################################################################################

# Is provided in demo code, no idea what it's used for though! TODO: DELETE
# data "aws_region" "current" {}

# EKS currently documents this required userdata for EKS worker nodes to
# properly configure Kubernetes applications on the EC2 instance.
# We utilize a Terraform local here to simplify Base64 encode this
# information and write it into the AutoScaling Launch Configuration.
# More information: https://docs.aws.amazon.com/eks/latest/userguide/launch-workers.html
locals {
  tf-eks-node-userdata = <<USERDATA
#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh --apiserver-endpoint '${aws_eks_cluster.tf_eks.endpoint}' --b64-cluster-ca '${aws_eks_cluster.tf_eks.certificate_authority.0.data}' 'example'
USERDATA
}

resource "aws_launch_configuration" "tf_eks" {
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.node.name
  image_id                    = var.ami_id
  instance_type               = var.instance_type
  name_prefix                 = "insider-worker-eks-lc"
  security_groups             = [aws_security_group.worker-node-sg.id]
  user_data_base64            = base64encode(local.tf-eks-node-userdata)
  key_name                    = var.keypair_name

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "tf_eks" {
  desired_capacity     = "2"
  launch_configuration = aws_launch_configuration.tf_eks.id
  max_size             = "3"
  min_size             = 1
  name                 = "insider-worker-eks-asg"
  vpc_zone_identifier  = module.vpc.private_subnets

  tag {
    key                 = "Name"
    value               = "insider-worker-eks-asg"
    propagate_at_launch = true
  }

  tag {
    key                 = "kubernetes.io/cluster/example"
    value               = "owned"
    propagate_at_launch = true
  }
}
