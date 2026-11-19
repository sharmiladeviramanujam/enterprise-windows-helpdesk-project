
# ============================================================
# PROJECT: Enterprise Windows Help Desk
# SCRIPT: System Information Collector
# PURPOSE: Collect basic computer configuration details
# VERSION: 1.0
# ============================================================

# 1. Define report location
$ReportFolder = Join-Path $PSScriptRoot "..\reports\before"

# Create report folder if it does not exist
New-Item -ItemType Directory -Path $ReportFolder -Force |
    Out-Null

# 2. Generate timestamp
$Date = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"

$ReportPath = Join-Path $ReportFolder "system-information-$Date.txt"

Write-Host "`nCollecting system information..." -ForegroundColor Cyan

try {

    # 3. Collect operating system information
    $OS = Get-CimInstance Win32_OperatingSystem -ErrorAction Stop

    # 4. Collect processor information
    $CPU = Get-CimInstance Win32_Processor -ErrorAction Stop

    # 5. Collect storage information
    $Disks = Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3" -ErrorAction Stop

    # 6. Collect network adapter information
    $Network = Get-NetAdapter -ErrorAction Stop

    # 7. Collect Windows registry version information
    $Registry = Get-ItemProperty `
        "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" `
        -ErrorAction Stop

    # 8. Create system information object
    $SystemInfo = [PSCustomObject]@{

        ComputerName = $OS.CSName

        WindowsProduct = $OS.Caption

        WindowsVersion = $OS.Version

        DisplayVersion = $Registry.DisplayVersion

        OSBuild = $OS.BuildNumber

        Processor = ($CPU.Name -join "; ")

        PhysicalCores = ($CPU.NumberOfCores -join "; ")

        LogicalProcessors = ($CPU.NumberOfLogicalProcessors -join "; ")

        TotalRAM_GB = [math]::Round(
            $OS.TotalVisibleMemorySize / 1MB, 2
        )

        FreeRAM_GB = [math]::Round(
            $OS.FreePhysicalMemory / 1MB, 2
        )

        LastBootTime = $OS.LastBootUpTime

        AssessmentDate = Get-Date
    }

    # 9. Generate report header
    $Report = @()

    $Report += "============================================"
    $Report += " WINDOWS SYSTEM INFORMATION REPORT"
    $Report += "============================================"
    $Report += ""

    $Report += "SYSTEM INFORMATION"
    $Report += "--------------------------------------------"

    $Report += ($SystemInfo | Format-List | Out-String)

    # 10. Add storage information
    $Report += "STORAGE INFORMATION"
    $Report += "--------------------------------------------"

    foreach ($Disk in $Disks) {

        $TotalGB = [math]::Round($Disk.Size / 1GB, 2)

        $FreeGB = [math]::Round($Disk.FreeSpace / 1GB, 2)

        $UsedGB = [math]::Round(
            ($Disk.Size - $Disk.FreeSpace) / 1GB, 2
        )

        $Report += "Drive: $($Disk.DeviceID)"
        $Report += "Total Space: $TotalGB GB"
        $Report += "Used Space: $UsedGB GB"
        $Report += "Free Space: $FreeGB GB"
        $Report += ""
    }

    # 11. Add network information
    $Report += "NETWORK ADAPTER INFORMATION"
    $Report += "--------------------------------------------"

    $Report += ($Network |
        Select-Object Name, Status, LinkSpeed |
        Format-Table -AutoSize |
        Out-String)

    # 12. Save report
    $Report | Out-File -FilePath $ReportPath -Encoding utf8

    # 13. Display results
    Write-Host "`nSYSTEM INFORMATION" -ForegroundColor Green

    $SystemInfo | Format-List

    Write-Host "`nReport generated successfully!" -ForegroundColor Green

    Write-Host "Report location: $ReportPath" -ForegroundColor Yellow

}
catch {

    Write-Host "`nAn error occurred while collecting system information." -ForegroundColor Red

    Write-Host $_.Exception.Message -ForegroundColor Red
}
