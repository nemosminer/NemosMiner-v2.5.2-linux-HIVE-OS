. .\Include.ps1

try {
    $Zpool_Request = Invoke-WebRequest "http://www.zpool.ca/api/status" -UseBasicParsing -Headers @{"Cache-Control"="no-cache"} | ConvertFrom-Json } catch { return }

if (-not $Zpool_Request) {return}

$Name = (Get-Item $script:MyInvocation.MyCommand.Path).BaseName

$Location = "US"

$Zpool_Request | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name | ForEach-Object {
    $Zpool_Host = "$_.mine.zpool.ca"
    $Zpool_Port = $Zpool_Request.$_.port
    $Zpool_Algorithm = Get-Algorithm $Zpool_Request.$_.name
    $Zpool_Coin = ""

    $Divisor = 1000000000
	
    switch ($Zpool_Algorithm) {
        "equihash"{$Divisor /= 1000}
        "blake2s"{$Divisor *= 1000}
        "blakecoin"{$Divisor *= 1000}
        "decred"{$Divisor *= 1000}
	"keccak"{$Divisor *= 1000}
    }

    if ((Get-Stat -Name "$($Name)_$($Zpool_Algorithm)_Profit") -eq $null) {$Stat = Set-Stat -Name "$($Name)_$($Zpool_Algorithm)_Profit" -Value ([Double]$Zpool_Request.$_.actual_last24h / $Divisor *(1-($Zpool_Request.$_.fees/100)))}
    else {$Stat = Set-Stat -Name "$($Name)_$($Zpool_Algorithm)_Profit" -Value ([Double]$Zpool_Request.$_.actual_last24h / $Divisor *(1-($Zpool_Request.$_.fees/100)))}
	
    if ($Wallet) {
        [PSCustomObject]@{
            Algorithm     = $Zpool_Algorithm
            Info          = $Zpool_Coin
            Price         = $Stat.Live
            StablePrice   = $Stat.Week
            MarginOfError = $Stat.Week_Fluctuation
            Protocol      = "stratum+tcp"
            Host          = $Zpool_Host
            Port          = $Zpool_Port
            User          = $Wallet
            Pass          = "$WorkerName,c=$Passwordcurrency"
            Location      = $Location
            SSL           = $false
        }
    }
}
