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


```mermaid
flowchart TD
  A[📦 Order] --> B{⚡ EventBridge}
  B --> C[📊 Inventory]
  B --> D[💳 Payment]
  C & D --> E[🚚 Shipping]