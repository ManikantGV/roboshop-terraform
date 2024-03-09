
resource "aws_instance" "instance" {
  #count = length(var.components)
  ami           = data.aws_ami.centos.image_id
  instance_type = var.instance_type
  vpc_security_group_ids = [ data.aws_security_group.allow-all.id ]
  iam_instance_profile = aws_iam_instance_profile.instance_profile.name

  tags = {
    Name = var.component_name
  }
}

resource "null_resource" "provisioner" {

  depends_on = [aws_instance.instance,aws_route53_record.records]
  triggers = {
    private_ip=aws_instance.instance.private_ip
  }
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

resource "aws_iam_role" "role" {
  name = "${var.component_name}-${var.env}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    tag-key = "${var.component_name}-${var.env}"
  }
}

resource "aws_iam_instance_profile" "instance_profile" {
  name = "${var.component_name}-${var.env}"
  role = aws_iam_role.role.name
}

resource "aws_iam_role_policy" "ssm_ps_policy" {
  name = "${var.component_name}-${var.env}-ssm-ps-policy"
  role = aws_iam_role.role.id

   policy = jsonencode(
     {
       "Version": "2012-10-17",
       "Statement": [
         {
           "Sid": "VisualEditor0",
           "Effect": "Allow",
           "Action": [
             "kms:Decrypt",
             "ssm:GetParameterHistory",
             "ssm:GetParametersByPath",
             "ssm:GetParameters",
             "ssm:GetParameter"
           ],
           "Resource": [
             "arn:aws:ssm:us-east-1:*:parameter/${var.env}.${var.component_name}.*",
             "arn:aws:kms:us-east-1:*:key/7e4262e5-239e-4f6b-95ab-0bffe6e41f9c"

           ]
         }
       ]
     }
   )
}