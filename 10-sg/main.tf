module "bastion" {
    #source = "../../terraform-aws-securitygroup"
    source = "git::https://github.com/SaitejaRageti/terraform-aws-securitygroup.git?ref=main"
    project = var.project
    sg_name = var.bastion_sg_name
    environment = var.environment
    sg_description = var.bastion_description
    vpc_id = local.vpc_id
}



module "ingress_alb" {
    #source = "../../terraform-aws-securitygroup"
    source = "git::https://github.com/SaitejaRageti/terraform-aws-securitygroup.git?ref=main"
    project = var.project
    sg_name = "ingress-alb"
    environment = var.environment
    sg_description = "sg for ingress alb"
    vpc_id = local.vpc_id
}


module "eks_control_plane" {
    #source = "../../terraform-aws-securitygroup"
    source = "git::https://github.com/SaitejaRageti/terraform-aws-securitygroup.git?ref=main"
    project = var.project
    environment = var.environment

    sg_name = "eks_control_plane"
    sg_description = "for eks_control_plane"
    vpc_id = local.vpc_id
}

module "eks_node" {
    #source = "../../terraform-aws-securitygroup"
    source = "git::https://github.com/SaitejaRageti/terraform-aws-securitygroup.git?ref=main"
    project = var.project
    environment = var.environment

    sg_name = "eks_node"
    sg_description = "for eks_node"
    vpc_id = local.vpc_id
}

##FRONTEND-ALB
# resource "aws_security_group_rule" "ingress_alb_http" {
#   type              = "ingress"
#   from_port         = 80
#   to_port           = 80
#   protocol          = "tcp"
#   cidr_blocks = ["0.0.0.0/0"]
#   security_group_id = module.backend_alb.sg_id
# }

resource "aws_security_group_rule" "ingress_alb_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.frontend_alb.sg_id
}

#allowing connections from all to VPN --VPN ports 22, 443, 1194, 943

# resource "aws_security_group_rule" "main" {
#   count = length(var.vpn_ports)
#   type              = "ingress"
#   from_port         = var.vpn_ports[count.index]
#   to_port           = var.vpn_ports[count.index]
#   protocol          = "tcp"
#   cidr_blocks       = ["0.0.0.0/0"]
#   security_group_id = module.vpn.sg_id
# }

resource "aws_security_group_rule" "eks_control_plane_eks_node" {
  type              = "ingress"
  from_port        = 0
  to_port          = 0
  protocol         = "-1"
  source_security_group_id = module.eks_node.sg_id
  security_group_id = module.eks_control_plane.sg_id
}

resource "aws_security_group_rule" "eks_node_eks_control_plane" {
  type              = "ingress"
  from_port        = 0
  to_port          = 0
  protocol         = "-1"
  source_security_group_id = module.eks_control_plane.sg_id
  security_group_id = module.eks_node.sg_id
}

resource "aws_security_group_rule" "eks_control_plane_bastion" {
  type              = "ingress"
  from_port        = 443
  to_port          = 443
  protocol         = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id = module.eks_control_plane.sg_id
}

resource "aws_security_group_rule" "eks_node_bastion" {
  type              = "ingress"
  from_port        = 22
  to_port          = 22
  protocol         = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id = module.eks_node.sg_id
}

resource "aws_security_group_rule" "eks_node_vpc" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks = ["10.0.0.0/16"]
  security_group_id = module.eks_node.sg_id
}

