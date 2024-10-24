# Provisions Node Group and attachs this to the eks 
resource "aws_eks_node_group" "example" {
  depends_on      = [aws_eks_addon.example] # CNI has to be enabled on the cluster first and then node-pool provisioning
  cluster_name    = aws_eks_cluster.example.name
  node_group_name = "b58-eks-np-spot-0"

  node_role_arn  = aws_iam_role.node-example.arn
  subnet_ids     = ["subnet-0c00c651c1810e98b", "subnet-03b5ca81376214b18", "subnet-043f04aeab26f1d2d"] # This is where nodes are going to be provisioned. This is a multi-zonal kubernetes cluster
  instance_types = ["t3.medium", "t3.large"]
  capacity_type  = "SPOT"

  scaling_config {
    desired_size = 1 # when the cluster was provisioned this would be nodegroup node count
    max_size     = 4 # Maximum number of nodes that the node-group can scale
    min_size     = 1 # When the workloads are really less, this would be the number where nodegroup can scale down to.
  }
}

#  IAM Role for EKS Node Group
resource "aws_iam_role" "node-example" {
  name = "eks-node-group-example"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "example-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.node-example.name
}

resource "aws_iam_role_policy_attachment" "example-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.node-example.name
}

resource "aws_iam_role_policy_attachment" "example-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.node-example.name
}