/**
 * Created by xiaoyao9184 on 2018/11/21.
 */
import hudson.model.*
import hudson.FilePath

def files = null
def customizeProjectPath = null
def jenkinsPath = null
def executor = Executor.currentExecutor()

if(executor == null){
    println 'Job DSL in pipeline job, use variables for running!'
    
    // Get proper standard output from bindings
    def configuration = new HashMap()
    def binding = getBinding()
    configuration.putAll(binding.getVariables())

    customizeProjectPath = configuration["ProjectPath"] ?: null
    if(!customizeProjectPath?.trim()){
        customizeProjectPath = configuration["projectPath"] ?: null
    }

    if(customizeProjectPath?.trim()){
        println 'Try use parameter for work directory!'
        def wd = new FilePath(new File(customizeProjectPath))
        jenkinsPath = new FilePath(wd, 'jenkins')
    }else{
        println 'Try use current workspace for work directory!'
        def cwd = SEED_JOB.getWorkspace()
        jenkinsPath = new FilePath(cwd, 'jenkins')
    }
}else{
    println 'Job DSL in normal job, use Jenkins API for running!'

    Build build = executor.currentExecutable
    ParametersAction parametersAction = build.getAction(ParametersAction)
    parametersAction.parameters.each { ParameterValue v ->
        println v
    }
    ParameterValue v = parametersAction.getParameter("ProjectPath")
    if(v != null){
        customizeProjectPath = v.getValue().toString()
    }

    if(customizeProjectPath?.trim()){
        println 'Try use parameter for work directory!'
        projectPath = v.getValue().toString()
        def wd = new FilePath(new File(projectPath))
        jenkinsPath = new FilePath(wd, 'jenkins')
    }else{
        println 'Try use current workspace for work directory!'
        def cwd = executor.getCurrentWorkspace().absolutize()
        jenkinsPath = new FilePath(cwd, 'jenkins')
    }
}

if(jenkinsPath.exists()) {
    files = jenkinsPath.list('*.jenkinsfile')
    if(files == null || files.size() == 0){
        println "Cant find any jenkinsfile in 'jenkins/' directory!"
        throw new Exception("Cant find any jenkinsfile!")
        return
    }
}

files.each { file ->
    def name = file.getBaseName()
    println "File ${name}"
    
    pipelineJob("${name}") {
        def strip = file.readToString()
        if(customizeProjectPath != null && strip.contains('\'ProjectPath\'')){
            println "Need replace 'ProjectPath' parameter!"
            strip = strip.replace(/'ProjectPath'/, "'NotUse_ProjectPath'")
            parameters {
                stringParam('ProjectPath', "${customizeProjectPath}")
            }
        }

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