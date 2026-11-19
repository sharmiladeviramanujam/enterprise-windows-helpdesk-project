
# ============================================================
# PROJECT: Enterprise Windows Help Desk
# SCRIPT: Disk Health Checker
# PURPOSE: Monitor disk capacity and identify low disk space
# VERSION: 1.0
# ============================================================

# 1. Define report directory
$ReportFolder = Join-Path $PSScriptRoot "..\reports"

New-Item -ItemType Directory -Path $ReportFolder -Force |
    Out-Null

# 2. Generate timestamp
$Date = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"

$TextReport = Join-Path $ReportFolder "disk-health-$Date.txt"
$CsvReport = Join-Path $ReportFolder "disk-health-$Date.csv"

Write-Host "`nStarting Disk Health Assessment..." -ForegroundColor Cyan

try {

    # 3. Retrieve fixed local disks
    $Disks = Get-CimInstance Win32_LogicalDisk `
        -Filter "DriveType=3" -ErrorAction Stop

    if (-not $Disks) {
        throw "No fixed local disks were detected."
    }

    # 4. Create an assessment collection
    $Results = foreach ($Disk in $Disks) {

        $TotalGB = [math]::Round($Disk.Size / 1GB, 2)

        $FreeGB = [math]::Round($Disk.FreeSpace / 1GB, 2)

        $UsedGB = [math]::Round(
            ($Disk.Size - $Disk.FreeSpace) / 1GB, 2
        )

        $FreePercent = [math]::Round(
            ($Disk.FreeSpace / $Disk.Size) * 100, 2
        )

        # 5. Classify disk capacity
        if ($FreePercent -lt 10) {

            $Status = "CRITICAL"

        }
        elseif ($FreePercent -lt 20) {

            $Status = "WARNING"

        }
        else {

            $Status = "HEALTHY"

        }

        # 6. Return structured disk information
        [PSCustomObject]@{

            Drive = $Disk.DeviceID

            VolumeName = $Disk.VolumeName

            TotalGB = $TotalGB

            UsedGB = $UsedGB

            FreeGB = $FreeGB

            FreePercent = $FreePercent

            Status = $Status
        }
    }

    # 7. Display results
    Write-Host "`nDISK ASSESSMENT RESULTS" -ForegroundColor Green

    $Results | Format-Table -AutoSize

    # 8. Generate text report
    $Report = @()

    $Report += "=========================================="
    $Report += " WINDOWS DISK CAPACITY REPORT"
    $Report += "=========================================="
    $Report += "Assessment Date: $(Get-Date)"
    $Report += ""

    foreach ($Result in $Results) {

        $Report += "Drive: $($Result.Drive)"
        $Report += "Volume: $($Result.VolumeName)"
        $Report += "Total Space: $($Result.TotalGB) GB"
        $Report += "Used Space: $($Result.UsedGB) GB"
        $Report += "Free Space: $($Result.FreeGB) GB"
        $Report += "Free Percentage: $($Result.FreePercent)%"
        $Report += "Status: $($Result.Status)"
        $Report += "------------------------------------------"
    }

    # 9. Save text and CSV reports
    $Report | Out-File -FilePath $TextReport -Encoding utf8

    $Results | Export-Csv -Path $CsvReport -NoTypeInformation

    # 10. Display final status
    if ($Results.Status -contains "CRITICAL") {

        Write-Host "`nCRITICAL: Immediate storage investigation recommended." -ForegroundColor Red

    }
    elseif ($Results.Status -contains "WARNING") {

        Write-Host "`nWARNING: Storage space should be investigated." -ForegroundColor Yellow

    }
    else {

        Write-Host "`nAll detected drives meet the configured storage threshold." -ForegroundColor Green

    }

    Write-Host "`nReports generated successfully!" -ForegroundColor Green

    Write-Host "Text report: $TextReport" -ForegroundColor Yellow

    Write-Host "CSV report: $CsvReport" -ForegroundColor Yellow

}
catch {

    Write-Host "`nDisk assessment failed." -ForegroundColor Red

    Write-Host $_.Exception.Message -ForegroundColor Red
}
