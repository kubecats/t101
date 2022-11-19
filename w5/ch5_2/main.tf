 if var.enable_autoscaling {
    resource "aws_autoscaling_schedule" "scale_out_during_business_hours"
}
