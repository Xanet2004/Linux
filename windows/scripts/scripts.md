# PowerShell Basic Scripting Cheat Sheet

## 1️⃣ Creating a Script

- PowerShell scripts are plain text files with `.ps1` extension.
- Example:

```powershell
# hello.ps1
Write-Host "Hello, world!"
```

To run a script:

```powershell
.\hello.ps1
```

⚠️ You may need to set the execution policy to allow scripts:

```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```

## 2️⃣ Variables

```powershell
# Simple variable
$greeting = "Hello"
$name = "Xanet"

# Combine
$message = "$greeting, $name"
Write-Host $message

# Numeric
$age = 20
$sum = $age + 5
```

## 3️⃣ Conditionals (if / elseif / else)

```powershell
$number = 10

if ($number -gt 15) {
    Write-Host "Greater than 15"
}
elseif ($number -eq 10) {
    Write-Host "Exactly 10"
}
else {
    Write-Host "Something else"
}
```

Comparison operators:
- -eq → equals
- -ne → not equal
- -gt → greater than
- -lt → less than
- -ge → greater or equal
- -le → less or equal

## 4️⃣ Loops

For loop

```powershell
for ($i = 1; $i -le 5; $i++) {
    Write-Host "Iteration $i"
}
```

While loop

```powershell
$count = 1
while ($count -le 5) {
    Write-Host "Count: $count"
    $count++
}
```

Foreach loop

```powershell
$users = @("Alice","Bob","Charlie")
foreach ($user in $users) {
    Write-Host "User: $user"
}
```

## 5️⃣ Functions

```powershell
function Greet($name) {
    Write-Host "Hello, $name!"
}

# Call function
Greet "Xanet"
```

## 6️⃣ Parameters in Scripts

You can pass arguments to scripts:

```powershell
# greet.ps1
param (
    [string]$Name,
    [int]$Age = 18   # default value
)
Write-Host "Hello $Name, you are $Age years old"
```

Run script with parameters:

```powershell
.\greet.ps1 -Name "Xanet" -Age 20
```

Or using positional parameters:

```powershell
.\greet.ps1 "Xanet" 20
```

## 7️⃣ Reading User Input

```powershell
$name = Read-Host "Enter your name"
Write-Host "Hello, $name!"
```

## 8️⃣ Combining Loops, Conditionals, and Parameters

```powershell
param (
    [int]$max = 5
)

for ($i = 1; $i -le $max; $i++) {
    if ($i % 2 -eq 0) {
        Write-Host "$i is even"
    }
    else {
        Write-Host "$i is odd"
    }
}
```

Run with a parameter:

```powershell
.\script.ps1 -max 10
```

## 9️⃣ Using Return Values

```powershell
Copy code
function Add-Numbers($a, $b) {
    return $a + $b
}

$result = Add-Numbers 5 10
Write-Host "Result: $result"
```

### 🔹 Tips
1. Always test scripts with small examples first.
2. Use Write-Host for output during learning/debugging.
3. Use comments # to annotate your code.
4. Scripts can accept arrays and loops over them:

```powershell
param([string[]]$Names)
foreach ($n in $Names) {
    Write-Host "Hello $n"
}
```
