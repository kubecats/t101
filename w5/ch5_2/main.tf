provider "aws" {
  region  = "ap-northeast-2"
}

# resource "aws_cloudwatch_metric_alarm" "high_cpu_utilization" {
#     alarm_name = "${var.cluster_name}-high-cpu-utilization"
#     namespace = "AWS/EC2"
#     metric_name = "CPUUtilization"

#     dimensions = {
#         AutoScalingGroupName = aws_autoscaling_group.example.name
#     }
#     comparison_operator = "GreaterThanThreshold"
#     evaluation_periods = 1
#     period = 300
#     statistic = "Average"
#     threshold = 90
#     unit = "Percent"
# }


# resource "aws_cloudwatch_metric_alarm" "low_cpu_credit_balance" {
#     # t계열에서만 사용할 수 있는 cpu credit monitoting 조건 설정
#     count = format("%.1s", var.instance_type ) == "t" ? 1:0

#     alarm_name = "${var.cluster_name}-low-cpu-credit-balance"
#     namespace = "AWS/EC2"
#     metric_name = "CPUCreditBalance"

#     dimensions = {
#         AutoScalingGroupName = aws_autoscaling_group.example.name
#     }
#     comparison_operator = "LessThanThreshold"
#     evaluation_periods = 1
#     period = 300
#     statistic = "Minimum"
#     threshold = 10
#     unit = "Count"
# }

# json file을 통한 iam policy 생성

resource "aws_iam_policy" "cloudwatch_read_only" {
    name = "cloudwatch-read-only"
    policy = data.aws_iam_policy_document.cloudwatch_read_only.json
}

data "aws_iam_policy_document" "cloudwatch_read_only" {
    statement {
        effect = "Allow"
        actions = [
            "cloudwatch:Describe*",
            "cloudwatch:Get*",
            "cloudwatch:List*",
        ]
        resources = ["*"]
    }
}


resource "aws_iam_policy" "cloudwatch_full_access" {
    name = "cloudwatch-full-access"
    policy = data.aws_iam_policy_document.cloudwatch_full_access.json
}

data "aws_iam_policy_document" "cloudwatch_full_access" {
    statement {
        effect = "Allow"
        actions = ["Cloudwatch:*"]
        resources = ["*"]
    }
}

# iam user 생성
resource "aws_iam_user" "hs" {
    name = "hs"
}

# policy 를 iam user에 attach
resource "aws_iam_user_policy_attachment" "hs_cloudwatch_full_access" {
    # 입력받은 변수를 조건문으로 사용하여 분기 처리
    count = var.give_hs_cloudwatch_full_access ? 1:0

    # user = aws_iam_user.example[0].name
    user = aws_iam_user.hs.name
    policy_arn = aws_iam_policy.cloudwatch_full_access.arn
}

resource "aws_iam_user_policy_attachment" "hs_cloudwatch_read_only" {
    count = var.give_hs_cloudwatch_full_access ? 0:1

    # user = aws_iam_user.example[0].name
    user = aws_iam_user.hs.name
    policy_arn = aws_iam_policy.cloudwatch_read_only.arn
}
