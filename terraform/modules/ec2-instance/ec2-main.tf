################################### DATA ###############################################

data "aws_ami" "aws-linux" {
  most_recent = true ## to get the latest and greatest image ##
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

################################### RESOURCES ###############################################


# INSTANCES #
resource "aws_instance" "instance1" {
  ami                    = data.aws_ami.aws-linux.id
  instance_type          = "t2.micro"
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.security_group_ids
  key_name               = var.key_name

  root_block_device {
    encrypted   = true
  }
}

resource "aws_ebs_volume" "awsvolume" {
  availability_zone = "eu-west-1a"
  size = 30
  encrypted = "true"

  tags = {
    name = "new_volume_mount_to_ec2"
  }
}
resource "aws_volume_attachment" "mountvolumetoec2" {
  device_name = "/dev/sdd"
  instance_id = "${aws_instance.instance1.id}"
  volume_id = "${aws_ebs_volume.awsvolume.id}"
}

##################################################################################
# OUTPUT
##################################################################################

output "aws_instance_public_dns" {
  value = aws_instance.instance1.public_dns
}

##################################################################################
# VARIABLES
##################################################################################

variable "key_name" {
  type = string
 description = "key name"
 default = "Neeharika_Terraform"
}
variable "region" {
  type    = string
  default = "eu-west-1"
  description = "Name of the region to create resource"
}

variable "subnet_id" {
  type        = string
  description = "Subnet ids of the ec2 instance"
}

variable "security_group_ids" {
  description = "List of security group IDs to attach to the EC2 instance."
  type        = list(string)
}