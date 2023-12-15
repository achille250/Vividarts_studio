# image_processing_lambda.py

import os
import json
import boto3
from PIL import Image

s3 = boto3.client('s3')

def lambda_handler(event, context):
    for record in event['Records']:
        bucket = record['s3']['bucket']['name']
        key = record['s3']['object']['key']

        # Download the image
        download_path = '/tmp/{}{}'.format(os.path.basename(key), 'downloaded')
        s3.download_file(bucket, key, download_path)

        # Process the image (convert to black and white)
        processed_path = '/tmp/{}{}'.format(os.path.basename(key), 'processed')
        with Image.open(download_path) as image:
            # Convert the image to black and white
            bw_image = image.convert('L')
            bw_image.save(processed_path)

        # Upload the processed image back to S3
        processed_key = 'processed_bw/{}'.format(os.path.basename(key))
        s3.upload_file(processed_path, bucket, processed_key)

    return {
        'statusCode': 200,
        'body': json.dumps('Photo processing completed successfully!')
    }
