output "iot_cert_arn" {
    value = aws_iot_certificate.device_registration_cert.arn
}

output "iot_cert_pem" {
    value       = aws_iot_certificate.device_registration_cert.certificate_pem
    sensitive   = true
}

output "iot_cert_public_key" {
    value       = aws_iot_certificate.device_registration_cert.public_key
    sensitive   = true
}

output "iot_cert_private_key" {
    value       = aws_iot_certificate.device_registration_cert.private_key
    sensitive   = true
}