# PRIMEIRO job a ser executado

import sys
from awsglue.transforms import * # Join veio daqui
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from pyspark.sql.functions import *
from awsglue.context import GlueContext
from awsglue.job import Job

args = getResolvedOptions(sys.argv, ["output_path"])
sc = SparkContext.getOrCreate()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args["output_path"], args)

# lê a catalog table referente ao albums.csv como dynamic frame
albums = glueContext.create_dynamic_frame.from_catalog(
    database="base_glue_s3", table_name="tabela_spotify_albums"
)

# catalog table referente ao artists.csv
artists = glueContext.create_dynamic_frame.from_catalog(
    database="base_glue_s3", table_name="tabela_spotify_artists"
)

# catalog table referente ao track.csv
track = glueContext.create_dynamic_frame.from_catalog(
    database="base_glue_s3", table_name="tabela_spotify_track"
)

join_album_artist = albums.join(
    paths1=["artist_id"], paths2=["id"], frame2=artists
)

join_with_track = track.join(
    paths1=["track_id"], paths2=["track_id"], frame2=join_album_artist
)

# DROP
dropped_fields = join_with_track.drop_fields(paths=["track_id", "id"])

# Salvando no datawarehouse do S3
glueContext.write_dynamic_frame.from_options(
    frame=dropped_fields,
    connection_type="s3",
    format="csv",
    connection_options = {
        "path": args["output_path"],
        "partitionKeys": []
    },

    format_options = {
        "separator": ","
    },

    transformation_ctx="FinalOutput"
)

job.commit()