output "acm_arn" {
  description = "ACM for Certification ARN"
  value       = try({ for k, v in aws_acm_certificate.cert : k => v.arn }, "")
}
