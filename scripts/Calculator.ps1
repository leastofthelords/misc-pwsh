<# 
Simple Calculator 1.0 
Jordan
#>

Write-Host "= = = PWSHCalculator = = ="

function Get-ValidInt($prompt) {
	
	do {
    $intinput = Read-Host -Prompt $prompt
    $valid = [int]::TryParse($intinput, [ref]$null)
	}
	
	until ($valid)
	
	return [int]$intinput
}

$input1 = (Get-ValidInt "Num1")
$input2 = (Get-ValidInt "Num2")

do {
$op = Read-Host -Prompt "(+, -, /, *,) Operation"
}
	
until ($op -eq "+" -or $op -eq "-" -or $op -eq "/" -or $op -eq "*")

switch ($op) {

    "+" {
        $result = ($input1 + $input2)
	}
	
    "-" {
        $result = ($input1 - $input2)       
    }

    "/" {
        $result = ($input1 / $input2)
    }

    "*" { 
        $result = ($input1 * $input2) 
    }
}

Write-Host "Result: $result"