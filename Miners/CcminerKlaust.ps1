. .\Include.ps1

$Path = ".\Bin\ccminer.bat"
$Uri = "https://github.com/KlausT/ccminer/releases/download/8.20/ccminer-820-cuda91-x64.zip"

$Commands = [PSCustomObject]@{
    #"bitcore" = "" #Bitcore
    #"blake2s" = "" #Blake2s
    #"blakecoin" = "" #Blakecoin
    #"vanilla" = "" #BlakeVanilla
    #"cryptonight" = "" #Cryptonight
    #"decred" = "" #Decred
    #"equihash" = "" #Equihash
    #"ethash" = "" #Ethash
    #"groestl" = " -d $SelGPUCC" #Groestl
    #"hmq1725" = "" #hmq1725
    #"keccak" = "" #Keccak
    #"lbry" = "" #Lbry
    #"lyra2v2" = " -d $SelGPUCC" #Lyra2RE2
    #"lyra2z" = "" #Lyra2z
    #"myr-gr" = " -d $SelGPUCC" #MyriadGroestl
    #"neoscrypt" = " -b 4068 -d $SelGPUCC" #NeoScrypt
    #"nist5" = " -d $SelGPUCC" #Nist5
    #"pascal" = "" #Pascal
    #"qubit" = "" #Qubit
    #"scrypt" = "" #Scrypt
    #"sia" = "" #Sia
    #"sib" = "" #Sib
    #"skein" = "" #Skein
    #"timetravel" = "" #Timetravel
    #"x11" = "" #X11
    #"veltor" = "" #Veltor
    #"x11evo" = "" #X11evo
    #"x17" = "" #X17
    #"yescrypt" = "" #Yescrypt
}

$Name = (Get-Item $script:MyInvocation.MyCommand.Path).BaseName

$Commands | Get-Member -MemberType NoteProperty | Select -ExpandProperty Name | ForEach {
    [PSCustomObject]@{
        Type = "NVIDIA"
        Path = $Path
        Arguments = "klaust -a $_ -o stratum+tcp://$($Pools.(Get-Algorithm($_)).Host):$($Pools.(Get-Algorithm($_)).Port) -u $($Pools.(Get-Algorithm($_)).User) -p $($Pools.(Get-Algorithm($_)).Pass)$($Commands.$_)"
        HashRates = [PSCustomObject]@{(Get-Algorithm($_)) = $Stats."$($Name)_$(Get-Algorithm($_))_HashRate".Live}
        API = "Ccminer"
        Port = 4068
        Wrap = $false
        URI = $Uri
    }
}
