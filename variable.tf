variable "salesprojectredshift-password" {
  description = "Password for Redshift admin user"
  type        = string
  sensitive   = true
}

variable "salesprojectredshift-username" {
  description = "username for Redshift admin user"
  type        = string
  sensitive   = true
}