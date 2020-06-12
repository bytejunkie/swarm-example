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


variable "service_endpoints" {
    default = {
        "com.amazonaws.eu-west-2.ssm" = "Interface"
        "com.amazonaws.eu-west-2.ec2messages" = "Interface"
        "com.amazonaws.eu-west-2.ec2" = "Interface"
        "com.amazonaws.eu-west-2.ssmmessages" = "Interface"
        "com.amazonaws.eu-west-2.s3" = "Gateway"
    }

}