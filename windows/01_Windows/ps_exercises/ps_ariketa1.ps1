function Get-Sum {
    param (
        [int]$zenbakia1,
        [int]$zenbakia2
    )

    $sum = $zenbakia1 + $zenbakia2
    Write-Output $sum
}