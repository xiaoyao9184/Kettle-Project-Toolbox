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

        $_profile = $ComposeYaml.services["$Service"].environment["KPT_KETTLE_PARAM_ProfileName"]
        
        $_bootstrap = $_profile -split "," | ForEach-Object {
            Write-Host "process profile $_ for _bootstrap"
            $_xpath = "//config/project/profile[@name='$_']/cfg[@namespace='Config' and @key='CDC.Kafka.Server.Bootstrap']"
            $_node = Select-Xml -XPath "$_xpath" -Path "$Workspace/config.xml"
            return $_node ? $_node.node.InnerXML : $null
        } | Where-Object { $_ } | Select-Object -First 1
    
        $_group = $_profile -split "," | ForEach-Object {
            Write-Host "process profile $_ for _group"
            $_xpath = "//config/project/profile[@name='$_']/cfg[@namespace='Config' and @key='CDC.Kafka.Consumer.Group']"
            $_node = Select-Xml -XPath "$_xpath" -Path "$Workspace/config.xml"
            return $_node ? $_node.node.InnerXML : $null
        } | Where-Object { $_ } | Select-Object -First 1

        $_topic = $_profile -split "," | ForEach-Object {
            Write-Host "process profile $_ for _topic"
            $_xpath = "//config/project/profile[@name='$_']/cfg[@namespace='Config' and @key='CDC.Log.Kafka.Topic']"
            $_node = Select-Xml -XPath "$_xpath" -Path "$Workspace/config.xml"
            return $_node ? $_node.node.InnerXML : $null
        } | Where-Object { $_ } | Select-Object -First 1
    
        Write-Host "${_group}@${_bootstrap}/${_topic}"

        $_name = ($Name + $Service + "topic") -join "__"
        docker run -it --rm --name $_name `
            $_network `
            wurstmeister/kafka:2.13-2.7.0 bash -c `
            "kafka-topics.sh --bootstrap-server $_bootstrap --topic $_topic --create --replication-factor 1 --partitions 1"
        
        docker run -it --rm --name $_name `
            $_network `
            wurstmeister/kafka:2.13-2.7.0 bash -c `
            "kafka-configs.sh --bootstrap-server $_bootstrap --alter --entity-type topics --entity-name $_topic --add-config retention.ms=-1"

        $_pg_host = $_profile -split "," | ForEach-Object {
            Write-Host "process profile $_ for _pg_host"
            $_xpath = "//config/project/profile[@name='$_']/cfg[@namespace='Config' and @key='CDC.RDB.Writer.Server']"
            $_node = Select-Xml -XPath "$_xpath" -Path "$Workspace/config.xml"
            return $_node ? $_node.node.InnerXML : $null
        } | Where-Object { $_ } | Select-Object -First 1

        $_pg_port = $_profile -split "," | ForEach-Object {
            Write-Host "process profile $_ for _pg_port"
            $_xpath = "//config/project/profile[@name='$_']/cfg[@namespace='Config' and @key='CDC.RDB.Writer.Port']"
            $_node = Select-Xml -XPath "$_xpath" -Path "$Workspace/config.xml"
            return $_node ? $_node.node.InnerXML : $null
        } | Where-Object { $_ } | Select-Object -First 1
    
        $_pg_database = $_profile -split "," | ForEach-Object {
            Write-Host "process profile $_ for _pg_database"
            $_xpath = "//config/project/profile[@name='$_']/cfg[@namespace='Config' and @key='CDC.RDB.Writer.Database']"
            $_node = Select-Xml -XPath "$_xpath" -Path "$Workspace/config.xml"
            return $_node ? $_node.node.InnerXML : $null
        } | Where-Object { $_ } | Select-Object -First 1
    
        $_pg_log_schema = $_profile -split "," | ForEach-Object {
            Write-Host "process profile $_ for _pg_log_schema"
            $_xpath = "//config/project/profile[@name='$_']/cfg[@namespace='Config' and @key='CDC.Log.RDB.Schema']"
            $_node = Select-Xml -XPath "$_xpath" -Path "$Workspace/config.xml"
            return $_node ? $_node.node.InnerXML : $null
        } | Where-Object { $_ } | Select-Object -First 1

        $_pg_user=$pg_root_user
        $_pg_password=$pg_root_password
        
        Write-Host "${_pg_user}:${_pg_password}@${_pg_host}:${_pg_port}/${_pg_database}"
    
        $_name = ($Name + $Service + "pgsql") -join "__"

        (Get-Content "$Workspace/../kpt_cdc_log/add.sql").replace('kpt_cdc_log', "$_pg_log_schema") `
            | Set-Content "$Workspace/../kpt_cdc_log/$_name.sql"

        docker run -it --rm --name $_name `
            $_network `
            --mount "type=bind,source=$Workspace/../kpt_cdc_log/$_name.sql,destination=/pgconf/clear-log.sql" `
            --env MODE=sqlrunner `
            --env PG_USER=$_pg_user `
            --env PG_PASSWORD=$_pg_password `
            --env PG_HOST=$_pg_host `
            --env PG_PORT=$_pg_port `
            --env PG_DATABASE=$_pg_database `
            crunchydata/crunchy-postgres:centos8-13.3-4.6.3

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
