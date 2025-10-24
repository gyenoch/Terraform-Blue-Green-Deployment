variable "env" {
  description = "Environment name: blue or green"
  type        = string
}

variable "active_environment" {
  description = "Active environment receiving traffic"
  type        = string
  default     = "blue"
}

variable "lb_name" {
  description = "Name of Load Balancer"
  default     = "blue-green-alb"
}

variable "sg_name" {
  description = "Name of Security Group"
  default     = "blue-green-sg"
}
