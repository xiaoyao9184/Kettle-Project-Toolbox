Install-Module -Name powershell-yaml
Import-Module powershell-yaml


function Start-Workspace {
    [CmdletBinding()]
    param (
        [ValidateNotNullOrEmpty()]
        [string[]]$Name,
        [string]$Workspace
    )
    process {
        Set-Location -Path $Workspace
        Write-Host "Run $Name in $Workspace"

        [string[]]$_file_lines = Get-Content "$Workspace/docker-compose.yml"
        $_file_content = ''
        foreach ($line in $_file_lines) { $_file_content = $_file_content + "`n" + $line }
        $ComposeYaml = ConvertFrom-YAML $_file_content

        $ComposeYaml.services.Keys | ForEach-Object {
            Write-Host "process service $_"
            $ComposeYaml.services["$_"].networks | ForEach-Object {
                docker network create $_ --attachable
            }
        }
        
        $_name = $Name[0]
        
        docker-compose -p $_name up
    }
    
}

#Run alone by default
$CallStack = Get-PSCallStack | Where-Object  {$_.Command -ne "<ScriptBlock>"}
if($CallStack.Count -eq 1){
    
    $script_name = Split-Path -LeafBase $MyInvocation.MyCommand.Definition
    $parent_path = Split-Path -Parent $MyInvocation.MyCommand.Definition
    $parent_name = Split-Path -LeafBase $parent_path
    $current_directory = Get-Location

    # default param
    $name = @("test-kpt-$parent_name")
    $workspace = $args[0]
    
    if( $workspace ){
        $workspace = Resolve-Path -Path "$workspace"
        Start-Workspace ($name + $script_name) $workspace
    } else {
        Write-Host "Run all"
        $sub_paths = Get-ChildItem -Path $parent_path -Attributes d
        foreach ($sub_path in $sub_paths){
            $workspace = $sub_path
            if (-not(Test-Path -Path "$workspace/docker-compose.yml" -PathType Leaf)) {
                continue
            }
            Write-Host "process workspace $workspace"
            Start-Workspace ($name + $script_name) $workspace
        }
    }

    Set-Location -Path $current_directory
    Write-Host ""
    Write-Host "any key exit..."
    Read-Host | Out-Null
    Exit
}
