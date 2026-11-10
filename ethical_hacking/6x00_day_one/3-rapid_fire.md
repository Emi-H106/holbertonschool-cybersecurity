# Task 3: The Rapid Fire
## Professional Judgment Drill

### Cluster A: Scope Boundaries

## Vignette 1: Internal API Server

### CAN you?
**Conditional.**

The scope includes the web application and its direct dependencies, so the internal API might be covered. However, the wording is ambiguous, and the API is not explicitly listed.

Before testing, I should confirm its ownership and obtain written clarification from the client. Until then, I should not actively test the API.

### SHOULD you?
**Yes, but only after clarification and authorization.**

An authentication bypass could represent a critical security risk. Investigating it would provide value to the client, but testing an internal API could also affect production services.

I should document the discovery, notify the client, and agree on safe testing conditions before proceeding.

---

## Vignette 2: Out-of-Scope Development Server

### CAN you?
**No.**

The authorized network is 10.0.1.0/24, while the development server at 10.0.2.15 is outside that range.

Mentioning the development environment during a kickoff call does not constitute formal authorization. Accessing it would violate the signed scope document and could constitute unauthorized access.

### SHOULD you?
**No.**

Even if the server uses default credentials, accessing it without permission would be unprofessional.

I should document the observation and notify the client without attempting to log in.

If the client wants the server tested, the scope must be formally updated and approved in writing.

---

## Vignette 3: IDOR Exposing Customer PII

### CAN you?
**Not without additional authorization.**

Authorization to test the application does not automatically permit unrestricted access to real customer information.

Accessing names, addresses, and payment data may create privacy and regulatory risks, including obligations under applicable data protection laws.

I should review the Rules of Engagement and obtain explicit approval before accessing sensitive customer records.

### SHOULD you?
**Generally, no.**

I should avoid accessing real customer records when the vulnerability can be demonstrated using test accounts or synthetic data.

If real data access is strictly necessary and explicitly authorized, I should limit it to the minimum required evidence, protect the information, and follow the agreed data handling procedures.

The goal is to demonstrate the vulnerability without unnecessarily exposing customer information.

---

### Cluster B: Incidental Discoveries

## Vignette 4: Evidence of Financial Fraud

### CAN you?
**Conditional yes.**

Reporting suspected financial fraud to an appropriately authorized client representative may be permitted, but the engagement's confidentiality obligations, reporting procedures, and applicable privacy laws must be respected.

Authorization to access the workstation does not authorize me to conduct an independent fraud investigation.

I should consult my engagement lead and legal team before disclosing the information.

### SHOULD you?
**Yes, through an appropriate confidential channel.**

Potential financial fraud is serious and should not simply be ignored.

However, I should not accuse the employee, investigate further, or distribute the evidence unnecessarily.

I should preserve only the information lawfully obtained, report the concern internally, and arrange a confidential disclosure to the client's authorized legal or compliance representative.

The findings should be presented as suspected misconduct, not proven criminal activity.

---

## Vignette 5: Suspicious Prescriptions in an EHR

### CAN you?
**Conditional.**

Although the EHR system is in scope, this does not automatically authorize disclosure of sensitive patient or physician information in a penetration testing report.

Medical records are subject to strict confidentiality and data protection requirements.

Any disclosure must comply with applicable law, contractual obligations, and approved reporting procedures.

### SHOULD you?
**Not in the standard technical report.**

The suspected misuse of controlled substances may create patient safety and compliance concerns, so it should not be ignored.

However, including identifiable medical information in a general penetration testing report would create unnecessary privacy risks.

I should stop investigating the individual, consult the engagement lead and legal team, and report the concern through a secure, restricted channel to the hospital's authorized compliance or medical safety personnel.

I should avoid making accusations without a proper investigation.

---

### Cluster C: Client Communication

## Vignette 6: Actively Exploited RCE

### CAN you?
**Conditional, depending on emergency provisions and legal obligations.**

The Rules of Engagement specify that findings are reported at the end of the engagement.

However, evidence of an active compromise may trigger emergency notification procedures or applicable legal and contractual duties.

I should immediately escalate the situation to my engagement lead and use the authorized emergency communication process. If the RoE lacks an emergency exception, urgent clarification or authorization should be obtained.

### SHOULD you?
**Yes.**

Waiting until the final report could allow the attacker to continue compromising systems, stealing data, or disrupting operations.

Protecting the client takes priority over routine reporting schedules.

I should immediately escalate the discovery, communicate verified indicators of compromise through a secure channel, and recommend activating the client's incident response process.

I should also avoid interfering with evidence or attempting unauthorized incident response activities.

---

## Vignette 7: CISO Requests Preliminary Findings

### CAN you?
**No, not under the current communication rules.**

The Rules of Engagement explicitly require communications to go through the designated project manager.

The CISO's senior position does not automatically override this contractual requirement.

I should obtain approval through an authorized alternate contact or a formal change to the communication procedure before sharing preliminary findings.

### SHOULD you?
**Yes, but only through an approved process.**

The CISO has a legitimate business reason for requesting information before the board meeting.

However, bypassing the agreed communication protocol could create confidentiality, accountability, and reporting issues.

I should contact my engagement lead, identify an authorized replacement for the unavailable project manager, and arrange an approved briefing.

Any preliminary findings should be clearly identified as unverified or subject to change.

---

### Cluster D: Engagement Qualification

## Vignette 8: Startup Requests a Full Red Team

### CAN you?
**Yes, a proposal is permitted.**

There is generally no legal or contractual restriction preventing the firm from proposing a red team engagement.

However, the CEO's vague request does not constitute sufficient authorization to begin testing.

Before execution, the firm would need clearly defined objectives, scope, permitted techniques, testing windows, and written authorization.

### SHOULD you?
**No, not as the first recommendation.**

The company has no dedicated security team, no previous security assessment, and limited IT resources.

A full red team exercise primarily evaluates an organization's ability to detect and respond to realistic attacks. Without established security controls and monitoring capabilities, it may provide limited value compared with a foundational assessment.

I would first recommend a security posture assessment, vulnerability assessment, and a focused penetration test.

After addressing critical weaknesses and improving detection and incident response capabilities, the company could consider a red team engagement.

The consultant's responsibility is to recommend the service that best meets the client's actual needs, rather than simply selling the most advanced assessment.

---

## Conclusion

Professional judgment in penetration testing requires distinguishing between legal or contractual permission and ethical or professional responsibility.

An action may be technically possible but still unauthorized, unsafe, or inappropriate.

A responsible consultant must respect the agreed scope, protect sensitive information, follow communication procedures, and escalate serious risks appropriately.

When authorization or boundaries are unclear, the safest professional approach is to stop, document the concern, seek clarification, and obtain approval before proceeding.
