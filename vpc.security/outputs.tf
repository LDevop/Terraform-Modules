output "security_group" {
  value = aws_security_group.My_VPC_Security_Group.id
}

output "my_vpc" {
  value = aws_vpc.My_VPC.id
}

output "vpc_subnet" {
  value = aws_subnet.My_VPC_Subnet.id
}

output "security_acl" {
  value = aws_network_acl.My_VPC_Security_ACL.id
}


