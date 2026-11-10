
# Task 4: Know the Territory
## Vanguard Security — Offensive Security Recruitment Plan

## Role 1: Infrastructure Penetration Tester

### 1. Role Title and Positioning

**Job Title:** Infrastructure Penetration Tester

The Infrastructure Penetration Tester works within Vanguard Security's Offensive Security team.

This specialist assesses the security of corporate networks, servers, and identity infrastructure. They collaborate with network administrators, system engineers, security consultants, and client IT teams.

The role focuses on identifying exploitable weaknesses and providing practical remediation recommendations.

### 2. Scope of Intervention

**Responsibilities:**
- Assess internal and external network infrastructure.
- Test Windows and Linux servers.
- Evaluate Active Directory security and access controls.
- Identify vulnerabilities in VPNs, firewalls, and exposed services.
- Perform authorized privilege escalation and lateral movement testing.
- Document attack paths and recommend remediation measures.

**Outside the role's primary scope:**
- Detailed web application business logic testing.
- Mobile application reverse engineering.
- Physical intrusion and social engineering campaigns.
- Specialized cloud and industrial control system assessments.

All testing must remain within the approved scope and Rules of Engagement.

### 3. Required Technical and Soft Skills

**Technical skills:**
- Strong knowledge of TCP/IP, DNS, SMB, LDAP, and Kerberos.
- Experience with Windows, Linux, and Active Directory.
- Proficiency with Nmap, Nessus, Burp Suite, and Metasploit.
- Understanding of authentication weaknesses, privilege escalation, and network segmentation.
- Ability to automate tasks using Python, Bash, or PowerShell.
- Knowledge of vulnerability validation and secure evidence handling.

**Soft skills:**
- Ability to explain technical vulnerabilities to system administrators.
- Clear technical reporting with reproducible findings.
- Strong time management during limited testing windows.
- Ability to coordinate testing without disrupting business operations.
- Professional judgment when encountering out-of-scope systems.

### 4. Relevant Certifications

**OSCP — Offensive Security Certified Professional**
- Demonstrates practical penetration testing, exploitation, and privilege escalation skills.
- Relevant for assessing real-world network and system vulnerabilities.

**PNPT — Practical Network Penetration Tester**
- Focuses on realistic network penetration testing and Active Directory attack paths.
- Useful for consultants working in corporate environments.

**CompTIA PenTest+**
- Covers penetration testing methodology, planning, vulnerability analysis, and reporting.
- Provides a broad foundation for professional client engagements.

### 5. Distinction from Adjacent Roles

Unlike a Web Application Security Consultant, this role primarily focuses on networks, operating systems, and identity infrastructure rather than application-specific vulnerabilities.

Unlike a Red Team Operator, the main objective is to identify and validate vulnerabilities within a defined scope, not necessarily to simulate a complete adversary campaign.

Cloud infrastructure, mobile applications, and OT environments require additional specialist expertise.

### 6. Typical Engagement Scenario

A financial services company hires Vanguard to assess its internal network before an infrastructure upgrade. The penetration tester first confirms the authorized IP ranges, testing windows, and restrictions with the client. They then identify exposed services, validate vulnerabilities, and test potential privilege escalation paths without disrupting production systems. Finally, they deliver a technical report containing evidence, risk ratings, and prioritized remediation recommendations.

---

## Role 2: Web Application Security Consultant

### 1. Role Title and Positioning

**Job Title:** Web Application Security Consultant

The Web Application Security Consultant works within Vanguard Security's Offensive Security and Application Security practice.

This specialist evaluates the security of web applications and APIs throughout their lifecycle.

They collaborate with software developers, DevSecOps engineers, application owners, and security architects to identify vulnerabilities and recommend effective fixes.

### 2. Scope of Intervention

**Responsibilities:**
- Perform penetration tests on web applications and APIs.
- Identify SQL injection, XSS, IDOR, SSRF, and authentication vulnerabilities.
- Evaluate session management and access control mechanisms.
- Assess REST and GraphQL API security.
- Review application security against OWASP guidance.
- Provide remediation recommendations and perform authorized retesting.

**Outside the role's primary scope:**
- Full internal network penetration testing.
- Physical security assessments.
- Mobile application binary reverse engineering.
- Industrial control system testing.
- Full-scale adversary simulations.

### 3. Required Technical and Soft Skills

**Technical skills:**
- Strong understanding of HTTP/HTTPS, cookies, sessions, and authentication.
- Knowledge of JavaScript, SQL, and common backend technologies.
- Experience with Burp Suite, OWASP ZAP, and browser developer tools.
- Understanding of OWASP Top 10 and OWASP API Security Top 10.
- Ability to test REST and GraphQL APIs.
- Knowledge of OAuth 2.0, OpenID Connect, and JWT security.
- Familiarity with secure coding principles and CI/CD pipelines.

**Soft skills:**
- Ability to explain vulnerabilities clearly to developers.
- Skill in producing reproducible proof-of-concept findings.
- Ability to recommend realistic fixes without disrupting application functionality.
- Strong collaboration with development and DevSecOps teams.
- Ability to prioritize findings according to business impact.

### 4. Relevant Certifications

**OSWE — Offensive Security Web Expert**
- Focuses on advanced web application security and source code analysis.
- Relevant for identifying complex application vulnerabilities.

