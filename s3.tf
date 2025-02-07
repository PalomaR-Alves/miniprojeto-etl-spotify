# bucket da camada de stage
resource "aws_s3_bucket" "bucket_s3" {
  bucket = "s3-stage-datawarehouse-projeto-spotify"

  tags = {
    name = "bucket de stage do projeto spotify"
  }
}

# pasta staging
resource "aws_s3_object" "staging" {
  bucket = aws_s3_bucket.bucket_s3.id
  key    = "staging/"
}

# pasta datawarehouse
resource "aws_s3_object" "datawarehouse" {
  bucket = aws_s3_bucket.bucket_s3.id
  key    = "datawarehouse/"
}

# pasta para csv albums
resource "aws_s3_object" "albums" {
  bucket = aws_s3_bucket.bucket_s3.id
  key    = "staging/albums/"
}

# pasta para csv artists
resource "aws_s3_object" "artists" {
  bucket = aws_s3_bucket.bucket_s3.id
  key    = "staging/artists/"
}

# pasta para csv track
resource "aws_s3_object" "track" {
  bucket = aws_s3_bucket.bucket_s3.id
  key    = "staging/track/"
}

# arquivos csv (datasets)
resource "aws_s3_object" "dados" {
  # o for_each abaixo cria um map onde a chave é o próprio nome do arquivo e o valor é o map original
  # do locals, ou seja, o conjunto de chaves "nome" e "caminho", resultando em algo parecido com:
  # {
  #   "albums.csv" = { nome = "albums.csv", caminho = "arquitetura/data/albums.csv" },
  # }
  # isso é necessário pois for_each aceita apenas maps
  for_each = { for arquivo in local.dados : arquivo.nome => arquivo }
  # fazer algum jeito de os arquivos serem enviados pra
  bucket = aws_s3_bucket.bucket_s3.id
  key    = "staging/${each.value.nome}/${each.value.nome}.csv"
  source = each.value.caminho
}

# para upar arquivo de script
resource "aws_s3_object" "script" {
  bucket = aws_s3_bucket.bucket_s3.id
  key    = "script/${local.script.nome}"
  source = local.script.caminho
  # identifica pelo hash do arquivo se ele foi modificado para que seja atualizado no bucket
  etag = filemd5(local.script.caminho)
}

