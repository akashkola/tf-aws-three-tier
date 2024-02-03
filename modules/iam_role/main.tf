resource "aws_iam_role" "iam_role" {
  name               = var.role_name
  assume_role_policy = jsonencode(var.assume_role_policy)
}

data "aws_iam_policy" "policies" {
  for_each = toset([for policy_arn in var.policy_arns : policy_arn])
  arn      = each.value
}

resource "aws_iam_role_policy_attachment" "iam_policy_attachments" {
  for_each = toset([for policy in data.aws_iam_policy.policies : policy.arn])

  policy_arn = each.value
  role       = aws_iam_role.iam_role.name
}
