variable "role_name" {
  type        = string
  description = "name of the IAM role"
}

variable "assume_role_policy" {
  type = object({
    Version = string
    Statement = list(object({
      Action = string
      Effect = string
      Sid    = string
      Principal = object({
        Service = string
      })
    }))
  })

  description = "Policy that grants an entity permission to assume the role"
}

variable "policy_arns" {
  type        = set(string)
  description = "arn's of policies"
}
