locals {
  name= var.env != "" ? "${var.component_name}-${var.env}": var.component_name
  db_commands=[
    "rm -rf Roboshop",
    "git clone https://github.com/ManikantGV/Roboshop",
    "cd Roboshop",
    "sudo bash ${var.component_name}.sh ${var.password}"
  ]
  app_commands=[
    "sudo labauto ansible",
    "ansible-playbook -i localhost -u https://github.com/ManikantGV/roboshop-ansible.git roboshop.yml -e env=${var.env} -e rolename=${var.component_name}"

  ]
}