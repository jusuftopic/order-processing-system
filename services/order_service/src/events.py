import datetime
import json
import os
import uuid

import boto3

eventbridge = boto3.client("events")

def publish_order_created_event(order_id, user_id, items):
    event_id = str(uuid.uuid4())
    event_detail = {
        "orderId": order_id,
        "userId": user_id,
        "items": items,
        "timestamp": datetime.datetime.utcnow().isoformat()
    }

    response = eventbridge.put_events(
        Entries=[
            {
                "Source": "order.service",
                "DetailType": "OrderCreated",
                "Detail": json.dumps(event_detail),
                "EventBusName": os.environ["EVENT_BUS_NAME"],
                "TraceHeader": event_id
            }
        ]
    )
    return response
