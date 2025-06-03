function clip.setup {
    $bool = Test-Path -Path "C:\Users\$env:USERNAME\Documents\WindowsPowershell\Modules\clipper"

    If ($false -eq $bool) {
        return
    }
    
    else {
    New-item -Itemtype Directory -Name "clipper" -Path "C:\Users\$env:USERNAME\Documents\WindowsPowershell\Modules\"

    try {
    Move-item -Path "C:\Users\$env:USERNAME\Downloads\clipper.psm1" -destination
    }

    Catch {
    Write-Host errormsg: "$_ 'clipper.psm1' must be within \downloads, this function is not recursive."
    }
}
}


function clip.help {
    Write-Host "
    clip.new   [params: -name -content] [desc: creates new note]
    clip       [params -name]           [desc: save note content to clipboard]
    clip.list  [params -name]           [desc: lists  note names]
    clip.help                           [desc: this]
    clip.setup                          [desc: creates clip directory and moves module into]
    "
}

function clip.new {
param  (
    [string]$name,
    [string]$content
)

    New-Item -Path "C:\Users\$env:USERNAME\Documents\WindowsPowershell\Modules\clipper\"-Itemtype File -Name "$name" | Out-Null
    $entrydir = "C:\Users\$env:USERNAME\Documents\WindowsPowershell\Modules\clipper\"
    $itempath = Join-Path -Path $entrydir -childpath $name
    Set-Content -Path "$itempath" -Value $content
}

function clip {
param (
    [string]$name
    
)
    $entrydir = "C:\Users\$env:USERNAME\Documents\WindowsPowershell\Modules\clipper\"
    $completepath = Join-Path -Path $entrydir -ChildPath $name
    $forcopy = Get-Content $completepath
    Set-Clipboard -Value $forcopy
    Write-Host "Saved note: $name to clipboard."
}

function clip.list {
    (Get-ChildItem -path "C:\Users\$env:USERNAME\Documents\WindowsPowershell\Modules\clipper\" | Where-Object { -not $_.PSIsContainer -and [string]::IsNullOrEmpty($_.Extension) }).Name
}
