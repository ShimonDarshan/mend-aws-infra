# Route53 Hosted Zone (create this separately first)
resource "aws_route53_zone" "main" {
  name = "shimondarshan-aws-mend.com"

  tags = {
    Name        = "shimondarshan-aws-mend.com"
    Environment = "development"
    ManagedBy   = "terraform"
  }
}

output "route53_zone_id" {
  description = "Route53 hosted zone ID"
  value       = aws_route53_zone.main.zone_id
}

output "route53_name_servers" {
  description = "Route53 name servers - update these in your domain registrar"
  value       = aws_route53_zone.main.name_servers
}
