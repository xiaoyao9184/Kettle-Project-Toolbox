Import-Module powershell-yaml

$pg_root_user="postgres"
$pg_root_password="P@ssw0rd"

function Add-Service {
    [CmdletBinding()]
    param (
        [ValidateNotNullOrEmpty()]
        [string[]]$Name,
        [string]$Workspace,
        [hashtable]$ComposeYaml,
        [string]$Service
    )
    process {
        
        $_network = $ComposeYaml.services["$Service"].networks | ForEach-Object {
            return "--network=$_"
        }
        $_network = $_network -join " "

        $_name = ($Name + $Service + "chameleon") -join "__"

        docker run -it --rm --name $_name `
            $_network `
            --mount "type=bind,source=$Workspace/chameleon.yml,destination=/root/.pg_chameleon/configuration/mysql-to-pgsql.yml" `
            --mount "type=bind,source=$Workspace/../chameleon/only_init.sh,destination=/root/.pg_chameleon/only_init.sh" `
            --env PC_CONFIG=mysql-to-pgsql `
            --env PC_SOURCE=mysql `
            --env PC_SCHEMA=test_kpt_cdc `
            --entrypoint=/bin/ash `
            kivra/pg_chameleon:2.0.16 `
            /root/.pg_chameleon/only_init.sh

    }
}

function Add-Workspace {
    [CmdletBinding()]
    param (
        [ValidateNotNullOrEmpty()]
        [string[]]$Name,
        [string]$Workspace
    )
    process {
        Write-Host "Run $Name in $Workspace"
        $workspace_name = Split-Path -LeafBase $workspace

        [string[]]$_file_lines = Get-Content "$Workspace/docker-compose.yml"
        $_file_content = ''
        foreach ($line in $_file_lines) { $_file_content = $_file_content + "`n" + $line }
        $ComposeYaml = ConvertFrom-YAML $_file_content

        $ComposeYaml.services.Keys | ForEach-Object {
            Write-Host "process service $_"
            Add-Service ($Name + $workspace_name) $Workspace $ComposeYaml $_
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
    
    if( $workspace ){
        $workspace = Resolve-Path -Path "$workspace"
        Add-Workspace ($name + $script_name) $workspace
    } else {
        Write-Host "Run all"
        $sub_paths = Get-ChildItem -Path $parent_path -Attributes d
        foreach ($sub_path in $sub_paths){
            $workspace = $sub_path
            if (-not(Test-Path -Path "$workspace/docker-compose.yml" -PathType Leaf)) {
                continue
            }
            Write-Host "process workspace $workspace"
            Add-Workspace ($name + $script_name) $workspace
        }
    }

    Write-Host ""
    Write-Host "any key exit..."
    Read-Host | Out-Null
    Exit
}
