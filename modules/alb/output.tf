output "load_balancer_arn" {
  value = aws_lb.twot_alb.arn
}

output "target_group_arn" {
  value = aws_lb_target_group.twot_tg.arn
}

output "aws_lb_listener_arn" {
  value = aws_lb_listener.twot_listener.arn
}
