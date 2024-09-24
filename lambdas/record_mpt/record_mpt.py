import json
import boto3
import time
from datetime import datetime
import os


dynamodb = boto3.resource('dynamodb')
table_name = os.environ.get("TABLE_NAME")
table = dynamodb.Table(table_name)


def lambda_handler(event, context):
    device_id = event.get('device_id')
    measurement = event.get('measurement')

    timestamp = int(time.time() * 1000)
    readable_timestamp = datetime.utcfromtimestamp(
        int(time.time())).isoformat() + 'Z'

    item = {
        'device_id': device_id,
        'timestamp': str(timestamp),
        'measurement': measurement,
        'readable_timestamp': readable_timestamp
    }

    try:

        table.put_item(Item=item)

        return ({
            'statusCode': 200,
            'body': json.dumps('Measurement successfully added')
        })

    except Exception as e:
        return ({
            'statusCode': 500,
            'body': json.dumps(f'Error adding measurement: {str(e)}')
        })
