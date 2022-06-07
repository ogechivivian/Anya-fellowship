###
# Private Network Communication
##
resource "aws_security_group" "internal" {
  name        = "Anyablockchain-${var.infra_env}-internal-sg"
  description = "Allow internal communication"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name        = "Anyablockchain-${var.infra_env}-internal-sg"
    Environment = var.infra_env
    ManagedBy   = "terraform"
    Role        = "internal"
  }
}

resource "aws_security_group_rule" "internal" {
  security_group_id = aws_security_group.internal.id

  type        = "ingress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = [module.vpc.vpc_cidr_block]
}

resource "aws_security_group_rule" "internal_outbound" {
  security_group_id = aws_security_group.internal.id

  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

###
# Public Web Communication
##
resource "aws_security_group" "web" {
  name        = "Anyablockchain-${var.infra_env}-web-sg"
  description = "Allow external communication"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name        = "Anyablockchain-${var.infra_env}-web-sg"
    Environment = var.infra_env
    ManagedBy   = "terraform"
    Role        = "external"
  }
}

resource "aws_security_group_rule" "web_outbound" {
  security_group_id = aws_security_group.web.id

  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "http" {
  security_group_id = aws_security_group.web.id

  type        = "ingress"
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "https" {
  security_group_id = aws_security_group.web.id

  type        = "ingress"
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}
