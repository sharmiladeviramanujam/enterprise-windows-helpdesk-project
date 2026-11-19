

\# Functional Testing – Enterprise Windows Helpdesk Project



\## Project Overview

Testing of seven PowerShell scripts developed for Windows IT Support diagnostics and automation.



\## Test Results



| Script | Test | Result |

|---|---|---|

| System Information | Collect system details and generate TXT report | PASS |

| Disk Health | Assess disk capacity and generate TXT/CSV reports | PASS |

| CPU and Memory | Check CPU and RAM usage | PASS |

| Internet Connectivity | Test adapter, IP, DNS and HTTPS connectivity | PASS |

| DNS Diagnostic | Test DNS configuration and domain resolution | PASS |

| Windows Services | Inspect selected Windows services | PASS |

| Report Generator | Consolidate six diagnostic categories | PASS |



\## Consolidated Report Results



\- Total diagnostic categories: 6

\- Successful categories: 6

\- Warnings: 0

\- Missing reports: 0

\- Failed imports: 0

\- Combined records: 17



\## Observations



1\. Disk C: had approximately 73.92% free space.

2\. CPU usage was 3% during the assessment.

3\. RAM usage was approximately 73.07%.

4\. All five internet connectivity checks passed.

5\. All three DNS domain lookups succeeded.

6\. Five selected Windows services were running; Windows Update was stopped with Manual startup.

7\. The consolidated report successfully imported TXT and CSV source reports.



\## Conclusion



All seven scripts executed successfully during the functional test.



The automated report generator successfully collected all six diagnostic categories and generated consolidated TXT and CSV reports.



Further testing is required for missing files, invalid CSV data, and other error-handling scenarios.



