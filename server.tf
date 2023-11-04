data "aws_ami" "centos" {
  most_recent      = true
  name_regex       = "Centos-8-DevOps-Practice"
  owners           = ["973714476881"]

}

data "aws_security_group" "allow-all" {
  name="allow-all"
}

#variable "instance_type" {
#  default = "t3.small"
#}

output "ami" {
  value = data.aws_ami.centos.image_id
}

variable "components" {
  default = {
    frontend={
      name="frontend"
      instance_type="t3.small"
    }
    mongodb={
      name="mongodb"
      instance_type="t3.micro"
    }
    catalogue={
      name="catalogue"
      instance_type="t3.small"
    }
  }

}

resource "aws_instance" "instance" {
  #count = length(var.components)
  for_each = var.components
  ami           = data.aws_ami.centos.image_id
  instance_type = each.value["instance_type"]
  vpc_security_group_ids = [ data.aws_security_group.allow-all.id ]

  tags = {
    Name = each.value["name"]
  }
}

resource "aws_route53_record" "frontend" {
  for_each = var.components
  zone_id = "Z08997022LLSW1K3YTGW4"
  name    = "${each.value["name"]}.guntikadevops.online"
  type    = "A"
  ttl     = 300
  records = [aws_instance.instance[each.value["Name"]].private_ip]
}

#
#resource "aws_instance" "frontend" {
#  ami           = data.aws_ami.centos.image_id
#  instance_type = var.instance_type
#  vpc_security_group_ids = [ data.aws_security_group.allow-all.id ]
#
#  tags = {
#    Name = "frontend"
#  }
#}
#
#resource "aws_route53_record" "frontend" {
#  zone_id = "Z08997022LLSW1K3YTGW4"
#  name    = "frontend.guntikadevops.online"
#  type    = "A"
#  ttl     = 300
#  records = [aws_instance.frontend.private_ip]
#}
#
#resource "aws_instance" "mongo" {
#  ami           = data.aws_ami.centos.image_id
#  instance_type = var.instance_type
#  vpc_security_group_ids = [ data.aws_security_group.allow-all.id ]
#
#  tags = {
#    Name = "mongo"
#  }
#}
#
#resource "aws_route53_record" "mongo" {
#  zone_id = "Z08997022LLSW1K3YTGW4"
#  name    = "mongo.guntikadevops.online"
#  type    = "A"
#  ttl     = 300
#  records = [aws_instance.mongo.private_ip]
#}
#
#resource "aws_instance" "catalogue" {
#  ami           = data.aws_ami.centos.image_id
#  instance_type = var.instance_type
#  vpc_security_group_ids = [ data.aws_security_group.allow-all.id ]
#
#  tags = {
#    Name = "catalogue"
#  }
#}
#
#resource "aws_instance" "cart" {
#  ami           = data.aws_ami.centos.image_id
#  instance_type = var.instance_type
#  vpc_security_group_ids = [ data.aws_security_group.allow-all.id ]
#
#  tags = {
#    Name = "cart"
#  }
#}
#
#resource "aws_instance" "redis" {
#  ami           = data.aws_ami.centos.image_id
#  instance_type = var.instance_type
#  vpc_security_group_ids = [ data.aws_security_group.allow-all.id ]
#
#  tags = {
#    Name = "redis"
#  }
#}
#
#resource "aws_instance" "user" {
#  ami           = data.aws_ami.centos.image_id
#  instance_type = var.instance_type
#  vpc_security_group_ids = [ data.aws_security_group.allow-all.id ]
#
#  tags = {
#    Name = "user"
#  }
#}
#
#resource "aws_instance" "mysql" {
#  ami           = data.aws_ami.centos.image_id
#  instance_type = var.instance_type
#  vpc_security_group_ids = [ data.aws_security_group.allow-all.id ]
#
#  tags = {
#    Name = "mysql"
#  }
#}
#
#resource "aws_instance" "shipping" {
#  ami           = data.aws_ami.centos.image_id
#  instance_type = var.instance_type
#  vpc_security_group_ids = [ data.aws_security_group.allow-all.id ]
#
#  tags = {
#    Name = "shipping"
#  }
#}
#
#resource "aws_instance" "rabbitmq" {
#  ami           = data.aws_ami.centos.image_id
#  instance_type = var.instance_type
#  vpc_security_group_ids = [ data.aws_security_group.allow-all.id ]
#
#  tags = {
#    Name = "rabbitmq"
#  }
#}
#
#resource "aws_instance" "payment" {
#  ami           = data.aws_ami.centos.image_id
#  instance_type = var.instance_type
#  vpc_security_group_ids = [ data.aws_security_group.allow-all.id ]
#
#  tags = {
#    Name = "payment"
#  }
#}