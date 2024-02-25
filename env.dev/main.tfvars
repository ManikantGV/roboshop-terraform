apps_servers= {
  frontend= {
    name="frontend"
    instance_type="t3.small"
  }
   catalogue= {
    name="catalogue"
    instance_type="t3.small"
  }
  user= {
    name="user"
    instance_type="t3.small"
  }
  cart= {
    name="cart"
    instance_type="t3.small"
  }
  shipping= {
    name="shipping"
    instance_type="t3.small"
    password="RoboShop@1"
  }
  payment= {
    name="payment"
    instance_type="t3.small"
    #password="roboshop123"
  }
  dispatch= {
    name="dispatch"
    instance_type="t3.small"

  }
}

env = "dev"

database_servers = {
  mongodb= {
    name="mongodb"
    instance_type="t3.micro"
  }
  mysql= {
    name="mysql"
    instance_type="t3.small"
    password="RoboShop@1"
  }
  rabbitMQ= {
    name="rabbitMQ"
    instance_type="t3.small"
    password="roboshop123"
  }
  redis= {
    name="redis"
    instance_type="t3.small"
  }
}
