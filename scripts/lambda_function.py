import json
import boto3

dynamodb = boto3.client("dynamodb")

def lambda_handler(event, context):
    try:
        body = json.loads(event.get("body", "{}"))
        dynamic_string = body.get("dynamicstring", "dynamic string")
        
        dynamodb.put_item(
            TableName="dynamic-content",
            Item={
                "id": {"S": "root"},
                "content": {"S": f"The saved string is {dynamic_string}"}
            }
        )
        
        return {
            "statusCode": 200,
            "body": json.dumps({"message": f"Updated '{dynamic_string}'"})
        }
    except Exception as e:
        return {
            "statusCode": 500,
            "body": json.dumps({"error": str(e)})
        }
