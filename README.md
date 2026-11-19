# Enterprise Windows Helpdesk Diagnostic Toolkit

A PowerShell-based Windows IT support toolkit for automating system diagnostics, basic network troubleshooting, Windows service inspection, and diagnostic report generation.

## Project Overview

The **Enterprise Windows Helpdesk Diagnostic Toolkit** is a practical IT support automation project developed using Windows PowerShell.

The toolkit consists of seven independent scripts that collect system information, assess disk capacity, monitor CPU and memory usage, test network connectivity, diagnose DNS resolution, inspect selected Windows services, and consolidate diagnostic results into structured reports.

The project demonstrates foundational technical skills relevant to entry-level IT Support, Desktop Support, and Helpdesk roles, with an emphasis on troubleshooting, automation, testing, and technical documentation.

## Project Objectives

- Automate common Windows diagnostic tasks using PowerShell.
- Collect operating system and hardware information.
- Assess disk capacity and available storage.
- Identify elevated CPU and memory usage.
- Perform basic network connectivity and DNS checks.
- Inspect selected Windows service states.
- Generate structured diagnostic reports in TXT and CSV formats.
- Develop practical skills in scripting, troubleshooting, testing, and documentation.

## Key Features

| Script | Description |
|---|---|
| `system-information.ps1` | Collects operating system, processor, memory, and system information. |
| `disk-health-check.ps1` | Evaluates disk capacity and available storage space. |
| `cpu-memory-check.ps1` | Collects CPU and memory utilization measurements. |
| `internet-connectivity.ps1` | Checks network adapter status, external IP connectivity, DNS resolution, and TCP connectivity on port 443. |
| `dns-diagnostic.ps1` | Examines DNS configuration and tests domain name resolution. |
| `windows-services-check.ps1` | Inspects the operational states of selected Windows services. |
| `generate-report.ps1` | Consolidates available diagnostic results into TXT and CSV reports. |

## Technology Stack

| Category | Technology |
|---|---|
| Operating System | Windows 11 |
| Scripting Language | Windows PowerShell |
| Data Formats | TXT, CSV |
| Version Control | Git |
| Repository Hosting | GitHub |
| Development Environment | Windows workstation |

## Repository Structure

```text
enterprise-windows-helpdesk-project/
|
|-- scripts/
|   |-- system-information.ps1
|   |-- disk-health-check.ps1
|   |-- cpu-memory-check.ps1
|   |-- internet-connectivity.ps1
|   |-- dns-diagnostic.ps1
|   |-- windows-services-check.ps1
|   |-- generate-report.ps1
|
|-- documentation/
|   |-- system-assessment.md
|   |-- functional-testing.md
|
|-- README.md
|-- .gitignore
```

**Note:** Diagnostic reports are generated locally and are excluded from the public repository to avoid exposing machine-specific information.

## Installation and Execution

### Prerequisites

- Windows 10 or Windows 11.
- Windows PowerShell 5.1 or a compatible PowerShell environment.
- Permission to execute PowerShell scripts.
- An active internet connection for network and DNS diagnostics.

### 1. Clone the Repository

```powershell
git clone https://github.com/sharmiladeviramanujam/enterprise-windows-helpdesk-project.git
```

### 2. Navigate to the Project Directory

```powershell
cd enterprise-windows-helpdesk-project
```

### 3. Execute the Diagnostic Scripts

Run each script individually from the project root directory:

```powershell
.\scripts\system-information.ps1

.\scripts\disk-health-check.ps1

.\scripts\cpu-memory-check.ps1

.\scripts\internet-connectivity.ps1

.\scripts\dns-diagnostic.ps1

.\scripts\windows-services-check.ps1
```

Each script performs its respective diagnostic checks and saves its output locally.

### 4. Generate the Consolidated Diagnostic Report

After executing the individual diagnostic scripts, run:

```powershell
.\scripts\generate-report.ps1
```

The report generator locates the latest available source reports and combines their results into consolidated TXT and CSV files.

Generated reports are stored in the local `reports/` directory.

## Functional Testing and Validation

All seven scripts were executed successfully during the initial functional testing phase.

| Test Category | Result |
|---|---|
| System Information Collection | PASS |
| Disk Capacity Assessment | PASS |
| CPU and Memory Assessment | PASS |
| Internet Connectivity Testing | PASS |
| DNS Diagnostics | PASS |
| Windows Services Inspection | PASS |
| Consolidated Report Generation | PASS |

### Consolidated Report Results

The report generator successfully processed six diagnostic categories.

| Metric | Result |
|---|---:|
| Total Diagnostic Categories | 6 |
| Successful Categories | 6 |
| Warnings | 0 |
| Empty Reports | 0 |
| Missing Reports | 0 |
| Failed Imports | 0 |
| Combined Records | 17 |

**Testing scope:** These results represent successful initial functional execution. They do not establish exhaustive testing across all Windows configurations, network environments, or failure conditions.

Refer to [`documentation/functional-testing.md`](documentation/functional-testing.md) for additional testing details.

## Technical Scope and Limitations

- **Disk assessment:** Evaluates storage capacity and available space. It does not perform a comprehensive physical disk health or SMART diagnostic.
- **CPU and memory:** Collects point-in-time utilization measurements rather than continuous performance monitoring.
- **Network connectivity:** Tests selected connectivity conditions, including TCP port 443. A successful TCP connection does not establish complete HTTPS certificate or application-level validity.
- **DNS diagnostics:** Results reflect DNS configuration and resolution at the time of execution.
- **Windows services:** Inspects selected service states without automatically modifying service configurations or starting and stopping services.
- **Service interpretation:** A manually configured Windows service may normally remain stopped when it is not needed.
- **Report consolidation:** Uses the latest available source report for each category. Source reports may have different generation timestamps.
- **Test coverage:** Initial functional testing does not cover every possible edge case or failure scenario.

## Skills Demonstrated

**Windows Administration**
- Windows operating system diagnostics.
- Hardware and system information collection.
- Disk capacity assessment.
- CPU and memory utilization monitoring.
- Windows services inspection.

**Networking and Troubleshooting**
- Network adapter status assessment.
- External IP connectivity testing.
- DNS resolution troubleshooting.
- TCP connectivity verification.

**Automation and Reporting**
- PowerShell scripting.
- Diagnostic workflow automation.
- TXT and CSV report generation.
- Consolidated reporting.
- Basic error handling and status reporting.

**Development Practices**
- Functional testing and validation.
- Technical documentation.
- Git version control.
- GitHub repository management.

## Future Development

Potential enhancements for future versions include:

- Expand error handling and edge-case testing.
- Introduce configurable diagnostic thresholds.
- Add continuous CPU and memory monitoring.
- Improve report formatting and diagnostic summaries.
- Implement automated test cases.
- Add a graphical user interface.
- Introduce report timestamp consistency checks.

## Project Information

| Attribute | Details |
|---|---|
| Project | Enterprise Windows Helpdesk Diagnostic Toolkit |
| Version | 1.0 |
| Category | IT Support / Windows Administration |
| Language | PowerShell |
| Status | Initial implementation and functional testing completed |
| Repository | [GitHub Project Repository](https://github.com/sharmiladeviramanujam/enterprise-windows-helpdesk-project) |

## Author's Note

This project was developed as a hands-on portfolio initiative to strengthen practical Windows troubleshooting, PowerShell automation, diagnostic reporting, and technical documentation skills relevant to entry-level IT Support and Helpdesk positions.
