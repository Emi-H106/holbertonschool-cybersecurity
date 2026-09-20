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
- Remove unauthorized accounts, keys, software, or scheduled tasks.
- Rotate exposed database passwords and SSH keys.
- Fix the weakness used in the attack, such as an exposed port,
  weak credentials, or missing updates.
- Check other systems for the same weakness.

## 4. Recovery

- Check the integrity of the database. Restore from a verified
  backup if the data was changed or destroyed.
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