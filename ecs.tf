resource "aws_ecs_cluster" "web-cluster" {
  name               = "${local.prefix}-ecs-cluster"
  capacity_providers = [aws_ecs_capacity_provider.test.name]
  tags = local.common_tags
}

resource "aws_ecs_capacity_provider" "test" {
  name = "${local.prefix}-capacity-provider"
  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.asg.arn
    managed_termination_protection = "ENABLED"

    managed_scaling {
      status          = "ENABLED"
      target_capacity = 85
    }
  }
}

resource "aws_ecs_task_definition" "task-definition-test" {
  family                = "web-family"
  container_definitions = file("container-definitions/container-def.json")
  network_mode          = "bridge"
  task_role_arn = var.task_role_arn
  tags = local.common_tags
  volume {
    name      = "drupal-sites"
    host_path = "/var/www/html/sites"
  }

}

resource "aws_ecs_service" "service" {
  name            = "${local.prefix}-test"
  cluster         = aws_ecs_cluster.web-cluster.id
  task_definition = aws_ecs_task_definition.task-definition-test.arn
  desired_count   = 2
  ordered_placement_strategy {
    type  = "binpack"
    field = "cpu"
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.lb_target_group.arn
    container_name   = "drupal"
    container_port   = 80
  }
  launch_type = "EC2"
  depends_on  = [aws_lb_listener.api_https]
}

resource "aws_cloudwatch_log_group" "log_group" {
  name = "/ecs/northone"
  tags = local.common_tags
}