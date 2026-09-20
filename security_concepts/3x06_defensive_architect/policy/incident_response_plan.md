# Incident Response Playbook: Compromised Database

## Purpose

This playbook explains what Sarah and Dave should do if the PostgreSQL
database may have been compromised. The goals are to stop the attack,
protect evidence, and restore the service safely.

Sarah leads the technical investigation and recovery. Dave coordinates
decisions and informs the security lead and management.

## 1. Identification

- Record when and how the problem was discovered.
- Check PostgreSQL, SSH, firewall, and central server logs for unusual
  logins, queries, or large data transfers.
- Identify affected accounts, servers, and data.
- Save copies of relevant logs and record who collected them.
- Do not claim that data was stolen until the evidence supports it.

## 2. Containment

- Restrict database access to approved application servers.
  Remove any rule that exposes port 5432 to the internet.
- Block suspicious connections and disable accounts or keys that
  may have been compromised.
- If the attack continues, isolate the affected server from the
  network while keeping a way for the response team to investigate.
- Record every change and its time. Preserve available evidence
  before making changes when it is safe to do so.

## 3. Eradication

- Determine how the attacker gained access.
- Scan affected hosts and accounts for malware, backdoors, and
  persistence mechanisms, including scheduled tasks and unknown
  services. Remove what the investigation finds.
- Remove unauthorized accounts and SSH keys.
- Patch the vulnerabilities used in the attack and correct unsafe
  settings, such as public database access.
- Reset all credentials associated with the affected systems.
  This includes database users, service accounts, administrator
  accounts, API keys, and SSH keys that may have been exposed.
- Check that a clean backup exists. Verify that it was created before
  the compromise and has not been modified by the attacker.
- Check other systems for the same vulnerabilities and signs of
  compromise.

## 4. Recovery

- Check the integrity of the database. If data was changed or
  destroyed, restore it from the clean, verified backup.
- Test the application and database connection in a controlled way.
- Reconnect the service gradually and monitor logs for new
  suspicious activity.
- Confirm that authorized users can work and that unauthorized
  connections are blocked.

## 5. Lessons Learned

- Write a timeline of what happened and what the team did.
- Identify the cause, the impact, and which controls failed.
- Update firewall rules, access rights, backups, monitoring,
  and this playbook as needed.
- Share the findings with management and assign owners and
  deadlines for the remaining actions.

## Communication

Dave informs the security lead and management as soon as a database
compromise is suspected. The team records confirmed facts separately
from assumptions. Management and the appropriate specialists decide
whether customers, regulators, or other parties must be notified.