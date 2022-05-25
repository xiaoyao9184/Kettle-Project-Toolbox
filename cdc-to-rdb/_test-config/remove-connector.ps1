
function Remove-Json {
    [CmdletBinding()]
    param (
        [ValidateNotNullOrEmpty()]
        [string[]]$Name,
        [string]$JsonPath
    )
    process {
        $_connector = Get-Content "$JsonPath" | ConvertFrom-Json 
        $_name = $_connector.name

        Invoke-WebRequest -Method 'DELETE' `
            -Uri "http://localhost:58083/connectors/$_name"
    }
}

function Remove-Workspace {
    [CmdletBinding()]
    param (
        [ValidateNotNullOrEmpty()]
        [string[]]$Name,
        [string]$Workspace
    )
    process {
        Write-Host "Run $Name in $Workspace"

        $sub_paths = Get-ChildItem -Path "$Workspace\*" -Include *.json 
        foreach ($sub_path in $sub_paths){
            Write-Host "process json $sub_path"
            Remove-Json ($name) $sub_path
        }
    }
    
}

#Run alone by default
$CallStack = Get-PSCallStack | Where-Object  {$_.Command -ne "<ScriptBlock>"}
if($CallStack.Count -eq 1){
    
    $script_name = Split-Path -LeafBase $MyInvocation.MyCommand.Definition
    $parent_path = Split-Path -Parent $MyInvocation.MyCommand.Definition
    $parent_name = Split-Path -LeafBase $parent_path

    # default param
    $name = @("test-kpt-$parent_name")
    $workspace = $args[0]
    
    if( ! $workspace ){
        $workspace = "$parent_path/config_of_connector"
    }

    $is_path = Test-Path -Path $workspace -PathType Container
    if( $is_path ){
        $workspace = Resolve-Path -Path "$workspace"
        Remove-Workspace ($name + $script_name) $workspace
    } else {
        $json = Resolve-Path -Path "$workspace"
        Remove-Json ($name + $script_name) $json
    }

    Write-Host ""
    Write-Host "any key exit..."
    Read-Host | Out-Null
    Exit
}