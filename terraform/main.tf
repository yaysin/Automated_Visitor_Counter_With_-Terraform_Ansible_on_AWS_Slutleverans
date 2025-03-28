resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "my-vpc"
  }
}

resource "aws_subnet" "public_az1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr_az1
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
  tags = {
    Name = "my-public-subnet-az1"
  }
}

resource "aws_subnet" "public_az2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr_az2
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1b"
  tags = {
    Name = "my-public-subnet-az2"
  }
}

resource "aws_subnet" "private_az1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr_az1
  availability_zone = "us-east-1a"
  tags = {
    Name = "my-private-subnet-az1"
  }
}

resource "aws_subnet" "private_az2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr_az2
  availability_zone = "us-east-1b"
  tags = {
    Name = "my-private-subnet-az2"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "my-internet-gateway"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  tags = {
    Name = "my-public-route-table"
  }
}

resource "aws_route_table_association" "public_az1" {
  subnet_id      = aws_subnet.public_az1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_az2" {
  subnet_id      = aws_subnet.public_az2.id
  route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "web" {
  name_prefix = "web-sg-"
  vpc_id      = aws_vpc.main.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_source_cidr]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "web-security-group"
  }
}

resource "aws_security_group" "db" {
  name_prefix = "db-sg-"
  vpc_id      = aws_vpc.main.id
  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.web.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "db-security-group"
  }
}

resource "aws_instance" "web_az1" {
  ami               = var.ami_id
  instance_type     = var.instance_type
  subnet_id         = aws_subnet.public_az1.id
  security_groups   = [aws_security_group.web.id]
  key_name          = var.key_name
  availability_zone = "us-east-1a"
  tags = {
    Name = "web-server-az1"
  }
}

resource "aws_instance" "web_az2" {
  ami               = var.ami_id
  instance_type     = var.instance_type
  subnet_id         = aws_subnet.public_az2.id
  security_groups   = [aws_security_group.web.id]
  key_name          = var.key_name
  availability_zone = "us-east-1b"
  tags = {
    Name = "web-server-az2"
  }
}

resource "aws_db_subnet_group" "main" {
  name       = "db-subnet-group"
  subnet_ids = [
    aws_subnet.private_az1.id,
    aws_subnet.private_az2.id,
  ]
  tags = {
    Name = "My DB Subnet Group"
  }
}

resource "aws_db_instance" "db" {
  allocated_storage      = var.db_allocated_storage
  db_name                = var.db_name
  engine                 = var.db_engine
  engine_version         = "15"
  instance_class         = var.db_instance_class
  username               = var.db_username
  password               = var.db_password
  multi_az               = var.db_multi_az
  vpc_security_group_ids = [aws_security_group.db.id]
  db_subnet_group_name   = aws_db_subnet_group.main.name
  skip_final_snapshot    = true
  availability_zone      = "us-east-1a"
  tags = {
    Name = "my-postgres-db"
  }
}

resource "aws_lb" "app_lb" {
  name               = "app-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.web.id]
  subnet_mapping {
    subnet_id = aws_subnet.public_az1.id
  }
  subnet_mapping {
    subnet_id = aws_subnet.public_az2.id
  }
}

resource "aws_lb_target_group" "app_tg" {
  name     = "app-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}

resource "aws_lb_listener" "app_listener" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}

resource "aws_lb_target_group_attachment" "web_tg_attach_1" {
  target_group_arn = aws_lb_target_group.app_tg.arn
  target_id        = aws_instance.web_az1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "web_tg_attach_2" {
  target_group_arn = aws_lb_target_group.app_tg.arn
  target_id        = aws_instance.web_az2.id
  port             = 80
}