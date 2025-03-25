resource "aws_lb" "twot_alb" {
  name               = "${var.twotproject}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg]
  subnets            = [var.pubsub_1, var.pubsub_2]

  enable_deletion_protection = false

  tags = {
    name = "${var.twotproject}-alb"
  }
}

#Target group
resource "aws_lb_target_group" "twot_tg" {
  name     = "${var.twotproject}-tg"
  target_type = "instance"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
 
  health_check {
   enabled = true
   healthy_threshold = 5
   interval = 300
   path = "/index.html"
   port = "traffic-port"
   protocol = "HTTP"
   matcher = "200"
   timeout = 30
   unhealthy_threshold = 3
 }
}

#Target group attachment
resource "aws_lb_target_group_attachment" "tg_attach1" {
  target_group_arn = aws_lb_target_group.twot_tg.arn
  target_id        = var.webserver1
  port             = 80
}
resource "aws_lb_target_group_attachment" "tg_attach2" {
  target_group_arn = aws_lb_target_group.twot_tg.arn
  target_id        = var.webserver2
  port             = 80
}

#Listener
resource "aws_lb_listener" "twot_listener" {
  load_balancer_arn = aws_lb.twot_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.twot_tg.arn
  }
}
