resource "aws_security_group" "counting-sg" {
  name        = "counting-sg"
  description = "ssh access"
  vpc_id      = aws_vpc.terra_vpc.id

  tags = {
    Name = "counting-sg"
  }
}
resource "aws_security_group_rule" "allow__ssh" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.dashboard-sg.id
  security_group_id        = aws_security_group.counting-sg.id
}

resource "aws_security_group_rule" "allow__ssh_from_bastion" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.bastion-sg.id
  security_group_id        = aws_security_group.counting-sg.id
}

resource "aws_security_group_rule" "dashboard_allow_to_counting_alb" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.dashboard-sg.id
  security_group_id        = aws_security_group.counting-sg.id
}

resource "aws_security_group_rule" "allow__777" {
  type                     = "ingress"
  from_port                = 7777
  to_port                  = 7777
  protocol                 = "tcp"
  # source_security_group_id = aws_security_group.dashboard-sg.id
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id        = aws_security_group.counting-sg.id
}


resource "aws_security_group_rule" "allow_outbond" {
  type              = "egress"
  to_port           = 0
  protocol          = "-1"
  from_port         = 0
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.counting-sg.id
}

