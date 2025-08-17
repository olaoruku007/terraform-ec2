deploy_in = "all"

subnet_configs = {
  terraform-pro1 = {
    count         = 2
    ami           = "ami-0c02fb55956c7d316"
    instance_type = "t2.micro"
    key_name      = "dev-key"
    user_data     = <<EOT
#!/bin/bash
yum update -y
yum install -y httpd
systemctl start httpd
echo "Hello from terraform-pro1 webserver" > /var/www/html/index.html
EOT
  }

  terraform-pro2 = {
    count         = 1
    ami           = "ami-0a887e401f7654935"
    instance_type = "t3.small"
    key_name      = "test-key"
  }

  terraform-pro4 = {
    count         = 1
    ami           = "ami-083654bd07b5da81d"
    instance_type = "t3.large"
    key_name      = "db-key"
    user_data     = <<EOT
#!/bin/bash
yum update -y
amazon-linux-extras install -y postgresql14
echo "PostgreSQL setup on terraform-pro4" > /var/log/db_setup.log
EOT
  }
}
