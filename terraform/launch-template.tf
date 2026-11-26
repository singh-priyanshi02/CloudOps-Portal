
# Find latest Windows Server 2022 AMI
data "aws_ami" "windows" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["Windows_Server-2022-English-Full-Base-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

# Windows EC2 Launch Template
resource "aws_launch_template" "windows" {
  name_prefix   = "${var.project_name}-windows-"
  image_id      = data.aws_ami.windows.id
  instance_type = var.instance_type

  vpc_security_group_ids = [
    aws_security_group.ec2_sg.id
  ]

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_profile.name
  }

  user_data = base64encode(
    templatefile("${path.module}/userdata.ps1", {
      artifact_bucket = aws_s3_bucket.artifacts.bucket
      artifact_key    = "releases/CloudOpsPortal.zip"
    })
  )

  monitoring {
    enabled = true
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "${var.project_name}-windows-ec2"
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}