**BSCP — Burp Suite Certified Practitioner**
- Demonstrates practical web security testing using Burp Suite.
- Particularly useful for identifying and exploiting common web vulnerabilities.

**eWPT — eLearnSecurity Web Application Penetration Tester**
- Focuses on practical web application penetration testing techniques.
- Relevant for assessing authentication, input validation, and application security weaknesses.

### 5. Distinction from Adjacent Roles

Unlike an Infrastructure Penetration Tester, this consultant focuses on application logic, APIs, authentication flows, and vulnerabilities in web functionality.

Unlike a Mobile Application Penetration Tester, the role does not primarily involve Android or iOS binary analysis.

Unlike a Red Team Operator, the objective is to identify and remediate application vulnerabilities rather than evaluate an organization's overall detection and response capabilities.

### 6. Typical Engagement Scenario

An e-commerce company asks Vanguard to assess its customer website and payment-related APIs before a major release. The consultant first confirms the authorized domains, test accounts, data handling restrictions, and testing schedule. They then evaluate authentication, authorization, input validation, and business logic vulnerabilities using controlled testing techniques. The engagement concludes with a report containing reproducible findings, risk assessments, remediation guidance, and recommendations for retesting.

---

## Role 3: Red Team Operator

### 1. Role Title and Positioning

**Job Title:** Red Team Operator

The Red Team Operator works within Vanguard Security's Adversary Simulation and Offensive Security practice.

This specialist simulates realistic attacker behavior to evaluate an organization's prevention, detection, and response capabilities.

They collaborate with red team leads, threat intelligence analysts, client security leadership, and, when appropriate, SOC and incident response teams.

### 2. Scope of Intervention

**Responsibilities:**
- Design and execute authorized adversary simulation scenarios.
- Emulate realistic attacker techniques using the MITRE ATT&CK framework.
- Test initial access, privilege escalation, and lateral movement paths.
- Evaluate security monitoring and detection capabilities.
- Conduct controlled command-and-control simulations where authorized.
- Participate in purple team exercises and post-engagement reviews.
- Document attack timelines, detection gaps, and defensive improvements.

**Outside the role's primary scope:**
- Routine vulnerability scanning as a standalone service.
- Comprehensive web application code reviews.
- Specialized mobile application security testing.
- Industrial control system testing without additional authorization and expertise.
- Physical intrusion or social engineering activities unless explicitly approved.

### 3. Required Technical and Soft Skills

**Technical skills:**
- Strong knowledge of Windows, Linux, and Active Directory.
- Understanding of adversary tactics and the MITRE ATT&CK framework.
- Experience with authorized command-and-control frameworks.
- Knowledge of privilege escalation, lateral movement, and persistence techniques.
- Proficiency in Python, PowerShell, or C#.
- Familiarity with SIEM, EDR, and security monitoring technologies.
- Understanding of operational security, evidence handling, and safe testing procedures.

**Soft skills:**
- Ability to plan complex operations while respecting strict Rules of Engagement.
- Strong risk assessment and decision-making under pressure.
- Ability to coordinate with engagement leads and emergency contacts.
- Clear communication of attack timelines and detection failures.
- Ability to work constructively with Blue Teams during debriefings.
- Strong ethical judgment and respect for operational boundaries.

### 4. Relevant Certifications

**CRTO — Certified Red Team Operator**
- Focuses on realistic red team operations in Windows and Active Directory environments.
- Relevant for adversary simulation and operational techniques.

**OSEP — Offensive Security Experienced Penetration Tester**
- Develops advanced exploitation and attack-chain skills.
- Useful for complex adversary simulations involving defensive security controls.

**CRTP — Certified Red Team Professional**
- Focuses on Active Directory security and attack techniques.
- Relevant for simulating attacks against enterprise identity infrastructure.

### 5. Distinction from Adjacent Roles

Unlike an Infrastructure Penetration Tester, the Red Team Operator focuses on achieving defined adversary objectives and evaluating how defenders detect and respond to the activity.

Unlike a Web Application Security Consultant, the role does not primarily aim to produce an exhaustive list of application vulnerabilities.

Social engineering and physical intrusion may be included in a red team exercise, but these activities require explicit authorization and may involve dedicated specialists.

### 6. Typical Engagement Scenario

A large enterprise hires Vanguard to evaluate the effectiveness of its SOC against a realistic attacker. The red team first agrees on objectives, authorized techniques, testing boundaries, emergency contacts, and stopping conditions. The operators then execute a controlled adversary simulation while documenting their actions and observing the organization's detection and response capabilities. After the exercise, Vanguard delivers an attack timeline, identified detection gaps, and prioritized recommendations during a joint debriefing.

---

## Why We Chose These Three Roles

We selected the Infrastructure Penetration Tester, Web Application Security Consultant, and Red Team Operator because they provide complementary offensive security capabilities. The Infrastructure Penetration Tester identifies weaknesses in networks, servers, and identity systems. The Web Application Security Consultant focuses on protecting customer-facing applications and APIs. The Red Team Operator evaluates how effectively an organization can detect and respond to realistic attacks. Together, these specialists allow Vanguard to offer both targeted technical assessments and broader adversary simulations. This combination supports clients at different levels of security maturity, from identifying basic vulnerabilities to testing advanced defensive capabilities. Our hiring strategy demonstrates Vanguard's ambition to become a comprehensive offensive security partner focused on practical risk reduction and continuous security improvement.
