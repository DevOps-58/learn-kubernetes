resource "aws_eks_cluster" "example" {
  name                      = "b58-eks"
  role_arn                  = aws_iam_role.example.arn
  enabled_cluster_log_types = ["audit", "controllerManager"]

  vpc_config {
    subnet_ids = ["	subnet-0c00c651c1810e98b", "subnet-03b5ca81376214b18", "subnet-043f04aeab26f1d2d"] # This is where nodes are going to be provisioned. This is a multi-zonal kubernetes cluster
  }

  depends_on = [
    aws_iam_role_policy_attachment.example-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.example-AmazonEKSVPCResourceController,
  ]
}


data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "example" {
  name               = "eks-cluster-example"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "example-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.example.name
}

# Optionally, enable Security Groups for Pods
# Reference: https://docs.aws.amazon.com/eks/latest/userguide/security-groups-for-pods.html
resource "aws_iam_role_policy_attachment" "example-AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.example.name
}


# Defines the retention of the enabled logs on cloud watch
resource "aws_cloudwatch_log_group" "logger" {
  name              = "/aws/eks/b58-eks/logger"
  retention_in_days = 1
}