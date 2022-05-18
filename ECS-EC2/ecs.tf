resource "aws_ecs_cluster" "ecs-cluster" {
  name = "ecs-cluster"
}

resource "aws_launch_configuration" "ecs" {
  name                        = "${var.name}-for ECS"
  image_id                    = var.amis # lookup(var.amis, var.aws_region)
  instance_type               = var.instance_type
  security_groups             = [aws_security_group.ecs_sg.id]
  iam_instance_profile        = aws_iam_instance_profile.ecs.name
  associate_public_ip_address = true
  user_data                   = "#!/bin/bash\necho ECS_CLUSTER='ecs-cluster' > /etc/ecs/ecs.config"
}

data "template_file" "nginx-app" {
  template = file("./task-definitions/image.json")

  vars = {
    app_image      = var.app_image
    app_port       = var.app_port
    fargate_cpu    = var.fargate_cpu
    fargate_memory = var.fargate_memory
    aws_region     = var.aws_region
  }
}

resource "aws_ecs_task_definition" "ecs-def" {
  family                   = "task-definition-1"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "bridge"
  requires_compatibilities = ["EC2"]
  # cpu                      = var.fargate_cpu
  # memory                   = var.fargate_memory
  container_definitions    = data.template_file.nginx-app.rendered
}

resource "aws_ecs_service" "ecs-service" {
  name            = "ecs-service"
  cluster         = aws_ecs_cluster.ecs-cluster.id
  task_definition = aws_ecs_task_definition.ecs-def.arn
  #iam_role        = aws_iam_role.ecs-service-role.arn
  desired_count   = var.app_count
  launch_type     = "EC2"


  # network_configuration {
  #   security_groups  = [aws_security_group.ecs_sg.id]
  #   subnets          = aws_subnet.private.*.id
  #   assign_public_ip = false  # Assign a public IP address to the ENI (Fargate launch type only). Valid values are true or false. Default false
  # }

  load_balancer {
    target_group_arn = aws_alb_target_group.myapp-tg.arn
    container_name   = "nginx-app"
    container_port   = var.app_port
  }

  depends_on = [aws_alb_listener.nginx-app, aws_iam_role_policy_attachment.ecs_task_execution_role, aws_iam_role_policy.ecs-service-role-policy]
}
