output "alb_dns_name" {
  description = "Load Balancer DNS"
  value       = aws_lb.app_lb.dns_name
}
