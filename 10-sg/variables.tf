variable "project" {
  default = "roboshop"
}

variable "environment" {
  default = "dev"
}

variable "frontend_sg_name" {
  default = "frontend_sg"
}

variable "sg_description" {
  default = "sg for frontend instance"
}

variable "bastion_sg_name" {
  default = "bastion_sg"
}

variable "bastion_description" {
  default = "sg for bastion instance"
}

variable "backend_alb_sg_name" {
  default = "backend_alb_sg"
}

variable "backend_alb_description" {
  default = "securtiy group for backend alb"
}

variable "vpn_sg_name" {
    default = "vpn_sg"
  
}
variable "vpn_description" {
  default = "security group for openvpn"
}

variable "mongodb_sg_name" {
    default = "mongodb_sg"
  
}
variable "mongodb_description" {
  default = "security group for openvpn"
}

variable "mongodb_ports_vpn" {
  default = [22,27017]
}

variable "vpn_ports" {
  default = [22,443,1194,943]
}
variable "redis_ports_vpn" {
  default = [22,6379]
}

variable "rabbitmq_ports_vpn" {
  default = [22,5672]
}

variable "mysql_ports_vpn" {
  default = [22,3306]
}