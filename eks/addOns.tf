# This enables the VPC-CNI 
resource "aws_eks_addon" "example" {
  depends_on   = [aws_eks_cluster.example]
  cluster_name = aws_eks_cluster.example.name
  addon_name   = "vpc-cni"
  configuration_values = jsonencode({
    "enableNetworkPolicy" = "true"
  })
}