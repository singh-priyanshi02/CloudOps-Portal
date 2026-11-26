
# Auto Scaling Group
resource "aws_autoscaling_group" "main" {
  name = "${var.project_name}-asg"

  min_size         = var.min_size
  desired_capacity = var.desired_capacity
  max_size         = var.max_size

  vpc_zone_identifier = [
    aws_subnet.private_1.id,
    aws_subnet.private_2.id
  ]

  target_group_arns = [
    aws_lb_target_group.main.arn
  ]

  launch_template {
    id      = aws_launch_template.windows.id
    version = "$Latest"
  }

  health_check_type         = "ELB"
  health_check_grace_period = 900

  wait_for_capacity_timeout = "15m"

  tag {
    key                 = "Name"
    value               = "${var.project_name}-windows-instance"
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = "Development"
    propagate_at_launch = true
  }
}
