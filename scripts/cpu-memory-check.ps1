
# ============================================================
# PROJECT: Enterprise Windows Help Desk
# SCRIPT: CPU & RAM Monitor
# PURPOSE: Assess CPU and memory utilization
# VERSION: 1.0
# ============================================================

# 1. Define report location
$ReportFolder = Join-Path $PSScriptRoot "..\reports"

New-Item -ItemType Directory -Path $ReportFolder -Force |
    Out-Null

# 2. Generate timestamp
$Date = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"

$TextReport = Join-Path $ReportFolder "cpu-memory-$Date.txt"
$CsvReport = Join-Path $ReportFolder "cpu-memory-$Date.csv"

Write-Host "`nStarting CPU and RAM Assessment..." -ForegroundColor Cyan

try {

    # 3. Collect CPU information
    $CPU = Get-CimInstance Win32_Processor -ErrorAction Stop

    # 4. Calculate average CPU utilization
    $CpuAverage = ($CPU | Measure-Object -Property LoadPercentage -Average).Average

    if ($null -eq $CpuAverage) {
        throw "CPU utilization data is unavailable."
    }

    $CpuUsage = [math]::Round($CpuAverage, 2)

    # 5. Collect operating system memory information
    $OS = Get-CimInstance Win32_OperatingSystem -ErrorAction Stop

    $TotalRAM = $OS.TotalVisibleMemorySize

    $FreeRAM = $OS.FreePhysicalMemory

    $UsedRAM = $TotalRAM - $FreeRAM

    # 6. Calculate RAM utilization
    $TotalRAM_GB = [math]::Round($TotalRAM / 1MB, 2)

    $UsedRAM_GB = [math]::Round($UsedRAM / 1MB, 2)

    $FreeRAM_GB = [math]::Round($FreeRAM / 1MB, 2)

    $RAMUsage = [math]::Round(
        ($UsedRAM / $TotalRAM) * 100, 2
    )

    # 7. Classify CPU utilization
    if ($CpuUsage -ge 85) {

        $CPUStatus = "HIGH"

    }
    elseif ($CpuUsage -ge 70) {

        $CPUStatus = "ELEVATED"

    }
    else {

        $CPUStatus = "NORMAL"

    }

    # 8. Classify RAM utilization
    if ($RAMUsage -ge 85) {

        $RAMStatus = "HIGH"

    }
    elseif ($RAMUsage -ge 70) {

        $RAMStatus = "ELEVATED"

    }
    else {

        $RAMStatus = "NORMAL"

    }

    # 9. Create structured assessment
    $Results = [PSCustomObject]@{

        ComputerName = $OS.CSName

        Processor = ($CPU.Name -join "; ")

        PhysicalCores = ($CPU.NumberOfCores -join "; ")

        LogicalProcessors = ($CPU.NumberOfLogicalProcessors -join "; ")

        CPU_Usage_Percent = $CpuUsage

        CPU_Status = $CPUStatus

        TotalRAM_GB = $TotalRAM_GB

        UsedRAM_GB = $UsedRAM_GB

        FreeRAM_GB = $FreeRAM_GB

        RAM_Usage_Percent = $RAMUsage

        RAM_Status = $RAMStatus

        AssessmentDate = Get-Date
    }

    # 10. Display results
    Write-Host "`nCPU AND RAM ASSESSMENT" -ForegroundColor Green

    $Results | Format-List

    # 11. Generate text report
    $Report = @()

    $Report += "=========================================="
    $Report += " CPU AND RAM DIAGNOSTIC REPORT"
    $Report += "=========================================="
    $Report += "Assessment Date: $(Get-Date)"
    $Report += ""

    $Report += "PROCESSOR ASSESSMENT"
    $Report += "------------------------------------------"
    $Report += "Processor: $($Results.Processor)"
    $Report += "CPU Usage: $($Results.CPU_Usage_Percent)%"
    $Report += "CPU Status: $($Results.CPU_Status)"
    $Report += ""

    $Report += "MEMORY ASSESSMENT"
    $Report += "------------------------------------------"
    $Report += "Total RAM: $($Results.TotalRAM_GB) GB"
    $Report += "Used RAM: $($Results.UsedRAM_GB) GB"
    $Report += "Free RAM: $($Results.FreeRAM_GB) GB"
    $Report += "RAM Usage: $($Results.RAM_Usage_Percent)%"
    $Report += "RAM Status: $($Results.RAM_Status)"
    $Report += ""

    # 12. Save reports
    $Report | Out-File -FilePath $TextReport -Encoding utf8

    $Results | Export-Csv -Path $CsvReport -NoTypeInformation

    # 13. Display diagnostic summary
    Write-Host "`nASSESSMENT SUMMARY" -ForegroundColor Cyan

    Write-Host "CPU Status: $CPUStatus"

    Write-Host "RAM Status: $RAMStatus"

    Write-Host "`nReports generated successfully!" -ForegroundColor Green

    Write-Host "Text Report: $TextReport" -ForegroundColor Yellow

    Write-Host "CSV Report: $CsvReport" -ForegroundColor Yellow

}
catch {

    Write-Host "`nCPU and RAM assessment failed." -ForegroundColor Red

    Write-Host $_.Exception.Message -ForegroundColor Red
}
