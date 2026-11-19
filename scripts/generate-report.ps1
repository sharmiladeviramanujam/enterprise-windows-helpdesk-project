
# ==============================================
# IT SUPPORT AUTOMATION TOOLKIT
# Script 07: Automated Diagnostic Report Generator
# ==============================================

# STEP 1: Define project paths

$ProjectRoot = Split-Path $PSScriptRoot -Parent

$ReportsFolder = Join-Path $ProjectRoot "reports"

$BeforeFolder = Join-Path $ReportsFolder "before"

$Timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"

$TextReport = Join-Path $ReportsFolder "final-diagnostic-report-$Timestamp.txt"

$CsvReport = Join-Path $ReportsFolder "final-diagnostic-report-$Timestamp.csv"


# STEP 2: Create reports folder if missing

if (-not (Test-Path $ReportsFolder)) {

    New-Item -ItemType Directory -Path $ReportsFolder -Force |
        Out-Null

}


# STEP 3: Display starting message

Write-Host ""

Write-Host "==============================================" -ForegroundColor Cyan

Write-Host " IT SUPPORT AUTOMATED DIAGNOSTIC REPORT" -ForegroundColor Cyan

Write-Host "==============================================" -ForegroundColor Cyan

Write-Host ""

Write-Host "Collecting diagnostic reports..." -ForegroundColor Yellow


# STEP 4: Define diagnostic report categories

$DiagnosticFiles = @(

    @{
        Name = "System Information"
        Pattern = "system-information-*.txt"
        Folder = $BeforeFolder
        Format = "TXT"
    }

    @{
        Name = "Disk Health"
        Pattern = "disk-health-*.csv"
        Folder = $ReportsFolder
        Format = "CSV"
    }

    @{
        Name = "CPU and Memory"
        Pattern = "cpu-memory-*.csv"
        Folder = $ReportsFolder
        Format = "CSV"
    }

    @{
        Name = "Internet Connectivity"
        Pattern = "internet-connectivity-*.csv"
        Folder = $ReportsFolder
        Format = "CSV"
    }

    @{
        Name = "DNS Diagnostic"
        Pattern = "dns-diagnostic-*.csv"
        Folder = $ReportsFolder
        Format = "CSV"
    }

    @{
        Name = "Windows Services"
        Pattern = "windows-services-*.csv"
        Folder = $ReportsFolder
        Format = "CSV"
    }

)


# STEP 5: Initialize collections

$CombinedData = @()

$Warnings = @()

$CategoryResults = @()

$ReportContent = @()


# STEP 6: Process diagnostic reports

