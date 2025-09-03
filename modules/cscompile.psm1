<# 
Invoke .NET C# Compiler
Jordan
#>

function cscompile { # Works Global
param (
[Parameter(Mandatory=$true)]$codepath
)
    $csc = "$env:WINDIR\Microsoft.NET\Framework\v4.0.30319\csc.exe"
    & $csc "$codepath"
}

function cscompile2 { # For me
param (
[Parameter(Mandatory=$true)]$file
)
    $csc = "$env:WINDIR\Microsoft.NET\Framework\v4.0.30319\csc.exe"
    & $csc "D:\C#\$file.cs"
}
