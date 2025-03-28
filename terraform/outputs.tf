output "web_server_ips" {
  description = "Public IP addresses of the web servers"
  value       = [aws_instance.web_az1.public_ip, aws_instance.web_az2.public_ip]
}

output "database_endpoint" {
  description = "Endpoint of the database server"
  value       = aws_db_instance.db.endpoint
}

output "load_balancer_dns_name" {
  description = "DNS name of the load balancer"
  value       = aws_lb.app_lb.dns_name
}