foreach ($Item in $DiagnosticFiles) {

    Write-Host ""

    Write-Host "Checking: $($Item.Name)" -ForegroundColor Cyan

    $LatestFile = Get-ChildItem -Path $Item.Folder `
        -Filter $Item.Pattern `
        -File `
        -ErrorAction SilentlyContinue |
        Sort-Object LastWriteTime -Descending |
        Select-Object -First 1


    if ($LatestFile) {

        try {

            if ($Item.Format -eq "TXT") {

                # Read TXT report

                $Data = Get-Content -Path $LatestFile.FullName -Raw -ErrorAction Stop

                if (-not [string]::IsNullOrWhiteSpace($Data)) {

                    Write-Host "TXT report imported successfully." -ForegroundColor Green

                    $Status = "SUCCESS"

                    $ReportContent += ""
                    $ReportContent += "--------------- SYSTEM INFORMATION DETAILS ---------------"
                    $ReportContent += "Source File: $($LatestFile.Name)"
                    $ReportContent += $Data

                    $CombinedData += [PSCustomObject]@{

                        Category = $Item.Name

                        SourceFile = $LatestFile.Name

                        ReportDate = $LatestFile.LastWriteTime

                        Details = $Data -replace '[\r\n]+', ' | '

                    }

                }
                else {

                    Write-Host "TXT report is empty." -ForegroundColor Yellow

                    $Status = "EMPTY"

                    $Warnings += "$($Item.Name): TXT report is empty."

                }

            }
            else {

                # Read CSV report

                $Data = @(Import-Csv -Path $LatestFile.FullName -ErrorAction Stop)

                if ($Data.Count -gt 0) {

                    Write-Host "CSV report imported successfully." -ForegroundColor Green

                    $Status = "SUCCESS"

                    foreach ($Row in $Data) {

                        $CombinedData += [PSCustomObject]@{

                            Category = $Item.Name

                            SourceFile = $LatestFile.Name

                            ReportDate = $LatestFile.LastWriteTime

                            Details = ($Row | ConvertTo-Json -Compress)

                        }

                    }

                }
                else {

                    Write-Host "CSV report is empty." -ForegroundColor Yellow

                    $Status = "EMPTY"

                    $Warnings += "$($Item.Name): CSV report is empty."

                }

            }

        }
        catch {

            Write-Host "Unable to read report." -ForegroundColor Red

            $Status = "ERROR"

            $Warnings += "$($Item.Name): $($_.Exception.Message)"

        }

    }
    else {

        Write-Host "No matching report found." -ForegroundColor Yellow

        $Status = "MISSING"

        $Warnings += "$($Item.Name): Report not found."

    }


    # Store category status

    $CategoryResults += [PSCustomObject]@{

        Category = $Item.Name

        Status = $Status

    }

}


# STEP 7: Generate readable TXT report

$ReportContent += "================================================"

$ReportContent += "       IT SUPPORT DIAGNOSTIC REPORT"

$ReportContent += "================================================"

$ReportContent += "Computer Name : $env:COMPUTERNAME"

$ReportContent += "Generated On  : $(Get-Date)"

$ReportContent += "Generated By  : $env:USERNAME"

$ReportContent += ""

$ReportContent += "--------------- CATEGORY RESULTS ---------------"

foreach ($Category in $CategoryResults) {

    $ReportContent += "$($Category.Category) : $($Category.Status)"

}

$ReportContent += ""

$ReportContent += "------------------- SUMMARY --------------------"

$ReportContent += "Total Categories : $($DiagnosticFiles.Count)"

$ReportContent += "Successful       : $(($CategoryResults | Where-Object Status -eq 'SUCCESS').Count)"

$ReportContent += "Empty Reports    : $(($CategoryResults | Where-Object Status -eq 'EMPTY').Count)"

$ReportContent += "Missing Reports  : $(($CategoryResults | Where-Object Status -eq 'MISSING').Count)"

$ReportContent += "Failed Imports   : $(($CategoryResults | Where-Object Status -eq 'ERROR').Count)"

$ReportContent += "Combined Records : $($CombinedData.Count)"

$ReportContent += ""

$ReportContent += "------------------- WARNINGS -------------------"

if ($Warnings.Count -gt 0) {

    foreach ($Warning in $Warnings) {

        $ReportContent += "- $Warning"

    }

}
else {

    $ReportContent += "No warnings detected."

}

$ReportContent += ""

$ReportContent += "================================================"

$ReportContent += "                 END OF REPORT"

$ReportContent += "================================================"


# STEP 8: Save TXT report

$ReportContent | Out-File -FilePath $TextReport -Encoding utf8


# STEP 9: Save consolidated CSV report

if ($CombinedData.Count -gt 0) {

    $CombinedData | Export-Csv -Path $CsvReport -NoTypeInformation -Encoding UTF8

}


# STEP 10: Display final results

Write-Host ""

Write-Host "==============================================" -ForegroundColor Cyan

Write-Host "       REPORT GENERATION COMPLETED" -ForegroundColor Green

Write-Host "==============================================" -ForegroundColor Cyan

Write-Host ""

Write-Host "Text Report: $TextReport"

if ($CombinedData.Count -gt 0) {

    Write-Host "CSV Report : $CsvReport"

}
else {

    Write-Host "CSV Report : Not generated (no records found)."

}

Write-Host ""

Write-Host "Total Categories : $($DiagnosticFiles.Count)"

Write-Host "Successful       : $(($CategoryResults | Where-Object Status -eq 'SUCCESS').Count)"

Write-Host "Warnings         : $($Warnings.Count)"

Write-Host "Combined Records : $($CombinedData.Count)"

Write-Host ""

Write-Host "Diagnostic report generation finished." -ForegroundColor Green

Write-Host ""
