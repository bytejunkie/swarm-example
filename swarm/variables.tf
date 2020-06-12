variable "project" {
    default = "byt"
}

variable "environment" {
    default = "dev"
}

variable "instance_names" {
    default = [
        "manager",
        "worker1",
        "worker2"
    ]
}


variable "interface_service_endpoints" {
    default = [
        "com.amazonaws.eu-west-2.ssm",
        "com.amazonaws.eu-west-2.ec2messages",
        "com.amazonaws.eu-west-2.ec2",
        "com.amazonaws.eu-west-2.ssmmessages" 
    ]
}