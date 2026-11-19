# Enterprise Windows Helpdesk Diagnostic Toolkit

## Project Overview

The **Enterprise Windows Helpdesk Diagnostic Toolkit** is a PowerShell-based IT support project designed to automate common Windows system diagnostic tasks.

It collects system information, evaluates disk capacity, checks CPU and memory usage, tests network connectivity, diagnoses DNS resolution, inspects selected Windows services, and generates consolidated diagnostic reports.

This project demonstrates practical technical skills relevant to entry-level IT Support, Desktop Support, and Helpdesk roles.

## Project Objectives

- Automate routine Windows diagnostic tasks.
- Collect system and hardware information.
- Identify potential disk-space and resource-usage concerns.
- Troubleshoot basic internet and DNS connectivity.
- Inspect important Windows service states.
- Generate structured TXT and CSV diagnostic reports.
- Practise PowerShell scripting, testing, and technical documentation.

## Features

| Script | Functionality |
|---|---|
| `system-information.ps1` | Collects Windows, CPU, RAM, and system information |
| `disk-health-check.ps1` | Checks disk capacity and available storage |
| `cpu-memory-check.ps1` | Collects CPU and memory usage information |
| `internet-connectivity.ps1` | Tests network adapters, IP connectivity, DNS, and TCP port 443 |
| `dns-diagnostic.ps1` | Checks DNS configuration and domain resolution |
| `windows-services-check.ps1` | Inspects selected Windows services |
| `generate-report.ps1` | Consolidates diagnostic results into TXT and CSV reports |

## Technologies Used

- **Operating System:** Windows 11
- **Scripting Language:** PowerShell
- **Report Formats:** TXT and CSV
- **Version Control:** Git
- **Repository Hosting:** GitHub

## Project Structure

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
|-- reports/
|   |-- before/
|   |-- Generated diagnostic reports
|
|-- documentation/
|   |-- system-assessment.md
|   |-- functional-testing.md
|
|-- README.md
```

## How to Run the Project

### Requirements

- Windows 10 or Windows 11
- Windows PowerShell 5.1 or a compatible PowerShell version
- Appropriate permissions to execute PowerShell scripts
- Internet connectivity for network and DNS tests

### Step 1: Clone the Repository

```powershell
git clone YOUR_GITHUB_REPOSITORY_URL
```

Replace the placeholder with your actual GitHub repository URL.

### Step 2: Navigate to the Project Directory

```powershell
cd enterprise-windows-helpdesk-project
```

### Step 3: Run the Diagnostic Scripts

Execute the scripts individually:

```powershell
.\scripts\system-information.ps1
.\scripts\disk-health-check.ps1
.\scripts\cpu-memory-check.ps1
.\scripts\internet-connectivity.ps1
.\scripts\dns-diagnostic.ps1
.\scripts\windows-services-check.ps1
```

### Step 4: Generate the Consolidated Report

After running the diagnostic scripts, execute:

```powershell
.\scripts\generate-report.ps1
```

The report generator collects the latest available diagnostic reports and generates consolidated TXT and CSV outputs.

## Functional Testing Results

All seven scripts were executed successfully during the initial functional testing.

| Test Category | Result |
|---|---|
| System Information | PASS |
| Disk Capacity Check | PASS |
| CPU and Memory Check | PASS |
| Internet Connectivity | PASS |
| DNS Diagnostics | PASS |
| Windows Services Inspection | PASS |
| Consolidated Report Generation | PASS |

### Consolidated Report Summary

- Total diagnostic categories: 6
- Successful categories: 6
- Warnings: 0
- Missing reports: 0
- Failed imports: 0
- Combined records: 17

## Important Technical Notes and Limitations

- The disk script evaluates storage capacity and available space. It does not perform a complete physical disk or SMART health assessment.
- CPU and memory measurements are point-in-time snapshots, not continuous monitoring.
- The internet connectivity test checks TCP connectivity on port 443. It does not perform complete HTTPS certificate validation or application-level testing.
- DNS results represent the configuration and resolution status at the time of execution.
- The Windows services script inspects service states. It does not automatically start or stop services.
- A Windows service configured for manual startup may be stopped without indicating a problem.
- The report generator uses the latest available source reports, which may have been generated at different times.
- The initial functional testing does not cover every possible error-handling or failure scenario.

## Skills Demonstrated

- PowerShell scripting and automation
- Windows operating system diagnostics
- System and hardware information collection
- Disk capacity assessment
- CPU and RAM usage assessment
- Network connectivity troubleshooting
- DNS troubleshooting
- Windows services inspection
- TXT and CSV report generation
- Functional testing and validation
- Technical documentation
- Git and GitHub project management

## Future Improvements

- Implement additional error handling and edge-case tests.
- Add configurable diagnostic thresholds.
- Introduce a graphical user interface.
- Add timestamp and system metadata validation to consolidated reports.
- Improve report formatting and diagnostic summaries.
- Develop automated test cases for script reliability.

## Project Status

**Version:** 1.0

**Status:** Initial implementation and functional testing completed.

This project was developed as a practical portfolio project to demonstrate foundational Windows IT Support skills and PowerShell automation capabilities.