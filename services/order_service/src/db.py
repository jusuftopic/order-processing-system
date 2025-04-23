import datetime

import boto3
import os
from model import ORDER_STATUS_PENDING

TABLE_NAME = os.environ["ORDERS_TABLE"]
dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table(TABLE_NAME)

def is_idempotent_request(idempotency_key):
    response = table.get_item(
        Key={"idempotencyKey": idempotency_key},
        ProjectionExpression="idempotencyKey"
    )
    return "Item" in response

def save_order(order_id, user_id, items, idempotency_key):
    table.put_item(
        Item={
            "idempotencyKey": idempotency_key,
            "orderId": order_id,
            "userId": user_id,
            "items": items,
            "status": ORDER_STATUS_PENDING,
            "createdAt": datetime.datetime.utcnow().isoformat()
        }
    )