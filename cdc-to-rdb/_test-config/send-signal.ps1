function Send-Kafka {
    [CmdletBinding()]
    param (
        [ValidateNotNullOrEmpty()]
        [string[]]$Name,
        [string]$FilePath
    )
    process {
        $_name = $Name -join "__"

        $_json = Get-Content "$FilePath" | ConvertFrom-Json 
        $_network = $_json.network | ForEach-Object {
            return "--network=$_"
        }
        $_bootstrap = $_json.bootstrap
        $_topic = $_json.topic
        $_file_parent = Split-Path -Parent $FilePath
        $_file_name = Split-Path -LeafBase $FilePath
        $_file = Join-Path -Path $_file_parent -ChildPath ($_file_name + '.csv')

        docker run -it --rm --name $_name `
            $_network `
            --mount "type=bind,source=$_file,destination=/send.csv" `
            --entrypoint sh `
            edenhill/kcat:1.7.1 `
                -c "kcat -b $_bootstrap -t $_topic -P -K, < /send.csv"

    }
}

function Send-Mysql {
    [CmdletBinding()]
    param (
        [ValidateNotNullOrEmpty()]
        [string[]]$Name,
        [string]$FilePath
    )
    process {
        $_name = $Name -join "__"

        $_json = Get-Content "$FilePath" | ConvertFrom-Json 
        $_network = $_json.network | ForEach-Object {
            return "--network=$_"
        }
        $_host = $_json.host
        $_user = $_json.user
        $_password = $_json.password
        $_file_parent = Split-Path -Parent $FilePath
        $_file_name = Split-Path -LeafBase $FilePath
        $_file = Join-Path -Path $_file_parent -ChildPath ($_file_name + '.sql')

        docker run -it --rm --name $_name `
            $_network `
            --mount "type=bind,source=$_file,destination=/send.sql" `
            --entrypoint /bin/bash `
            mysql:5.7 `
                -c "mysql -h$_host -u$_user -p$_password < /send.sql"
    }
}

function Send-Sql {
    [CmdletBinding()]
    param (
        [ValidateNotNullOrEmpty()]
        [string[]]$Name,
        [string]$FilePath
    )
    process {

        $parent_path = Split-Path -Parent $FilePath
        $db_platform = Split-Path -LeafBase $parent_path
        
        Switch ($db_platform)
        {
            "mysql" { Send-Mysql ($Name) $FilePath }
            "kafka" { Send-Kafka ($Name) $FilePath }
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

        $sub_paths = Get-ChildItem -Path "$Workspace\*" -Include *.json 
        foreach ($sub_path in $sub_paths){
            Write-Host "process json $sub_path"
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
