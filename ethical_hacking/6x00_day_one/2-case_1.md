
# Case 1: The Handshake Deal
## Post-Incident Analysis

### 1. What Happened

NorthBay Consulting started a penetration test based only on verbal authorization from the client's CTO, Mark Reeves. During testing, the consultants exploited a SQL injection vulnerability and extracted 500 customer shipping records. The company's legal and security teams were unaware of the engagement and treated the activity as a data breach. It was later discovered that the CTO did not have the legal authority to approve the test. The engagement was terminated, and NorthBay faced eight months of legal proceedings.

### 2. Rules, Laws, or Professional Standards Violated

- **Authorization:** The engagement began without written approval from a legally authorized representative.
- **Unauthorized Access:** The testing potentially violated applicable computer misuse laws because valid authorization had not been obtained.
- **Data Protection:** Extracting 500 customer records created unnecessary privacy risks and potential data protection violations.
- **PTES Pre-Engagement Standard:** NorthBay failed to establish proper authorization, scope, and communication procedures before testing.
- **Professional Ethics:** The consultants failed to verify authorization and minimize the collection of sensitive information.

### 3. Correct Professional Behavior

NorthBay should have obtained a signed authorization document from someone with legal authority before starting the engagement.

The consulting team should also have confirmed the scope, testing methods, and data handling procedures.

The client's legal, security, and incident response teams should have been informed through an agreed communication protocol.

When demonstrating the SQL injection vulnerability, the consultants should have collected only the minimum evidence necessary to prove its impact.

### 4. Preventive Pre-Engagement Clauses

**Written Authorization Clause:**
"Testing shall not begin until written authorization has been signed by a legally authorized representative of the client."

**Scope and Testing Methods Clause:**
"All authorized systems and permitted testing techniques must be explicitly defined and approved before testing begins."

**Communication Clause:**
"The client must designate authorized contacts and establish notification procedures with relevant security, legal, and incident response teams."

**Data Minimization Clause:**
"Consultants shall collect only the minimum data required to demonstrate a vulnerability and must protect all collected information."

**Conclusion:** Verbal permission is not a substitute for verified legal authorization and a documented engagement agreement.
