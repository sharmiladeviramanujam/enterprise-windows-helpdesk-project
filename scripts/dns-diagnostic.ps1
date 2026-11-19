
# ============================================================
# PROJECT: Enterprise Windows Help Desk
# SCRIPT: DNS Diagnostic Tool
# PURPOSE: Investigate DNS configuration and name resolution
# VERSION: 1.0
# ============================================================

# 1. Define report location
$ReportFolder = Join-Path $PSScriptRoot "..\reports"

New-Item -ItemType Directory -Path $ReportFolder -Force |
    Out-Null

# 2. Generate timestamp
$Date = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"

$TextReport = Join-Path $ReportFolder "dns-diagnostic-$Date.txt"
$CsvReport = Join-Path $ReportFolder "dns-diagnostic-$Date.csv"

Write-Host "`nStarting DNS Diagnostic Assessment..." -ForegroundColor Cyan

try {

    # 3. Collect DNS server configuration
    Write-Host "`nChecking configured DNS servers..." -ForegroundColor Cyan

    $DNSConfig = Get-DnsClientServerAddress -ErrorAction Stop

    $ActiveDNS = $DNSConfig | Where-Object {
        $_.ServerAddresses.Count -gt 0
    }

    # 4. Define domains to test
    $Domains = @(
        "example.com",
        "microsoft.com",
        "google.com"
    )

    # 5. Perform DNS resolution tests
    Write-Host "`nTesting domain resolution..." -ForegroundColor Cyan

    $Results = foreach ($Domain in $Domains) {

        try {

            $DNSResult = Resolve-DnsName `
                -Name $Domain `
                -Type A `
                -DnsOnly `
                -ErrorAction Stop

            $Addresses = @(
                $DNSResult |
                Where-Object { $_.Type -eq "A" } |
                Select-Object -ExpandProperty IPAddress
            )

            if ($Addresses.Count -gt 0) {

                $Status = "PASS"

                $Details = $Addresses -join ", "

            }
            else {

                $Status = "FAIL"

                $Details = "No IPv4 address returned."

            }

        }
        catch {

            $Status = "FAIL"

            $Details = $_.Exception.Message

        }

        [PSCustomObject]@{

            Domain = $Domain

            Status = $Status

            IPAddresses = $Details

            AssessmentDate = Get-Date
        }
    }

    # 6. Collect DNS cache information
    Write-Host "`nChecking local DNS cache..." -ForegroundColor Cyan

    try {

        $DNSCache = Get-DnsClientCache -ErrorAction Stop

        $CacheCount = @($DNSCache).Count

        $CacheStatus = "AVAILABLE"

    }
    catch {

        $CacheCount = 0

        $CacheStatus = "UNAVAILABLE"

    }

    # 7. Display DNS configuration
    Write-Host "`nCONFIGURED DNS SERVERS" -ForegroundColor Green

    $ActiveDNS |
        Select-Object InterfaceAlias, AddressFamily, ServerAddresses |
        Format-Table -AutoSize

    # 8. Display resolution results
    Write-Host "`nDNS RESOLUTION RESULTS" -ForegroundColor Green

    $Results | Format-Table Domain, Status, IPAddresses -AutoSize

    # 9. Create text report
    $Report = @()

    $Report += "=========================================="
    $Report += " DNS DIAGNOSTIC REPORT"
    $Report += "=========================================="
    $Report += "Assessment Date: $(Get-Date)"
    $Report += ""

    $Report += "CONFIGURED DNS SERVERS"
    $Report += "------------------------------------------"

    foreach ($Server in $ActiveDNS) {

        $Report += "Interface: $($Server.InterfaceAlias)"

        $Report += "Address Family: $($Server.AddressFamily)"

        $Report += "DNS Servers: $($Server.ServerAddresses -join ', ')"

        $Report += ""
    }

    $Report += "DOMAIN RESOLUTION RESULTS"
    $Report += "------------------------------------------"

    foreach ($Result in $Results) {

        $Report += "Domain: $($Result.Domain)"

        $Report += "Status: $($Result.Status)"

        $Report += "IP Addresses: $($Result.IPAddresses)"

        $Report += "------------------------------------------"
    }

    $Report += ""
    $Report += "LOCAL DNS CACHE"
    $Report += "------------------------------------------"
    $Report += "Cache Status: $CacheStatus"
    $Report += "Cache Entries: $CacheCount"

    # 10. Save reports
    $Report | Out-File -FilePath $TextReport -Encoding utf8

    $Results | Export-Csv -Path $CsvReport -NoTypeInformation

    # 11. Display summary
    $Passed = @($Results | Where-Object Status -eq "PASS").Count

    $Failed = @($Results | Where-Object Status -eq "FAIL").Count

    Write-Host "`nDNS ASSESSMENT SUMMARY" -ForegroundColor Cyan

    Write-Host "Total domains tested: $($Results.Count)"

    Write-Host "Successful lookups: $Passed"

    Write-Host "Failed lookups: $Failed"

    Write-Host "DNS cache entries: $CacheCount"

    Write-Host "`nReports generated successfully!" -ForegroundColor Green

    Write-Host "Text Report: $TextReport" -ForegroundColor Yellow

    Write-Host "CSV Report: $CsvReport" -ForegroundColor Yellow

}
catch {

    Write-Host "`nDNS assessment failed." -ForegroundColor Red

    Write-Host $_.Exception.Message -ForegroundColor Red
}
