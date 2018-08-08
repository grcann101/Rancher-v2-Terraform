#---------------------------------------------------------------
#set up security groups rancher-nodes using the terraform sg module
#--------------------------------------------------------------

module "security-group" {
  source  = "terraform-aws-modules/security-group/aws"


  version = "2.0.0"
  name        = "${var.rancher-sg-name}"
  description = "Security group for Rancher V2 Nodes"
  vpc_id      = "${var.rancher-vpc}"
  ingress_with_self = [
    {
      from_port   = 0
     to_port     = 65535
      protocol    = "tcp"
      description = "Rancher Nodes TCP" 
	  
    },
	{
	 from_port   = 0
      to_port     = 65535
      protocol    = "udp"
     description = "Rancher Nodes UDP"
	  
	}
  ]
   ingress_with_cidr_blocks = [
    {
      rule        = "https-443-tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      rule        = "http-80-tcp"
      cidr_blocks = "0.0.0.0/0"
    },
  ]
    egress_with_cidr_blocks = [            # all output port open all protocols
	{
      rule        = "all-all"
      cidr_blocks = "0.0.0.0/0"
    },
  ]
  ingress_cidr_blocks = ["172.32.0.0/16"]                 # vpc cidr blocks
}
#---------------------------------------------------------------
# create the rules for the external IP's for each instance
#--------------------------------------------------------------
 

resource "aws_security_group_rule" "allow_all_1" {
  type            = "ingress"
  from_port       = 0
  to_port         = 65535
  protocol        = "tcp"
  cidr_blocks     = ["${aws_instance.rancher-instance-1.public_ip}/32"]
  security_group_id = "${module.security-group.this_security_group_id}"
}


resource "aws_security_group_rule" "allow_all_2" {
  type            = "ingress"
  from_port       = 0
  to_port         = 65535
  protocol        = "tcp"
  cidr_blocks     = ["${aws_instance.rancher-instance-2.public_ip}/32"]
  security_group_id = "${module.security-group.this_security_group_id}"
}
resource "aws_security_group_rule" "allow_all_3" {
  type            = "ingress"
  from_port       = 0
  to_port         = 65535
  protocol        = "tcp"
  cidr_blocks     = ["${aws_instance.rancher-instance-3.public_ip}/32"]
  security_group_id = "${module.security-group.this_security_group_id}"
}


#---------------------------------------------------------------
# add a rule for the pc creating the RKE environment
#--------------------------------------------------------------
resource "aws_security_group_rule" "allow_all_my_ip" {
  type            = "ingress"
  from_port       = 0
  to_port         = 65535
  protocol        = "tcp"
  cidr_blocks     = ["${var.my_ip_address}/32"]
  security_group_id = "${module.security-group.this_security_group_id}"
}







