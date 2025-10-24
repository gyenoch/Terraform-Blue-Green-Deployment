output "alb_dns_name" {
  description = "Load Balancer DNS"
  value       = data.aws_lb.app_lb.dns_name
}
