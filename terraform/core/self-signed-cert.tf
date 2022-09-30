resource "tls_private_key" "self_sign_pk" {
  algorithm = "RSA"
}

resource "tls_self_signed_cert" "self_sign_cert" {
  private_key_pem = tls_private_key.self_sign_pk.private_key_pem

  subject {
    common_name  = aws_lb.plana_lb.dns_name # USE AWS ALB generated URL for cert
    organization = "AWS Spoof"
  }

  validity_period_hours = 1000

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}

resource "aws_acm_certificate" "acm_cert" {
  private_key      = tls_private_key.self_sign_pk.private_key_pem
  certificate_body = tls_self_signed_cert.self_sign_cert.cert_pem
}