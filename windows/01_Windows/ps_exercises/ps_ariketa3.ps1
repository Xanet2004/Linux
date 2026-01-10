function Get-Fibonacci {
    param (
        [int]$count
    )

    $fibonacci=@()

    for ($i = 0; $i -lt $count; $i++) {
        if ($i -eq 0) {
            $fibonacci += 0
        }
        elseif ($i -eq 1) {
            $fibonacci += 1
        }
        else {
            $fibonacci += $fibonacci[$i-1] + $fibonacci[$i-2]
        }
    }

    Write-Output $fibonacci
}