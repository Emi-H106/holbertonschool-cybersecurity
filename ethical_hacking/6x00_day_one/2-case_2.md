
# Case 2: The Scope Creep
## Post-Incident Analysis

### 1. What Happened

RedLine Security was authorized to test only the client's e-commerce website and its API. During testing, a consultant discovered an internal billing service that was not included in the approved scope. The consultant accessed the service using default administrator credentials and viewed sensitive billing records belonging to more than 10,000 customers. The system was managed by FinServe, a third-party payment processor that had not authorized the test. As a result, RedLine faced legal complaints, and its professional liability insurance was invoked.

### 2. Rules, Laws, or Professional Standards Violated

- **Scope Violation:** The consultant deliberately accessed a system that was explicitly outside the authorized testing scope.
- **Unauthorized Access:** Accessing FinServe's infrastructure without permission potentially violated applicable computer misuse laws.
- **Third-Party Authorization:** The consultant failed to obtain authorization from the organization responsible for the billing system.
- **PCI DSS:** Accessing payment-related information without authorization raised potential PCI DSS compliance concerns.
- **PTES and Professional Ethics:** The consultant ignored the agreed boundaries and failed to follow responsible testing practices.

### 3. Correct Professional Behavior

The consultant should have stopped before attempting to access the internal billing service.

The discovery should have been documented and immediately reported to the client's designated contact.

Before performing additional testing, RedLine should have confirmed the system's ownership and obtained explicit written authorization from FinServe and any other relevant parties.

The consultant should not have attempted to log in or view customer billing records without authorization.

### 4. Preventive Pre-Engagement Clauses

**Scope Limitation Clause:**
"Testing is strictly limited to the systems, domains, and IP addresses explicitly listed in the approved scope document."

**Out-of-Scope Discovery Clause:**
"If a potentially vulnerable system outside the approved scope is discovered, testing of that system must stop, and the client must be notified immediately."

**Third-Party Authorization Clause:**
"Systems owned or managed by third parties shall not be tested without explicit written authorization from the appropriate rights holders."

**Scope Change Clause:**
"Any expansion of the testing scope requires a documented amendment and written approval before additional testing begins."

**Sensitive Data Protection Clause:**
"Access to customer, financial, or payment information must be avoided unless explicitly authorized and necessary for the agreed testing objectives."

**Conclusion:** Discovering a vulnerability does not grant permission to exploit it. The approved scope must always be respected.
