variable "region" {
  description = "The AWS region to deploy the infrastructure"
  type        = string
  default     = "us-west-1"
}

variable "Environment" {
  description = "The environment for the infrastructure"
  type        = string
  default     = "prod"
}


variable "deploy_in" {
  description = "Where to deploy EC2: public | private | all"
  type        = string
  default     = "public"
}

variable "default_ami" {
  description = "Default AMI to use if not specified per subnet"
  type        = string
  default     = "ami-0c02fb55956c7d316"
}

variable "default_instance_type" {
  description = "Default instance type if not specified per subnet"
  type        = string
  default     = "t2.micro"
}

variable "subnet_configs" {
  description = "Configuration per subnet: count, ami, instance_type, key_name, user_data"
  type = map(object({
    count         = number
    ami           = string
    instance_type = string
    key_name      = optional(string)
    user_data     = optional(string)
  }))
  default = {}
}
