# 🚀 Order Processing System (Event-Driven Microservices)

A production-grade reference architecture for mission-critical order processing, demonstrates how to achieve **scalability**, **resilience**, and **agility** using serverless patterns.

## 🌟 Why This Matters

### **💼 Business Value**
- **🛡️ Fault Isolation**: Single service failures (e.g., payment) don't cascade to entire system
- **📈 Elastic Scaling**: Handles unpredictable retail workloads (e.g., flash sales)
- **🔍 Auditability**: Event sourcing provides full transaction history 
### **⚡ Technical Concepts**
1. **🔗 Event-First Design**
    - Services communicate via events (`OrderCreated`, `PaymentFailed`)
    - Enables zero-downtime deployments (services upgrade independently)

2. **🔄 Serverless SAGA Pattern**
    - Automated rollbacks via compensating events (e.g., `RestockInventory` on payment failures)
    - No centralized orchestrator (anti-pattern avoidance)

3. **🛠️ Infrastructure as Code**
    - Terraform modules enforce consistent security/networking policies
    - Environment parity (dev/prod) via immutable deployments 


## 🏗 Key Architecture Highlights

| Principle              | Implementation Example                  | Benefit                          |
|------------------------|----------------------------------------|----------------------------------|
| **🔌 Loose Coupling**  | EventBridge pub/sub                    | Change payment provider without touching inventory |
| **✅ Exactly-Once Processing** | SQS FIFO + Lambda idempotency   | No double-charging customers     |
| **📊 Operational Excellence** | CloudWatch embedded metrics    | Detect shipping delays in real-time |


# ✅ Why I Use Sequential Event Processing (SAGA Choreography)

In my event-driven order processing system, I have chosen **sequential event processing** over parallel processing. Below are the key reasons supporting this architectural decision.

## 🎯 Business Logic Clarity

- Sequential flow mirrors real-world order processing: first reserve stock, then charge payment, then ship.
- Keeps each step dependent on the success of the previous step, making business rules easy to follow and audit.
---
## 🔄 Easier Compensation (Rollback)

- Failures are caught early: if inventory reservation fails, there's no need to initiate payment or shipping.
- Compensating actions like `RestockInventory` or `RefundPayment` are minimized or avoided altogether.

## 🧠 Simpler State Management

- Each service only needs to track its immediate state and respond to the previous service’s event.
- Avoids complex race conditions or the need to reconcile partial failures from parallel tasks.

## 🔒 Data Integrity

- Ensures strict ordering of operations to avoid invalid states (e.g., charging a customer when stock is unavailable).
- Inventory and payment updates can use DynamoDB conditional updates to protect against double processing.

## 🛠️ Debugging and Observability

- Easier to trace failures and reason about flow in CloudWatch Logs or X-Ray.
- Events form a clear, linear timeline of what happened in which order.

## 📉 Lower Risk for Mission-Critical Workloads

- Especially important in financial or regulated domains where accuracy and control trump speed.
- Predictable behavior under retries, timeouts, or partial outages.

