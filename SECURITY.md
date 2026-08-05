# Security Policy

## Reporting a vulnerability

Do **not** open a public issue for a security vulnerability. Report it privately:

- Use GitHub's **private vulnerability reporting** on this repository
  (Security tab → Report a vulnerability), or
- Email the maintainer directly (address listed on the repository profile).

Provide as much as possible:

- Package/file and version affected
- Description of the vulnerability and impact
- Steps to reproduce
- Proof of concept (if any)

You will receive a response within 7 days. Do not disclose the issue publicly
until it has been addressed.

## Data handling

This application processes **location data** (GPS tracking for driver trips).
Location data is treated as sensitive:

- Location permission is requested only for the features that require it.
- Raw location samples are recorded only during an active, user-initiated trip.
- No analytics payloads include raw coordinates unless explicitly approved.
- Any server-side storage of location data is documented in the privacy policy.

Security issues involving location data are treated as high severity.

## Supported versions

| Version | Supported |
|---|---|
| main | Security fixes land on main first; patch releases are tagged per release |
| Older tags | Best effort — no SLA |

## Responsible disclosure

We ask for responsible disclosure: report first, allow a reasonable window to
fix, then publish. We commit to acknowledging reports and shipping fixes
without retaliation.
