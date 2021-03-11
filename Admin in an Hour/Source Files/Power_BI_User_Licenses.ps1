$m = "MSOnline"
$outPath = "C:\"

# Determines if final character is a forward slash, if not concatenates to the outPath variable
if ($outPath.Substring($outPath.Length - 1, 1) -cne "\") {
    $outPath = $outPath + "\"
}

# Determines if Module already exists, if not installs
if (Get-Module -ListAvailable -Name $m) {
        write-host "Module $m is already imported."
    } 
    else {
        Install-Module -Name $m -Force -Verbose -Scope CurrentUser
        Import-Module $m -Verbose
}

Connect-MsolService
$licenseType = "Power_BI_Pro", "Power_BI_Standard"
$allUsers = Get-MsolUser -All | Where-Object {$_.isLicensed -eq "True"}

foreach ($license in $licenseType) {

    $Licenses = $allUsers | Where-Object {($_.licenses).AccountSkuId -match ($license)} | Select-Object objectId, WhenCreated, SignInName , displayName, Title, City, State, Country

    Write-Host "Now Exporting Report: $($license)"
    $Licenses | Export-Csv -Path "$($outPath)$($license)_$(Get-Date -Format "yyyyMMdd").csv" -NoTypeInformation

}