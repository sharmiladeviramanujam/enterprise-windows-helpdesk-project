# Windows System Assessment Report

## 1. Project Information

- **Project:** Enterprise Windows Help Desk & Troubleshooting Project
- **Assessment Type:** Initial System Environment Assessment
- **Assessment Date:** 19 November 2026
- **Tools Used:** Windows PowerShell, CIM, Windows Management Instrumentation

## 2. Operating System Information

| Parameter | Observed Value |
|---|---|
| Product Name | Windows 10 Home Single Language |
| Initial Windows Version | 2009 |
| Registry Display Version | 25H2 |
| OS Build | 26200 |
| Edition ID | CoreSingleLanguage |

**Observation:** The reported Windows product name and version/build information are inconsistent. Further verification is required before confirming the exact Windows release.

## 3. Processor Information

| Parameter | Observed Value |
|---|---|
| Processor | Intel Core i5-1334U |
| Processor Generation | 13th Generation |
| Physical Cores | 10 |
| Logical Processors | 12 |
| Reported Maximum Clock Speed | 1300 MHz |

## 4. Memory Assessment

| Parameter | Observed Value |
|---|---|
| Total Visible RAM | 15.69 GB |
| Free Physical RAM | 3.53 GB |

**Observation:** Approximately 15.69 GB of memory is visible to Windows. Free memory is a point-in-time measurement.

## 5. Storage Assessment

| Parameter | Observed Value |
|---|---|
| Drive | C: |
| Total Capacity | 456.08 GB |
| Used Space | 118.61 GB |
| Free Space | 337.46 GB |

**Observation:** Approximately 74% of the reported C: drive capacity is free.

## 6. Network Assessment

| Adapter | Description | Status | Link Speed |
|---|---|---|---|
| Wi-Fi | Realtek 8821CE Wireless LAN 802.11ac PCI-E NIC | Up | 72.2 Mbps |
| Ethernet | Realtek PCIe GbE Family Controller | Disconnected | 0 bps |

**Observation:** The Wi-Fi adapter is active. Ethernet is disconnected.

## 7. Basic System Health

| Parameter | Observed Value |
|---|---|
| Last Boot Time | 16 October 2026, 17:47 |
| System Status | OK |

**Observation:** The operating system CIM query returned an OK status. This does not represent a complete hardware or software health assessment.

## 8. Tools and Commands Used

- Get-ComputerInfo
- Get-CimInstance Win32_Processor
- Get-CimInstance Win32_OperatingSystem
- Get-CimInstance Win32_LogicalDisk
- Get-NetAdapter
- Get-ItemProperty

## 9. Assessment Conclusion

The initial system assessment successfully collected operating system, processor, memory, storage, network and basic system information.

The collected information establishes a baseline for future Windows troubleshooting exercises.

The Windows version/build discrepancy remains an open investigation item.

## 10. Next Steps

- Verify the Windows release information.
- Develop PowerShell system diagnostic scripts.
- Investigate CPU and memory utilization.
- Perform disk and network diagnostics.
- Document troubleshooting findings and resolutions.
