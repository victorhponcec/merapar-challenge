#SG WEB 
resource "aws_security_group" "web" {
  name        = "web"
  description = "allow lb/app traffic"
  vpc_id      = aws_vpc.main.id
}
#public ALB
resource "aws_vpc_security_group_ingress_rule" "web_allow_80" {
  security_group_id            = aws_security_group.web.id
  referenced_security_group_id = aws_security_group.lba.id
  from_port                    = 80
  to_port                      = 80
  ip_protocol                  = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "web_egress_all" {
  security_group_id = aws_security_group.web.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

#SG LBA
resource "aws_security_group" "lba" {
  name        = "lba_web"
  description = "allow web traffic"
  vpc_id      = aws_vpc.main.id
}
resource "aws_vpc_security_group_ingress_rule" "lba_allow_443" {
  security_group_id = aws_security_group.lba.id
  prefix_list_id    = data.aws_ec2_managed_prefix_list.cloudfront.id
  from_port   = 443
  to_port     = 443
  ip_protocol = "tcp"
}
data "aws_ec2_managed_prefix_list" "cloudfront" {
  name = "com.amazonaws.global.cloudfront.origin-facing"
}

resource "aws_vpc_security_group_egress_rule" "lba_egress_all" {
  security_group_id = aws_security_group.lba.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
