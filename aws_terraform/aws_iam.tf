resource "aws_iam_instance_profile" "ad_profile" {
  name = "ad_role"
  role = aws_iam_role.ad_role.name
}

resource "aws_iam_role" "ad_role" {
  name = "ad_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

data "aws_iam_policy" "amazon_ssm_managed_instance_core" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

data "aws_iam_policy" "amazon_ssm_directory_service_access" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMDirectoryServiceAccess"
}

resource "aws_iam_role_policy_attachment" "ssm_managed_instance_core_to_ad_role" {
  role       = aws_iam_role.ad_role.name
  policy_arn = data.aws_iam_policy.amazon_ssm_managed_instance_core.arn
}

resource "aws_iam_role_policy_attachment" "ssm_directory_service_access_to_ad_role" {
  role       = aws_iam_role.ad_role.name
  policy_arn = data.aws_iam_policy.amazon_ssm_directory_service_access.arn
}