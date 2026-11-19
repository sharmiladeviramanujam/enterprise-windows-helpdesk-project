
# ============================================================
# PROJECT: Enterprise Windows Help Desk
# SCRIPT: Internet Connectivity Checker
# PURPOSE: Diagnose network and internet connectivity
# VERSION: 1.0
# ============================================================

# 1. Define report location
$ReportFolder = Join-Path $PSScriptRoot "..\reports"

New-Item -ItemType Directory -Path $ReportFolder -Force |
    Out-Null

# 2. Generate timestamp
$Date = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"

$TextReport = Join-Path $ReportFolder "internet-connectivity-$Date.txt"
$CsvReport = Join-Path $ReportFolder "internet-connectivity-$Date.csv"

Write-Host "`nStarting Internet Connectivity Assessment..." -ForegroundColor Cyan

# 3. Create result collection
$Results = @()

try {

    # 4. Check network adapters
    Write-Host "`nChecking network adapters..." -ForegroundColor Cyan

    $Adapters = Get-NetAdapter -ErrorAction Stop

    foreach ($Adapter in $Adapters) {

        if ($Adapter.Status -eq "Up") {
            $AdapterStatus = "PASS"
        }
        else {
            $AdapterStatus = "INFO"
        }

        $Results += [PSCustomObject]@{

            Category = "Network Adapter"

            Target = $Adapter.Name

            Status = $AdapterStatus

            Details = "Connection: $($Adapter.Status); Link Speed: $($Adapter.LinkSpeed)"
        }
    }

    # 5. Test external IP connectivity
    Write-Host "`nTesting external IP connectivity..." -ForegroundColor Cyan

    try {

        $IPTest = Test-NetConnection `
            -ComputerName "1.1.1.1" `
            -Port 443 `
            -InformationLevel Quiet `
            -WarningAction SilentlyContinue `
            -ErrorAction Stop

        if ($IPTest) {
            $IPStatus = "PASS"
            $IPDetails = "External IP endpoint is reachable on TCP port 443."
        }
        else {
            $IPStatus = "FAIL"
            $IPDetails = "External IP endpoint was not reachable on TCP port 443."
        }
    }
    catch {

        $IPStatus = "ERROR"
        $IPDetails = $_.Exception.Message
    }

    $Results += [PSCustomObject]@{

        Category = "IP Connectivity"

        Target = "1.1.1.1"

        Status = $IPStatus

        Details = $IPDetails
    }

    # 6. Test DNS resolution
    Write-Host "`nTesting DNS resolution..." -ForegroundColor Cyan

    try {

        $DNSResult = Resolve-DnsName `
            -Name "example.com" `
            -Type A `
            -DnsOnly `
            -ErrorAction Stop

        $DNSAddresses = (
            $DNSResult |
            Where-Object { $_.Type -eq "A" } |
            Select-Object -ExpandProperty IPAddress
        ) -join ", "

        if ($DNSAddresses) {
            $DNSStatus = "PASS"
            $DNSDetails = "Domain resolved successfully. Addresses: $DNSAddresses"
        }
        else {
            $DNSStatus = "FAIL"
            $DNSDetails = "No IPv4 address was returned."
        }
    }
    catch {

        $DNSStatus = "ERROR"
        $DNSDetails = $_.Exception.Message
    }

    $Results += [PSCustomObject]@{

        Category = "DNS Resolution"

        Target = "example.com"

        Status = $DNSStatus

        Details = $DNSDetails
    }

    # 7. Test HTTPS connectivity
    Write-Host "`nTesting HTTPS connectivity..." -ForegroundColor Cyan

    try {

        $HTTPSTest = Test-NetConnection `
            -ComputerName "example.com" `
            -Port 443 `
            -InformationLevel Quiet `
            -WarningAction SilentlyContinue `
            -ErrorAction Stop

        if ($HTTPSTest) {
            $HTTPSStatus = "PASS"
            $HTTPSDetails = "HTTPS endpoint is reachable on TCP port 443."
        }
        else {
            $HTTPSStatus = "FAIL"
            $HTTPSDetails = "HTTPS endpoint was not reachable on TCP port 443."
        }
    }
    catch {

        $HTTPSStatus = "ERROR"
        $HTTPSDetails = $_.Exception.Message
    }

    $Results += [PSCustomObject]@{

        Category = "HTTPS Connectivity"

        Target = "example.com:443"

        Status = $HTTPSStatus

        Details = $HTTPSDetails
    }

    # 8. Display results
    Write-Host "`nCONNECTIVITY ASSESSMENT RESULTS" -ForegroundColor Green

    $Results |
        Format-Table Category, Target, Status -AutoSize

    # 9. Generate text report
    $Report = @()

    $Report += "=========================================="
    $Report += " INTERNET CONNECTIVITY REPORT"
    $Report += "=========================================="
    $Report += "Assessment Date: $(Get-Date)"
    $Report += ""

    foreach ($Result in $Results) {

        $Report += "Category: $($Result.Category)"
        $Report += "Target: $($Result.Target)"
        $Report += "Status: $($Result.Status)"
        $Report += "Details: $($Result.Details)"
        $Report += "------------------------------------------"
    }

    # 10. Save reports
    $Report | Out-File -FilePath $TextReport -Encoding utf8

    $Results | Export-Csv -Path $CsvReport -NoTypeInformation

    # 11. Display final summary
    $FailedTests = @(
        $Results | Where-Object {
            $_.Status -eq "FAIL" -or $_.Status -eq "ERROR"
        }
    )

    Write-Host "`nASSESSMENT SUMMARY" -ForegroundColor Cyan

    Write-Host "Total checks: $($Results.Count)"

    Write-Host "Failed or errored checks: $($FailedTests.Count)"

    Write-Host "`nReports generated successfully!" -ForegroundColor Green

    Write-Host "Text Report: $TextReport" -ForegroundColor Yellow

    Write-Host "CSV Report: $CsvReport" -ForegroundColor Yellow

}
catch {

    Write-Host "`nConnectivity assessment failed." -ForegroundColor Red

    Write-Host $_.Exception.Message -ForegroundColor Red
}
