variable "function_name" {
  description = "A unique name for your Lambda Function"
}

variable "handler" {
  description = "The function entrypoint in your code"
}

variable "role_arn" {
  description = "IAM role attached to the Lambda Function. This governs both who / what can invoke your Lambda Function, as well as what resources our Lambda Function has access to"
  default = ""
}

variable "create_role" {
  description = "Tue or False on if to create the default role. Set to false if your going to pass in your own role via the var role_arn"
  default = true
}

variable "runtime" {
  description = "See [documentation](https://docs.aws.amazon.com/lambda/latest/dg/API_CreateFunction.html#SSS-CreateFunction-request-Runtime) for valid values"
}

variable "tags" {
  description = "Map of tags to assign to the resources"
  default = {}
}

variable "artifact_bucket" {
  description = "The S3 bucket where the Lambda source code exists"
}

variable "path_to_lambda_object" {
  description = "The path to the object in the S3 bucket"
}

variable "timeout" {
  description = "The amount of time your Lambda Function has to run in seconds. Defaults to 3. See [Limits](https://docs.aws.amazon.com/lambda/latest/dg/limits.html)"
  default = 3
}

variable "memory_size" {
  description = "Amount of memory in MB your Lambda Function can use at runtime. Defaults to 128. See [Limits](https://docs.aws.amazon.com/lambda/latest/dg/limits.html)"
  default = 128
}

variable "variables" {
  default = {}
  description = "A map that defines environment variables for the Lambda function"
}

variable "reserved_concurrent_executions" {
  default = -1
  description = "The amount of reserved concurrent executions for this lambda function. A value of 0 disables lambda from being triggered and -1 removes any concurrency limitations. Defaults to Unreserved Concurrency Limits -1. See [Managing Concurrency](https://docs.aws.amazon.com/lambda/latest/dg/scaling.html)"
}

variable "description" {
  default = ""
  description = "Description of what your Lambda Function does"
}

variable "extra_policy_arns" {
  default = []
  type = list(string)
  description = "Extra policy ARNs to attach to the Lambda role"
}

variable "security_group_ids" {
  default = []
  description = "List of security group IDs to asign to your lambda if in a vpc."
}
variable "subnet_ids" {
  default = []
  description = "List of SubnetIDs to house your lambda inside a vpc"
}

variable "event_rule_schedule" {
    description = "The schedule in minutes the event rule triggers"
    default = "rate(10 minutes)"
}