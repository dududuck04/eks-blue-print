variable "env" {}
variable "pjt" {}

variable "roles" {
  default = {}
}

variable "users" {
  default = {}
}

variable "groups" {
  default = {}
}

variable "policy" {
  default = {}
}

variable "assume_role_policy" {
  default = {}
}

variable "account_alias" {}

variable "password_policy" {
  default = {
    max_password_age               = 90
    minimum_password_length        = 14
    allow_users_to_change_password = true
    hard_expiry                    = false
    password_reuse_prevention      = 24
    require_lowercase_characters   = true
    require_uppercase_characters   = true
    require_numbers                = true
    require_symbols                = true
  }
}