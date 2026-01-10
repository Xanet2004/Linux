$animals = @(
    @{
        Name    = "Lion"
        Species = "Panthera leo"
        Habitat = "Savanna"
        Diet    = "Carnivore"
    },
    @{
        Name    = "Elephant"
        Species = "Loxodonta africana"
        Habitat = "Forest"
        Diet    = "Herbivore"
    },
    @{
        Name    = "Dolphin"
        Species = "Delphinus delphis"
        Habitat = "Ocean"
        Diet    = "Carnivore"
    }
)

function Get-Carnivore {
    foreach ($animal in $animals) {
        if ($animal.Diet -eq "Carnivore"){
            Write-Output $animal
        }
    }
}