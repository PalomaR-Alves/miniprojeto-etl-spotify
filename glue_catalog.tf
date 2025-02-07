# um glue data catalog é um metastore que armazena metadados sobre fontes de dados, ele possui
# bancos e tabelas pra guardar informações sobre dados armazenados em locais como o S3, RDS e outros. 
# aqui é criado um metastore chamado "base_glue_s3"
resource "aws_glue_catalog_database" "glue_catalog" {
  name = "base_glue_s3"
}

# glue catalog table para metadados de albums.csv
resource "aws_glue_catalog_table" "glue_albums_table" {
  name          = "tabela_spotify_albums"
  database_name = aws_glue_catalog_database.glue_catalog.name
  table_type    = "EXTERNAL_TABLE" # é external pois a tabela referenciada não está dentro do glue

  storage_descriptor {
    location      = "s3://${aws_s3_bucket.bucket_s3.id}/staging/albums/"
    input_format  = "org.apache.hadoop.mapred.TextInputFormat" # ideal para csv
    output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"
    # ignoreKey é usado pois csv não tem chave primária

    # serializar/deserializer define como os dados são armazenados e lidos na tabela do glue
    ser_de_info {
      name                  = "OpenCSVSerDe"
      serialization_library = "org.apache.hadoop.hive.serde2.OpenCSVSerde"
      parameters = {
        "separatorChar" = ","
      }
    }

  }
}

# glue catalog table para metadados de artists.csv
resource "aws_glue_catalog_table" "glue_artists_table" {
  name          = "tabela_spotify_artists"
  database_name = aws_glue_catalog_database.glue_catalog.name
  table_type    = "EXTERNAL_TABLE"

  storage_descriptor {
    location      = "s3://${aws_s3_bucket.bucket_s3.id}/staging/artists/"
    input_format  = "org.apache.hadoop.mapred.TextInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"

    ser_de_info {
      name                  = "OpenCSVSerDe"
      serialization_library = "org.apache.hadoop.hive.serde2.OpenCSVSerde"
      parameters = {
        "separatorChar" = ","
      }
    }

  }
}

# glue catalog table para metadados de track.csv
resource "aws_glue_catalog_table" "glue_track_table" {
  name          = "tabela_spotify_track"
  database_name = aws_glue_catalog_database.glue_catalog.name
  table_type    = "EXTERNAL_TABLE"

  storage_descriptor {
    location      = "s3://${aws_s3_bucket.bucket_s3.id}/staging/track/"
    input_format  = "org.apache.hadoop.mapred.TextInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"

    ser_de_info {
      name                  = "OpenCSVSerDe"
      serialization_library = "org.apache.hadoop.hive.serde2.OpenCSVSerde"
      parameters = {
        "separatorChar" = ","
      }
    }

  }
}