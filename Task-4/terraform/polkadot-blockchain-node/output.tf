output "name" {
  value = data.aws_key_pair.aws-key.key_name
}

output "id" {
  value = data.aws_key_pair.aws-key.id
}