function Send-Mysql {
    [CmdletBinding()]
    param (
        [ValidateNotNullOrEmpty()]
        [string[]]$Name,
        [string]$SqlPath
    )
    process {
        $_name = $Name -join "__"
        $_network = "--network=test-kpt"

        docker run -it --rm --name $_name `
            $_network `
            --mount "type=bind,source=$SqlPath,destination=/run.sql" `
            --entrypoint /bin/bash `
            mysql:5.7 `
            -c "mysql -hmysql -uroot -pP@ssw0rd < /run.sql"
    }
}

function Send-Sql {
    [CmdletBinding()]
    param (
        [ValidateNotNullOrEmpty()]
        [string[]]$Name,
        [string]$SqlPath
    )
    process {

        $parent_path = Split-Path -Parent $SqlPath
        $db_platform = Split-Path -LeafBase $parent_path
        
        Switch ($db_platform)
        {
            "mysql" { Send-Mysql ($Name) $SqlPath }
            default { Write-Host "Not support database platform" }
        }

    }
}

function Send-Workspace {
    [CmdletBinding()]
    param (
        [ValidateNotNullOrEmpty()]
        [string[]]$Name,
        [string]$Workspace
    )
    process {
        Write-Host "Run $Name in $Workspace"

        $sub_paths = Get-ChildItem -Path "$Workspace\*" -Include *.sql 
        foreach ($sub_path in $sub_paths){
            Write-Host "process sql $sub_path"
            Send-Sql ($name) $sub_path
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
        Write-Host "Run all"
        $sub_paths = Get-ChildItem -Path "$parent_path/signal_of_connector" -Attributes d
        foreach ($sub_path in $sub_paths){
            $workspace = $sub_path
            Write-Host "process workspace $workspace"
            Send-Workspace ($name + $script_name) $workspace
        }
    } else {
        $is_path = Test-Path -Path $workspace -PathType Container
        if( $is_path ){
            $workspace = Resolve-Path -Path "$workspace"
            Send-Workspace ($name + $script_name) $workspace
        } else {
            $json = Resolve-Path -Path "$workspace"
            Send-Sql ($name + $script_name) $json
        }
    }
    
    Write-Host ""
    Write-Host "any key exit..."
    Read-Host | Out-Null
    Exit
}
