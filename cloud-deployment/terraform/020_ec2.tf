#######################################################################################################################################
# Deploy EC2:
#   - EC2 instance
#   - security group
#######################################################################################################################################

#############################################
# AMI
#############################################

data "aws_ami" "ubuntu_ami" {

  most_recent = true
  owners = ["${var.ubuntu_account_number}"]

  filter {
    name   = "name"
    values = ["*${var.ubuntu_version}*"]
  }

  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name = "architecture"
    values = ["x86_64"]
  }
}

#############################################
# INSTANCE
#############################################

resource "aws_instance" "ec2_instance" {

  ami                         = data.aws_ami.ubuntu_ami.id
  instance_type               = var.instance_type
  #vpc_security_group_ids      = [module.vpc.default_vpc_default_security_group_id]
  subnet_id                   = module.vpc.public_subnets[0]
  key_name                    = "magnetDev"
  associate_public_ip_address = "true"

  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt install python -y",
    ]
  }

  connection {
    type = "ssh"
    user = "ubuntu"
    host = self.public_ip
    private_key = "${file("data/magnetDev.pem")}"
  }

  tags = merge(
    {
      "Name" = "${var.project_name}-instance"
    },
  )
}

module "icinga2_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.8.0"

  name   = "${var.project_name}-sg"
  vpc_id = module.vpc.vpc_id

  ingress_with_cidr_blocks = local.ingress_all
  egress_with_cidr_blocks  = local.egress_all
}