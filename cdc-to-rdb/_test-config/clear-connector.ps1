
function Remove-Json {
    [CmdletBinding()]
    param (
        [ValidateNotNullOrEmpty()]
        [string[]]$Name,
        [string]$JsonPath
    )
    process {
        $_network = "--network=test-kpt"
        $_bootstrap = "kafka:9092"

        $_connector = Get-Content "$JsonPath" | ConvertFrom-Json 
        $_server_name = $_connector.config."database.server.name"

        $_name = $Name -join "__"
        $_topic = "$_server_name.*"
        
        docker run -it --rm --name $_name `
            $_network `
            wurstmeister/kafka:2.13-2.7.0 bash -c `
            "kafka-topics.sh --bootstrap-server $_bootstrap --topic $_topic --delete"

        # $_topic_list = @()
        # $_topic_list += $_connector.config."database.history.kafka.topic"
        # $_topic_list += $_connector.config."transforms.Reroute.topic.replacement"
                
        # $_topic_all = $(
        #     docker run -it --rm --name $_name `
        #         $_network `
        #         wurstmeister/kafka:2.13-2.7.0 bash -c `
        #         "kafka-topics.sh --bootstrap-server $_bootstrap  --list"
        # )
        # $_topic_all | Where-Object { $_.StartsWith("$_server_name") } | ForEach-Object {
        #     $_topic_list += $_
        # }
        # $_topic_list | Where-Object { $_ -ne $null } | ForEach-Object {
        #     Write-Host "process topic $_"

        #     $_name = $Name -join "__"
        #     docker run -it --rm --name $_name `
        #         $_network `
        #         wurstmeister/kafka:2.13-2.7.0 bash -c `
        #         "kafka-topics.sh --bootstrap-server $_bootstrap --topic $_ --delete"
        # }
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
            $_name = Split-Path -LeafBase $sub_path
            $_name = $_name.replace('.','_')
            Remove-Json ($name + $_name) $sub_path
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
        $_name = Split-Path -LeafBase $json
        $_name = $_name.replace('.','_')
        Remove-Json ($name + $_name) $json
    }

    Write-Host ""
    Write-Host "any key exit..."
    Read-Host | Out-Null
    Exit
}
