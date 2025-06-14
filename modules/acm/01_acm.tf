# ACM(aws certificate manager), SSL 인증서 생성
resource "aws_acm_certificate" "cert" {
  domain_name               = var.acm_domains
  subject_alternative_names = var.acm_sub_domains
  validation_method         = "DNS"

  tags = {
    Name = "acm-${var.env}-${var.pjt}-ssl"
  }

  lifecycle {
    ignore_changes = [
      domain_name, subject_alternative_names, validation_method
    ]
  }
}

# aws_route53_record 에서 certification 용으로 레코드 별도 생성
resource "aws_route53_record" "cert_validation" {
  name    = lookup(tolist(aws_acm_certificate.cert.domain_validation_options)[0], "resource_record_name")
  records = [lookup(tolist(aws_acm_certificate.cert.domain_validation_options)[0], "resource_record_value")]
  type    = lookup(tolist(aws_acm_certificate.cert.domain_validation_options)[0], "resource_record_type")
  ttl     = 60
  zone_id = data.aws_route53_zone.domain.zone_id
}

# DNS(route53)로 인증서 validation check
resource "aws_acm_certificate_validation" "cert" {
  depends_on              = [aws_route53_record.cert_validation]
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = ["${aws_route53_record.cert_validation.fqdn}"]
}