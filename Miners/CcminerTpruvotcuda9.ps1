. .\Include.ps1

$Path = ".\Bin\ccminer.bat"
$Uri = "https://github.com/tpruvot/ccminer/releases/download/2.2.4-tpruvot/ccminer-x86-2.2.4-cuda9.7z"

$Commands = [PSCustomObject]@{
    #"phi" = " -d $SelGPUCC --api-remote" #Phi
    #"bitcore" = " -d $SelGPUCC" #Bitcore
    "jha" = " -d $SelGPUCC --api-remote" #Jha
    #"blake2s" = " -d $SelGPUCC" #Blake2s
    #"blakecoin" = " -d $SelGPUCC" #Blakecoin
    #"vanilla" = "" #BlakeVanilla
    #"cryptonight" = " -i 10 -d $SelGPUCC" #Cryptonight
    #"decred" = "" #Decred
    "equihash" = " -d $SelGPUCC --api-remote" #Equihash
    "ethash" = " -d $SelGPUCC --api-remote" #Ethash
    "groestl" = " -d $SelGPUCC --api-remote" #Groestl
    "hmq1725" = " -d $SelGPUCC --api-remote" #hmq1725
    #"keccak" = "" #Keccak
    #"lbry" = " -d $SelGPUCC" #Lbry
    #"lyra2v2" = "" #Lyra2RE2
    #"lyra2z" = " -d $SelGPUCC" #Lyra2z
    #"myr-gr" = "" #MyriadGroestl
    "neoscrypt" = " -d $SelGPUCC --api-remote" #NeoScrypt
    #"nist5" = "" #Nist5
    #"pascal" = "" #Pascal
    #"qubit" = "" #Qubit
    #"scrypt" = "" #Scrypt
    #"sia" = "" #Sia
    #"sib" = "" #Sib
    #"skein" = "" #Skein
    #"skunk" = " -d $SelGPUCC" #Skunk
    "timetravel" = " -d $SelGPUCC --api-remote" #Timetravel
    "tribus" = " -d $SelGPUCC --api-remote" #Tribus
    #"x11" = "" #X11
    #"veltor" = "" #Veltor
    "x11evo" = " -d $SelGPUCC --api-remote" #X11evo
    #"x17" = " -d $SelGPUCC" #X17
    #"yescrypt" = "" #Yescrypt
}

$Name = (Get-Item $script:MyInvocation.MyCommand.Path).BaseName

$Commands | Get-Member -MemberType NoteProperty | Select -ExpandProperty Name | ForEach {
    [PSCustomObject]@{
        Type = "NVIDIA"
        Path = $Path
        Arguments = "tpruvot -a $_ -o stratum+tcp://$($Pools.(Get-Algorithm($_)).Host):$($Pools.(Get-Algorithm($_)).Port) -u $($Pools.(Get-Algorithm($_)).User) -p $($Pools.(Get-Algorithm($_)).Pass)$($Commands.$_)"
        HashRates = [PSCustomObject]@{(Get-Algorithm($_)) = $Stats."$($Name)_$(Get-Algorithm($_))_HashRate".Live}
        API = "Ccminer"
        Port = 4068
        Wrap = $false
        URI = $Uri
    }
}
