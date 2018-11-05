import hudson.model.*

def executor = Executor.currentExecutor()
def projectName = null
def pdiPath = null
def kptPath = null
def archivePath = null
def deployPath = null
def deployProfile = null


def customizeArchivePath = null
def customizeDeployPath = null
if(executor == null){
    println 'Job DSL in pipeline job, use variables for running!'
    
    // Get proper standard output from bindings
    def configuration = new HashMap()
    def binding = getBinding()
    configuration.putAll(binding.getVariables())

    projectName = configuration["ProjectName"] ?: null
    if(!projectName?.trim()){
        projectName = configuration["projectName"] ?: null
    }

    pdiPath = configuration["PDIPath"] ?: null
    if(!pdiPath?.trim()){
        pdiPath = configuration["pdiPath"] ?: null
    }

    kptPath = configuration["KPTPath"] ?: null
    if(!kptPath?.trim()){
        kptPath = configuration["kptPath"] ?: null
    }

    deployProfile = configuration["DeployProfile"] ?: null
    if(!deployProfile?.trim()){
        deployProfile = configuration["deployProfile"] ?: null
    }

    customizeArchivePath = configuration["ArchivePath"] ?: null
    if(!customizeArchivePath?.trim()){
        customizeArchivePath = configuration["archivePath"] ?: null
    }

    customizeDeployPath = configuration["DeployPath"] ?: null
    if(!customizeDeployPath?.trim()){
        customizeDeployPath = configuration["deployPath"] ?: null
    }
}else{
    println 'Job DSL in normal job, use Jenkins API for running!'

    Build build = executor.currentExecutable
    ParametersAction parametersAction = build.getAction(ParametersAction)
    parametersAction.parameters.each { ParameterValue v ->
        println v
    }
    
    ParameterValue pvProjectName = parametersAction.getParameter("ProjectName")
    if(pvProjectName != null){
        projectName = pvProjectName.getValue().toString()
    }
    
    ParameterValue pvPDIPath = parametersAction.getParameter("PDIPath")
    if(pvPDIPath != null){
        pdiPath = pvPDIPath.getValue().toString()
    }
    
    ParameterValue pvKPTPath = parametersAction.getParameter("KPTPath")
    if(pvKPTPath != null){
        kptPath = pvKPTPath.getValue().toString()
    }
    
    ParameterValue pvDeployProfile = parametersAction.getParameter("DeployProfile")
    if(pvDeployProfile != null){
        deployProfile = pvDeployProfile.getValue().toString()
    }
    
    ParameterValue pvArchivePath = parametersAction.getParameter("ArchivePath")
    if(pvArchivePath != null){
        customizeArchivePath = pvArchivePath.getValue().toString()
    }

    ParameterValue pvDeployPath = parametersAction.getParameter("DeployPath")
    if(pvDeployPath != null){
        customizeDeployPath = pvDeployPath.getValue().toString()
    }
}

/**
 * Check parameters
 */
if(!pdiPath?.trim()){
    throw new Exception("Cant find any deploy profile!")
    return
}
if(!kptPath?.trim()){
    throw new Exception("Cant find any deploy profile!")
    return
}
if(!deployProfile?.trim()){
    throw new Exception("Cant find any deploy profile!")
    return
}
if(customizeDeployPath?.trim()){
    println 'Try use parameter for project directory!'
    deployPath = new File(customizeDeployPath)
}else{
    throw new Exception("Cant find any project directory!")
    return
}
if(customizeArchivePath?.trim()){
    println 'Try use parameter for deploy directory!'
    archivePath = new File(customizeArchivePath)
}else{
    throw new Exception("Cant find any deploy directory!")
    return
}

/**
 * Get last archive file
 */
def archiveRegex = '\\[Deploy\\]' + projectName + '.*.zip'
def archiveFile = archivePath.listFiles({d, f -> f ==~ archiveRegex } as FilenameFilter).sort{ it.name }.reverse().first()
println 'Last archive is: ' + archiveFile.absolutePath

/**
 * Create workspace
 */
def workPath = deployPath.absolutePath + '\\' + archiveFile.name.take(archiveFile.name.lastIndexOf('.'))
def projectPath = workPath + '\\' + projectName
println 'Deploy project path is: ' + projectPath


/**
 * Unzip last archive file
 */
def ant = new AntBuilder()
ant.unzip(src:archiveFile.absolutePath,
            dest:projectPath,
            overwrite:"true")

/**
 * Active profile
 */
println 'Active profile...'
def profileFile = new File("${projectPath}/.profile/.profile")
profileFile.renameTo "${projectPath}/.profile/${deployProfile}.profile"

/**
 * Link PDI and KPT
 */
println 'Link PDI and KPT...'
println "cmd /c call ${kptPath}\\tool\\LINK_KPT.bat ${workPath} ${pdiPath}".execute().text

/**
 * Deploy Jenkins jobs 
 */

def ppf = new File(projectPath)
def jenkinsPath = new File(ppf, 'jenkins')
def jenkinsRegex = /.*\.jenkinsfile/
def jenkinsFiles = null
if(jenkinsPath.exists()) {
    println 'Find some jenkins job in project!'
    jenkinsFiles = jenkinsPath.listFiles({d, f -> f ==~ jenkinsRegex } as FilenameFilter)
    if(jenkinsFiles == null || jenkinsFiles.size() == 0){
        println "Cant find any jenkinsfile in 'jenkins/' directory!"
        throw new Exception("Cant find any jenkinsfile!")
        return
    }

    println 'Add Jenkins scheduling job...'
    jenkinsFiles.each { file ->
        def name = file.name.take(file.name.lastIndexOf('.'))
        println "Job file ${name}"
        
        pipelineJob("${name}") {
            def strip = file.text
            /**
            * Replace project path
            */
            if(projectPath != null && strip.contains('\'ProjectPath\'')){
                println "Need replace 'ProjectPath' parameter!"
                strip = strip.replace(/'ProjectPath'/, "'NotUse_ProjectPath'")
                parameters {
                    stringParam('ProjectPath', "${projectPath}")
                }
            }

            /**
            * Fix cron
            */
            def regexCron = /cron\('(.*)'\)/
            def findCron = (strip =~ /$regexCron/)
            if(findCron.count ==1 && findCron.hasGroup()){
                def cronStr = findCron[0][1]
                println "Need auto create cron ${cronStr} trigger form pipeline!"
                triggers {
                    cron("${cronStr}")
                }
            }

            definition {
                cps {
                    script(strip.stripIndent())
                    sandbox()
                }
            }
        }
    }
}

println 'Deploy archive done in: ' + projectPath
