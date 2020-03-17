locals {
  archive_file_dir = "${path.module}/lib/"

  lambda_permissions = concat([
    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"],
    var.extra_policy_arns
  )

  iam_role_arn = coalescelist(aws_iam_role.lambda_role.*.arn, [
    var.role_arn])

  environment_map = var.variables == null ? [] : [
    var.variables]


}

resource "random_id" "randomid" {
  byte_length = 4
}

resource "aws_lambda_function" "lambda_function" {
  s3_bucket = data.aws_s3_bucket_object.object.bucket
  s3_key = data.aws_s3_bucket_object.object.key
  s3_object_version = data.aws_s3_bucket_object.object.version_id

  function_name = var.function_name
  description = var.description

  handler = var.handler
  runtime = var.runtime
  timeout = var.timeout
  memory_size = var.memory_size
  role = local.iam_role_arn[0]

  vpc_config {
    security_group_ids = var.security_group_ids
    subnet_ids = var.subnet_ids
  }

  dynamic "environment" {
    for_each = length(keys(var.variables)) > 0? [
      "dummy"]:[]
    content {
      variables = var.variables
    }
  }

  tags = var.tags

}

##########
# Lambda Role
##########
resource "aws_iam_role" "lambda_role" {
  count = var.create_role ? 1 : 0

  name = "${var.function_name}-Role-${random_id.randomid.hex}"
  assume_role_policy = data.aws_iam_policy_document.lambda_trust_profile.json

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "attach" {
  count = var.create_role ? length(local.lambda_permissions) : 0

  role = element(concat(aws_iam_role.lambda_role.*.name, list("")), 0)
  policy_arn = element(local.lambda_permissions, count.index)
}

###########
# Lambda Schedule event 
###########
resource "aws_cloudwatch_event_rule" "schedule_event" {
    name = "${var.function_name}-schedule-event"
    description = "Triggers on a schedule to keep Lambda warm"
    schedule_expression = var.event_rule_schedule
}

resource "aws_cloudwatch_event_target" "check_lambda_on_schedule" {
    rule = "${aws_cloudwatch_event_rule.schedule_event.name}"
    target_id = "${var.function_name}-event-targetId"
    arn = "${aws_lambda_function.lambda_function.arn}"
}

# create role to allow schedule execution
resource "aws_lambda_permission" "allow_cloudwatch_to_schedule_lambda" {
    statement_id = "AllowExecutionFromCloudWatch"
    action = "lambda:InvokeFunction"
    function_name = "${var.function_name}"
    principal = "events.amazonaws.com"
    source_arn = "${aws_cloudwatch_event_rule.schedule_event.arn}"
}