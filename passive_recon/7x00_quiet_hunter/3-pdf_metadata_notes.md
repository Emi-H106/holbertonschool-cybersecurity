
# Task 3 — PDF Metadata Extraction

> Download the documents and read their metadata (exiftool / pdfinfo).

## Suggested sources

- /documents (download each PDF)

## Findings to record

### 1. Internal creator email

- **Value:** `document.services@helix-maritime.example`
- **Exact source (URL / file / metadata field):** URL: `http://10.42.126.67/documents/helix-annual-report-2024.pdf`; local file: `pdf_documents/helix-annual-report-2024.pdf`; tool: `exiftool -a -u -G1`; field: `[XMP-dc] Creator`; exact value: `document.services@helix-maritime.example`; retrieved: `2026-11-23`.
- **Justification (1 line):** The PDF's embedded XMP Creator metadata exposes an internal document-production email address.
- **Cross-reference / alternative ruled out:** The same PDF contains `[PDF] Contact: document.services@helix-maritime.example`, confirming the address. This address also appears in the public website's HTML comment, so the claim that it is not disclosed elsewhere remains unverified.

### 2. Full internal employee name (Author)

- **Value:** `Li Wei Chen`
- **Exact source (URL / file / metadata field):** URL: `http://10.42.126.67/documents/asia-pacific-expansion.pdf`; local file: `pdf_documents/asia-pacific-expansion.pdf`; tool: `exiftool -a -u -G1`; field: `[PDF] Author`; exact value: `Li Wei Chen`; retrieved: `2026-11-23`.
- **Justification (1 line):** The embedded PDF Author metadata identifies an individual associated with Helix's Asia-Pacific expansion document.
- **Cross-reference / alternative ruled out:** The document's `[PDF] Company` field identifies `Helix Maritime Insurance N.V.`. `Westport Analytics Ltd`, found in `decoy-market-analysis.pdf`, is a third-party organization rather than a Helix employee.

### 3. Internal document-generation tool / template (Creator/Producer)

- **Value:** `Helix DocForge 3.2`
- **Exact source (URL / file / metadata field):** URL: `http://10.42.126.67/documents/asia-pacific-expansion.pdf`; local file: `pdf_documents/asia-pacific-expansion.pdf`; tool: `exiftool -a -u -G1`; field: `[PDF] Creator`; exact value: `Helix DocForge 3.2`; retrieved: `2026-11-23`.
- **Justification (1 line):** The PDF Creator metadata explicitly identifies the internal document-generation tool and its version.
- **Cross-reference / alternative ruled out:** The same file's `[PDF] Producer` field also reports `Helix DocForge 3.2`, and several other Helix PDFs contain the same tool name. `LibreOffice 7.4` in `decoy-market-analysis.pdf` belongs to a third-party document.

### 4. Original internal file path

- **Value:** `D:\Helix\Marketing\Reports\apac-expansion-final.indd`
- **Exact source (URL / file / metadata field):** URL: `http://10.42.126.67/documents/asia-pacific-expansion.pdf`; local file: `pdf_documents/asia-pacific-expansion.pdf`; tool: `exiftool -a -u -G1`; field: `[PDF] Original Path`; exact value: `D:\Helix\Marketing\Reports\apac-expansion-final.indd`; retrieved: `2026-11-23`.
- **Justification (1 line):** The embedded Original Path metadata reveals an internal Windows drive and Helix's marketing report directory structure.
- **Cross-reference / alternative ruled out:** The same PDF's `[PDF] Company` field identifies Helix Maritime Insurance N.V., and its `[PDF] Title` matches the Asia-Pacific expansion report; the path is embedded metadata rather than visible document text.

## Open questions / things to verify

- Verify acceptance of all four values through the intranet flag-submission interface.
- The creator email is confirmed in PDF metadata but is also present in the corporate website's HTML source; its exclusivity as a metadata-only disclosure is not established.
- All findings were obtained through passive inspection of publicly available PDF metadata. No internal systems were accessed.
