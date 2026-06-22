resource "aws_security_group" "asg_sg" {
  name = "asg-sg"
  description = "Security group para el asg"
  vpc_id = var.vpc_id

    ingress { 
        from_port = 80
        to_port = 80
        protocol = "tcp"
        security_groups = [var.alb_security_group_id]
        description = "Trafico solo desde el load balancer"
    }

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Acceso ssh"
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Permitir todo el trafico de salida"
    }
}

resource "aws_launch_template" "lt" {
  name_prefix = "e-commerce-lt"
  image_id = "ami-0c2b8ca1dad447f8a"
  instance_type = "t3.micro"
  key_name = "vockey"
  user_data = base64encode(
    templatefile("${path.module}/e-commerce-install.sh.tpl",{
      db_endpoint = var.db_endpoint
      db_user = var.db_user
      db_password = var.db_password
      db_database = var.db_database
      git_token = var.git_token
 })
)

  vpc_security_group_ids = [aws_security_group.asg_sg.id]
  tags = {
    Name = "e-commerce-webserver"
  }
}

resource "aws_autoscaling_group" "asg" {
  name = "e-commerce-asg"
  desired_capacity = 2
  max_size = 6
  min_size = 2
  vpc_zone_identifier = var.private_subnet_ids
  target_group_arns = [var.target_group_arn]

  launch_template {
    id = aws_launch_template.lt.id
    version = "$Latest"
  }

  tag {
    key = "Name"
    value = "e-commerce-server"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "target" {
  name = "e-commerce-cpu-target"
  autoscaling_group_name = aws_autoscaling_group.asg.name
  policy_type = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 80.0 # Si la CPU supera el 80%, escala y si esta por debajo del 80%, reduce el número de instancias.
  }
}