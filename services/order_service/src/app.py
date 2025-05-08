import json
import uuid
from events import publish_order_created_event
from db import is_idempotent_request, save_order

def lambda_handler(event, context):
    body = json.loads(event['body'])
    idempotency_key = body.get("idempotencyKey")

    if is_idempotent_request(idempotency_key):
        return {"statusCode": 409, "body": "Duplicate order"}

    order_id = str(uuid.uuid4())
    user_id = body["userId"]
    items = body["items"]

    # Save order with PENDING state
    save_order(order_id, user_id, items, idempotency_key)

    # Publish OrderCreated
    publish_order_created_event(order_id)

    return {
        "statusCode": 201,
        "body": json.dumps({"orderId": order_id, "status": "PENDING"})
    }