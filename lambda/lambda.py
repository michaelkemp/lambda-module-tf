
import json
import logging
LOGGER = logging.getLogger()
LOGGER.setLevel(logging.INFO)

SUCCESS = {
    "isBase64Encoded": False,
    "statusCode": 200,
    "headers": {'content-type': 'application/json'},
    "body": json.dumps({'response': "Success"})
}

FAILURE = {
    "isBase64Encoded": False,
    "statusCode": 500,
    "headers": {'content-type': 'application/json'},
    "body": json.dumps({'response': "Failure"})
}


def lambda_handler(event, context):
    
    LOGGER.info(event)
    
    return SUCCESS
