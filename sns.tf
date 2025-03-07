resource "aws_sns_topic" "glue-error" {
  name = "glue-job-error-notification"
}

resource "aws_sns_topic_subscription" "glue-error-subscription" {
  topic_arn = aws_sns_topic.glue-error.arn
  protocol  = "email"
  endpoint  = "hakeem.salaudeen@outlook.com"
}

# SNS topic for Lambda errors
resource "aws_sns_topic" "lambda-error" {
  name = "lambda-job-error-notification"
}

# SNS subscription for Lambda errors
resource "aws_sns_topic_subscription" "lambda_error_subscription" {
  topic_arn = aws_sns_topic.lambda-error.arn
  protocol  = "email"
  endpoint  = "hakeem.salaudeen@outlook.com"
}
