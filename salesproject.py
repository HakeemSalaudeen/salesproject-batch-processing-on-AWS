import sys
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job
import gs_sequence_id
from awsglue import DynamicFrame
import gs_now
import boto3

args = getResolvedOptions(sys.argv, ['JOB_NAME'])
sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args['JOB_NAME'], args)

# Script generated for node Amazon S3
AmazonS3_node1740702612544 = glueContext.create_dynamic_frame.from_catalog(database="salesproject-database", 
                                                                           table_name="salesproject_datalake", 
                                                                           transformation_ctx="AmazonS3_node1740702612544")

# Script generated for node Drop Fields
DropFields_node1740705261938 = DropFields.apply(frame=AmazonS3_node1740702612544, 
                                                paths=["latest_status_entry", "active_opportunity", "closed_opportunity"], 
                                                transformation_ctx="DropFields_node1740705261938")

# Script generated for node transaction_id
transaction_id_node1740703117310 = DropFields_node1740705261938.gs_sequence_id(colName="transaction_id", 
                                                                               unique=True)

# Script generated for node Add Current Timestamp
AddCurrentTimestamp_node1740705371900 = transaction_id_node1740703117310.gs_now(colName="processing_time")

# Script generated for node Amazon Redshift
AmazonRedshift_node1740705630955 = glueContext.write_dynamic_frame.from_options(
    frame=AddCurrentTimestamp_node1740705371900,
    connection_type="jdbc", 
    connection_options={"redshiftTmpDir": "s3://aws-glue-assets-116981770335-eu-central-1/temporary/", 
    "useConnectionProperties": "true", 
    "dbtable": "public.sales_data", 
    "connectionName": "Redshift-salesproject-connection-v4",
    "preactions": "CREATE TABLE IF NOT EXISTS public.sales_data (date VARCHAR, salesperson VARCHAR, lead _name VARCHAR, segment VARCHAR, region VARCHAR, target_close VARCHAR, forecasted_monthly_revenue BIGINT, opportunity_stage VARCHAR, weighted _revenue BIGINT, partition_0 VARCHAR, transaction_id DECIMAL, processing_time TIMESTAMP);"},
    transformation_ctx="AmazonRedshift_node1740705630955")

# Move processed files to backup folder
s3_client = boto3.client('s3')
bucket_name = "salesproject-datalake" 
landingpath_folder = "salesproject-landingpath/"
backup_folder = "salesproject-backup/"

# List objects in the landingpath folder
processedfiles = s3_client.list_objects_v2(Bucket=bucket_name, Prefix=landingpath_folder)

for obj in processedfiles.get('Contents', []):
    source_key = obj['Key']
    file_name = source_key.split('/')[-1]
    destination_key = backup_folder + file_name #source_key.split('/')[-1] 
    
    print(f"Moving {source_key} to {destination_key}")
    
    # Copy object to backup folder
    s3_client.copy_object(
        Bucket=bucket_name,
        CopySource={'Bucket': bucket_name, 'Key': source_key},
        Key=destination_key)
    
    print(f"Copying object in {landingpath_folder} to {backup_folder}")
    
    # Delete object from landing path folder
    s3_client.delete_object(Bucket=bucket_name, Key=source_key)
    
    print(f"Successfully moved {file_name}")


job.commit()