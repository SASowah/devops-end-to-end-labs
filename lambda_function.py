import json
import logging

def lambda_handler(event, context):
    logging.basicConfig(level=logging.INFO)
    logger = logging.getLogger()

    logger.info("Lambda triggered successfully.")
    logger.info("Event received: %s", json.dumps(event))

    # Check if triggered by S3
    if 'Records' in event and 's3' in event['Records'][0]:
        record = event['Records'][0]
        bucket = record['s3']['bucket']['name']
        file_key = record['s3']['object']['key']
        file_size = record['s3']['object'].get('size', 'Unknown')

        logger.info(f"File uploaded: {file_key} to bucket: {bucket}, size: {file_size}")

        return {
            "statusCode": 200,
            "body": json.dumps({
                "message": "File upload event detected.",
                "bucket": bucket,
                "file": file_key
            })
        }

    # If called from API Gateway manually
    return {
        "statusCode": 200,
        "body": json.dumps({
            "message": "Lambda is active. Upload a file to S3 to trigger processing."
        })
    }
