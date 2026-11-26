
resource "aws_autoscaling_policy" "cpu_scaling" {
  name                   = "${var.project_name}-cpu-scaling"
  policy_type            = "TargetTrackingScaling"
  autoscaling_group_name = aws_autoscaling_group.main.name

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 60.0
  }
}
