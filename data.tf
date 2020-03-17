data "aws_iam_policy_document" "lambda_trust_profile" {
  statement {
    sid = "LambdaServiceTrust"

    principals {
      type = "Service"

      identifiers = [
        "lambda.amazonaws.com",
      ]
    }

    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]
  }
}

data "aws_s3_bucket_object" "object" {
  bucket = var.artifact_bucket
  key    = var.path_to_lambda_object
}
