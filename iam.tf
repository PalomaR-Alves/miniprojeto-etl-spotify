# usuário
resource "aws_iam_user" "sys_user" {
  name = "sys_user"

  tags = {
    projeto = "spotify data engineering end-to-end"
  }
}

# login com senha (gerada no output)
resource "aws_iam_user_login_profile" "sys_login" {
  user = aws_iam_user.sys_user.name
}


resource "aws_iam_user_policy_attachment" "project_policies" {
  for_each   = toset(local.policies)
  user       = aws_iam_user.sys_user.name
  policy_arn = each.value
}


##############################################################
# trust policy para o glue
resource "aws_iam_role" "GlueProjetoSpotifyRole" {
  name = "GlueProjetoSpotifyRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "glue.amazonaws.com"
      }
    }]
  })
}

# anexo das policies à role GlueProjetoSpotifyRole para acesso ao S3 e geração de logs cloudwatch
resource "aws_iam_policy_attachment" "glue_s3_acesso" {
  for_each = toset(local.glue_policies)
  name       = "GlueS3Acesso"
  roles      = [aws_iam_role.GlueProjetoSpotifyRole.name]
  policy_arn = each.value
}

# criação de uma policy que dá acesso total a todas as ações do glue
resource "aws_iam_role_policy" "glue_access_policy" {
  name = "GlueFullAccess"
  role = aws_iam_role.GlueProjetoSpotifyRole.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "glue:*",
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

# criação de uma policy com PassRole para conseguir executar o script no notebook glue pelo console
resource "aws_iam_role_policy" "pass_role_policy" {
  name = "AllowPassRole"
  role = aws_iam_role.GlueProjetoSpotifyRole.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "iam:PassRole",
        Effect = "Allow",
        Resource = aws_iam_role.GlueProjetoSpotifyRole.arn,
        Condition = {
          StringEquals = {
            "iam:PassedToService": "glue.amazonaws.com"
          }
        }
      }
    ]
  })
}