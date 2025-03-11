resource "aws_sns_topic" "glue-error-alert" {
  name = "glue-job-error-notification"
}

resource "aws_sns_topic_subscription" "glue-error-subscription" {
  topic_arn = aws_sns_topic.glue-error-alert.arn
  protocol  = "email"
  endpoint  = "hakeem.salaudeen@outlook.com"
}

resource "aws_cloudwatch_event_rule" "glue-job-failure" {
  name        = "salesproject-job-failure-rule"
  description = "Trigger when salesproject Glue job fails"

  event_pattern = <<PATTERN
{
  "source": ["aws.glue"],
  "detail-type": ["Glue Job State Change"],
  "detail": {
    "state": ["FAILED", "TIMEOUT"],
    "jobName": ["salesproject-job"]
  }
}
PATTERN
}

resource "aws_cloudwatch_event_target" "sns" {
  rule      = aws_cloudwatch_event_rule.glue-job-failure.name
  target_id = "SendToSNS"
  arn       = aws_sns_topic.glue-error-alert.arn
}

resource "aws_sns_topic_policy" "sns-policy" {
  arn    = aws_sns_topic.glue-error-alert.arn
  policy = data.aws_iam_policy_document.sns-topic-policy.json
}

data "aws_iam_policy_document" "sns-topic-policy" {
  statement {
    effect  = "Allow"
    actions = ["SNS:Publish"]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }

    resources = [aws_sns_topic.glue-error-alert.arn]
  }
}























# # SNS topic for Lambda errors
# resource "aws_sns_topic" "lambda-error" {
#   name = "lambda-job-error-notification"
# }

# # SNS subscription for Lambda errors
# resource "aws_sns_topic_subscription" "lambda_error_subscription" {
#   topic_arn = aws_sns_topic.lambda-error.arn
#   protocol  = "email"
#   endpoint  = "hakeem.salaudeen@outlook.com"
# }
