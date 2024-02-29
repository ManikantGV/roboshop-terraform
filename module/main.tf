
resource "aws_instance" "instance" {
  #count = length(var.components)
  ami           = data.aws_ami.centos.image_id
  instance_type = var.instance_type
  vpc_security_group_ids = [ data.aws_security_group.allow-all.id ]

  tags = {
    Name = var.component_name
  }
}

resource "null_resource" "provisioner" {

  depends_on = [aws_instance.instance,aws_route53_record.records]
  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      user     = "centos"
      password = "DevOps321"
      host     = aws_instance.instance.private_ip
    }

    inline= var.app_type == "db" ? local.db_commands: local.app_commands

  }
}

resource "aws_route53_record" "records" {
   zone_id = "Z08997022LLSW1K3YTGW4"
  name    = "${var.component_name}-dev.guntikadevops.online"
  type    = "A"
  ttl     = 30
  records = [aws_instance.instance.private_ip]
}

