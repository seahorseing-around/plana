output "cluster_id" {
    value = aws_ecs_cluster.plana_cluster.id
}

output "green_tg" {
    value = aws_alb_target_group.squid_tg.id
}

output "blue_tg" {
    value = aws_alb_target_group.nginx_tg.id
}

output "ecs_sg" {
    value = aws_security_group.ecs_sg.id
}

output "priv_subnets" {
    value = values(aws_subnet.plana_private)[*].id
}