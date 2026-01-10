function Get-Array-Sum {
    param (
        [array]$zenbakiak
    )

    $sum = 0

    foreach ( $n in $zenbakiak) {
        $sum += $n
    }

    Write-Output $sum
}