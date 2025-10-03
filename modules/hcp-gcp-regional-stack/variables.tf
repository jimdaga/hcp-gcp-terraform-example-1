# Define the expected input variables
variable "region" {
  type = string
}

variable "stack_name" {
  type = string
}

variable "project" {
  type = object({
    existing = bool
  })
}

variable "gke" {
  type = object({
    mode = string
    type = string
  })
}

variable "vpc" {
  type = object({
    cidr   = string
    subnet = list(object({
      name = string
      cidr = string
    }))
  })
}
