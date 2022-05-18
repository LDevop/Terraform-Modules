# outputs you can kist required endpoints, ip or instanceid's

output "alb_hostname" {
  value = aws_alb.alb.dns_name
}

output "az" {
  value = data.aws_availability_zones.available.names
}