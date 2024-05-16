variable "region" {
    description = "The region where you want to deploy the AWS resource"
    type        = string
}

variable "thing_types" {
    description = "The list of thing type names which we want to create"
    type        = list
}

variable "profile" {
    description = "The aws profile by using which you want to deploy resources"
    type        = string
}