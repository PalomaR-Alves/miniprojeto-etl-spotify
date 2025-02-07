output "sys_user_password" {
  value     = aws_iam_user_login_profile.sys_login.password
  sensitive = true # para expor a senha do user criado no terminal
}