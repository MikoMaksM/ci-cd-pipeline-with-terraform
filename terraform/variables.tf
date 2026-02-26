variable vpc_cidr_block {
  default = "10.0.0.0/16"
}
variable subnet_cidr_block {
  default = "10.0.10.0/24"
}
variable avail_zone{
  default = "ap-southeast-2a"
}
variable env_prefix {
  default = "dev"
}
variable my_ip {
  default = "115.186.223.143/32"
}
variable jenkins_ip {
   default = "134.199.172.213/32"
}
variable instance_type {
  default = "t2.micro"
}
variable region {
  default = "ap-southeast-2"
}