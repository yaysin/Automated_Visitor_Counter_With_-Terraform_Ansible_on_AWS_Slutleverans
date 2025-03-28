variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr_az1" {
  description = "CIDR block for the public subnet in AZ1"
  type        = string
  default     = "10.0.1.0/24"
}

variable "public_subnet_cidr_az2" {
  description = "CIDR block for the public subnet in AZ2"
  type        = string
  default     = "10.0.2.0/24"
}

variable "private_subnet_cidr_az1" {
  description = "CIDR block for the private subnet in AZ1"
  type        = string
  default     = "10.0.3.0/24"
}

variable "private_subnet_cidr_az2" {
  description = "CIDR block for the private subnet in AZ2"
  type        = string
  default     = "10.0.4.0/24"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "ami_id" {
  description = "AMI ID for the EC2 instances"
  type        = string
  default     = "ami-071226ecf16aa7d96"
}

variable "key_name" {
  description = "Name of the SSH key pair"
  type        = string
  default     = "mar28"
}

variable "ssh_source_cidr" {
  description = "CIDR block to allow SSH access from"
  type        = string
  default     = "0.0.0.0/0"
}

variable "db_allocated_storage" {
  description = "Allocated storage for the database instance"
  type        = number
  default     = 20
}

variable "db_name" {
  description = "Name of the database"
  type        = string
  default     = "mydb"
}

variable "db_engine" {
  description = "Database engine"
  type        = string
  default     = "postgres"
}

variable "db_engine_version" {
  description = "Database engine version"
  type        = string
  default     = "15.3"
}

variable "db_instance_class" {
  description = "Database instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "db_username" {
  description = "Database username"
  type        = string
  default     = "myuser"
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}

variable "db_multi_az" {
  description = "Multi AZ deployment for the database"
  type        = bool
  default     = false
}