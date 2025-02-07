resource "aws_glue_job" "etl_spotify_job" {
  name     = "spotify_etl_job"
  role_arn = aws_iam_role.GlueProjetoSpotifyRole.arn

  command {
    script_location = "s3://s3-stage-datawarehouse-projeto-spotify/script/etl_spotify_job.py"
    python_version  = "3"
  }

  default_arguments = {
    "--output_path"                      = "s3://s3-stage-datawarehouse-projeto-spotify/datawarehouse/"
    "--enable-continuous-cloudwatch-log" = "true"
    "--continuous-log-logGroup"          = aws_cloudwatch_log_group.logs_glue.name
  }

  glue_version      = "5.0"
  number_of_workers = 5
  worker_type       = "G.1X"

}

