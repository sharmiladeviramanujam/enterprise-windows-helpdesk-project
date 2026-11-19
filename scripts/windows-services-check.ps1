
# ============================================================
# PROJECT: Enterprise Windows Help Desk
# SCRIPT: Windows Services Checker
# PURPOSE: Inspect selected Windows service statuses
# VERSION: 1.0
# ============================================================

# 1. Define report location
$ReportFolder = Join-Path $PSScriptRoot "..\reports"

New-Item -ItemType Directory -Path $ReportFolder -Force |
    Out-Null

# 2. Generate timestamp
$Date = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"

$TextReport = Join-Path $ReportFolder "windows-services-$Date.txt"
$CsvReport = Join-Path $ReportFolder "windows-services-$Date.csv"

Write-Host "`nStarting Windows Services Assessment..." -ForegroundColor Cyan

# 3. Define services to monitor
$ServiceNames = @(
    "Spooler",
    "WlanSvc",
    "Dhcp",
    "Dnscache",
    "wuauserv",
    "BITS"
)

try {

    # 4. Retrieve service information
    $Results = foreach ($ServiceName in $ServiceNames) {

        $Service = Get-CimInstance Win32_Service `
            -Filter "Name='$ServiceName'" `
            -ErrorAction Stop

        if ($null -eq $Service) {

            $Status = "NOT FOUND"
            $DisplayName = "Not installed or unavailable"
            $StartMode = "Unknown"
            $Details = "Service was not found."

        }
        else {

            $DisplayName = $Service.DisplayName

            $StartMode = $Service.StartMode

            $Details = "Service state: $($Service.State)"

            if ($Service.State -eq "Running") {

                $Status = "RUNNING"

            }
            elseif ($Service.State -eq "Stopped") {

                $Status = "STOPPED"

            }
            else {

                $Status = "OTHER"

            }
        }

        [PSCustomObject]@{

            ServiceName = $ServiceName

            DisplayName = $DisplayName

            State = if ($Service) { $Service.State } else { "Not Found" }

            StartMode = $StartMode

            Status = $Status

            Details = $Details

        }
    }

    # 5. Display results
    Write-Host "`nWINDOWS SERVICES ASSESSMENT" -ForegroundColor Green

    $Results |
        Format-Table ServiceName, State, StartMode, Status -AutoSize

    # 6. Generate text report
    $Report = @()

    $Report += "=========================================="
    $Report += " WINDOWS SERVICES DIAGNOSTIC REPORT"
    $Report += "=========================================="
    $Report += "Assessment Date: $(Get-Date)"
    $Report += ""

    foreach ($Result in $Results) {

        $Report += "Service: $($Result.ServiceName)"

        $Report += "Display Name: $($Result.DisplayName)"

        $Report += "State: $($Result.State)"

        $Report += "Startup Mode: $($Result.StartMode)"

        $Report += "Status: $($Result.Status)"

        $Report += "Details: $($Result.Details)"

        $Report += "------------------------------------------"
    }

    # 7. Save reports
    $Report | Out-File -FilePath $TextReport -Encoding utf8

    $Results | Export-Csv -Path $CsvReport -NoTypeInformation

    # 8. Generate summary
    $Running = @(
        $Results | Where-Object Status -eq "RUNNING"
    ).Count

    $Stopped = @(
        $Results | Where-Object Status -eq "STOPPED"
    ).Count

    $Missing = @(
        $Results | Where-Object Status -eq "NOT FOUND"
    ).Count

    Write-Host "`nASSESSMENT SUMMARY" -ForegroundColor Cyan

    Write-Host "Total services checked: $($Results.Count)"

    Write-Host "Running services: $Running"

    Write-Host "Stopped services: $Stopped"

    Write-Host "Unavailable services: $Missing"

    Write-Host "`nReports generated successfully!" -ForegroundColor Green

    Write-Host "Text Report: $TextReport" -ForegroundColor Yellow

    Write-Host "CSV Report: $CsvReport" -ForegroundColor Yellow

}
catch {

    Write-Host "`nWindows services assessment failed." -ForegroundColor Red

    Write-Host $_.Exception.Message -ForegroundColor Red
}
