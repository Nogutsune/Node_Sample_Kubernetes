resource "aws_security_group" "master-node-sg" {
  name        = "insider-master-node-sg"
  description = "Cluster communication with worker nodes"
  vpc_id      = module.vpc.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "insider-master-node-sg"
  }
}


resource "aws_security_group" "worker-node-sg" {
  name        = "insider_worker_node_sg"
  description = "Security group for all nodes in the cluster"
  vpc_id      = module.vpc.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "insider_worker_node_sg"
  }
}


# Allow inbound traffic from your local workstation external IP
# to the Kubernetes. You will need to replace A.B.C.D below with
# your real IP. Services like icanhazip.com can help you find this.

resource "aws_security_group_rule" "tf-eks-cluster-ingress-workstation-https" {
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow workstation to communicate with the cluster API Server"
  from_port         = 443
  protocol          = "tcp"
  security_group_id = "${aws_security_group.master-node-sg.id}"
  to_port           = 443
  type              = "ingress"
}

########################################################################################
# Setup worker node security group

resource "aws_security_group_rule" "worker-node-sg-ingress-self" {
  description              = "Allow node to communicate with each other"
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = "${aws_security_group.worker-node-sg.id}"
  source_security_group_id = "${aws_security_group.worker-node-sg.id}"
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "worker-node-sg-ingress-cluster" {
  description              = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  from_port                = 1025
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.worker-node-sg.id}"
  source_security_group_id = "${aws_security_group.master-node-sg.id}"
  to_port                  = 65535
  type                     = "ingress"
}

# allow worker nodes to access EKS master
resource "aws_security_group_rule" "tf-eks-cluster-ingress-node-https" {
  description              = "Allow pods to communicate with the cluster API Server"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.worker-node-sg.id}"
  source_security_group_id = "${aws_security_group.master-node-sg.id}"
  to_port                  = 443
  type                     = "ingress"
}

resource "aws_security_group_rule" "worker-node-sg-ingress-master" {
  description              = "Allow cluster control to receive communication from the worker Kubelets"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.master-node-sg.id}"
  source_security_group_id = "${aws_security_group.worker-node-sg.id}"
  to_port                  = 443
  type                     = "ingress"
}
