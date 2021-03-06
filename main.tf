variable "dcos_install_mode" {
  description = "specifies which type of command to execute. Options: install or upgrade"
  default     = "install"
}

# Used to determine your public IP for forwarding rules
data "http" "whatismyip" {
  url = "http://whatismyip.akamai.com/"
}

#provider "aws" {
#  version = "1.43.2"
#}

module "dcos" {
  source = "dcos-terraform/dcos/aws"

  dcos_instance_os    = "centos_7.5"
  cluster_name        = "testbadger" 
  ssh_public_key_file = "~/.ssh/id_rsa.pub"
  admin_ips           = ["0.0.0.0/0"]

  num_masters        = "3"
  num_private_agents = "5"
  num_public_agents  = "2"

  bootstrap_instance_type = "t2.medium"
  public_agents_instance_type = "m4.xlarge"
  private_agents_instance_type = "m4.2xlarge"
  masters_instance_type = "m4.xlarge"
  #availability_zones = ["us-east-1a","us-east-1b","us-east-1c"]
  dcos_version = "1.12.0"

  dcos_variant              = "ee"
  dcos_license_key_contents = "${file("./license.txt")}"
  # dcos_variant = "open"

  dcos_install_mode = "${var.dcos_install_mode}"
  dcos_resolvers      = "\n   - 169.254.169.253"
}

output "masters-ips" {
  value = "${module.dcos.masters-ips}"
}

output "cluster-address" {
  value = "${module.dcos.masters-loadbalancer}"
}

output "public-agents-loadbalancer" {
  value = "${module.dcos.public-agents-loadbalancer}"
}
