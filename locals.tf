# policies já existentes na AWS
locals {
  policies = [
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/AWSGlueConsoleFullAccess",
    "arn:aws:iam::aws:policy/AmazonAthenaFullAccess",
    "arn:aws:iam::aws:policy/service-role/AWSQuicksightAthenaAccess",
    "arn:aws:iam::aws:policy/service-role/AWSQuickSightDescribeRDS"
  ]

  glue_policies = [
    "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess",
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
  ]

  dados = [
    # caminho relativo do arquivo considerando a pasta "arquitetura" no mesmo nível que locals.tf
    { nome = "albums", caminho = "arquitetura/data/albums.csv" },
    { nome = "artists", caminho = "arquitetura/data/artists.csv" },
    { nome = "track", caminho = "arquitetura/data/track.csv" }
  ]

  script = { nome = "etl_spotify_job.py", caminho = "arquitetura/script/etl_spotify_job.py" }
}

