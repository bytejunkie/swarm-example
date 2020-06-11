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