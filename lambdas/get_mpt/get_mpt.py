import json
import os
import time
from aws_lambda_powertools.event_handler import APIGatewayRestResolver
from aws_lambda_powertools.utilities.typing import LambdaContext
import boto3
from botocore.config import Config


table_name = os.environ.get("TABLE_NAME")
dynamodb_client = boto3.client('dynamodb')
app = APIGatewayRestResolver()


@app.get("/mpt/<device_id>")
def get_mpt(device_id: str):

    try:
        response = dynamodb_client.query(

            TableName=table_name,
            KeyConditionExpression=f'device_id = :device_id',
            ExpressionAttributeValues={
                ':device_id': {'S': device_id}
            })

        if response['Items']:
            return {

                "statusCode": 200,
                "body": json.dumps({"measurements": response['Items']})

            }
        else:
            return {
                "statusCode": 404,
                "body": json.dumps({"message": "Error: Device Id Not Found"})
            }

    except Exception as e:
        return {
            "statusCode": 500,
            "body": json.dumps({"message": f"Error:{e}"})
        }


def lambda_handler(event: dict, context: LambdaContext):
    return app.resolve(event, context)
