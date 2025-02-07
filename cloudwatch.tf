# cria um log group para o job enviar os logs
resource "aws_cloudwatch_log_group" "logs_glue" {
  name = "/aws-glue/etl_spotify_job"
}