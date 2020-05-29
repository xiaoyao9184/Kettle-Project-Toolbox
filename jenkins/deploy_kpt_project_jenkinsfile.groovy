/**
 * Kettle-Project-Toolbox project deploy jenkins jobs job dsl
 *
 * Created by xiaoyao9184 on 2020/5/15.
 *
 * It will deploy jenkins jobs form project,
 * jobs directory is '.jenkins/'.
 * 
 * Parameter substitution
 * - NodeLabel: alway 'etl'
 * - ProjectPath: from jobDsl additionalParameters
 * 
 */
import hudson.model.*
import hudson.FilePath

def excludeNames = ['deploy_kpt_project','build_kpt_project','find_kpt_project']
def files = null
def projectPathOnUnix = null
def projectPathOnWin = null
def projectPath = null
def jenkinsPath = null
def executor = Executor.currentExecutor()

if(executor == null){
    println 'Job DSL in pipeline job, use variables for running!'
    
    // Get proper standard output from bindings
    def configuration = new HashMap()
    def binding = getBinding()
    configuration.putAll(binding.getVariables())

    projectPathOnUnix = configuration["ProjectPath_On_Unix"] ?: null
    projectPathOnWin = configuration["ProjectPath_On_Windows"] ?: null
    projectPath = configuration["ProjectPath"] ?: null
    if(!projectPath?.trim()){
        projectPath = configuration["projectPath"] ?: null
    }

    if(projectPath?.trim()){
        println 'Try use parameter for work directory!'
        def wd = new FilePath(new File(projectPath))
        jenkinsPath = new FilePath(wd, '.jenkins')
    }else{
        println 'Try use current workspace for work directory!'
        def cwd = SEED_JOB.getWorkspace()
        jenkinsPath = new FilePath(cwd, '.jenkins')
    }
}else{
    println 'Job DSL in normal job, use Jenkins API for running!'

    Build build = executor.currentExecutable
    ParametersAction parametersAction = build.getAction(ParametersAction)
    parametersAction.parameters.each { ParameterValue v ->
        println v
    }
    ParameterValue vOnUnix = parametersAction.getParameter("ProjectPath_On_Unix")
    projectPathOnUnix = (vOnUnix != null) ? vOnUnix.getValue().toString() : null
    ParameterValue vOnWin = parametersAction.getParameter("ProjectPath_On_Windows")
    projectPathOnWin = (vOnWin != null) ? vOnWin.getValue().toString() : null
    ParameterValue v = parametersAction.getParameter("ProjectPath")
    if(v != null){
        projectPath = v.getValue().toString()
    }

    if(projectPath?.trim()){
        println 'Try use parameter for work directory!'
        projectPath = v.getValue().toString()
        def wd = new FilePath(new File(projectPath))
        jenkinsPath = new FilePath(wd, '.jenkins')
    }else{
        println 'Try use current workspace for work directory!'
        def cwd = executor.getCurrentWorkspace().absolutize()
        jenkinsPath = new FilePath(cwd, '.jenkins')
    }
}

if(jenkinsPath.exists()) {
    files = jenkinsPath.list('*.jenkinsfile')
    if(files == null || files.size() == 0){
        println "Cant find any jenkinsfile in '.jenkins/' directory!"
        throw new Exception("Cant find any jenkinsfile!")
        return
    }
}

files.each { file ->
    def name = file.getBaseName()
    if(excludeNames.contains(name)){
        return
    }

    println "File ${name}"
    pipelineJob("${name}") {
        def strip = file.readToString()
        if(strip.contains('${KPT.NodeLabel}')){
            println "Need replace 'NodeLabel' parameter!"
            strip = strip.replace('${KPT.NodeLabel}', "etl")
            parameters {
                stringParam('NodeLabel', "etl")
            }
        }else if(strip.contains('\'NodeLabel\'')){
            println "Need disable 'NodeLabel' parameter!"
            strip = strip.replace(/'NodeLabel'/, "'NotUse_NodeLabel'")
            parameters {
                stringParam('NodeLabel', "etl")
            }
        }

        if(projectPath != null && strip.contains('${KPT.ProjectPath}')){
            println "Need replace 'ProjectPath' parameter!"
            strip = strip.replace('${KPT.ProjectPath}', "${projectPath}")
            parameters {
                stringParam('ProjectPath', "${projectPath}")
            }
        }else if(projectPath != null && strip.contains('\'ProjectPath\'')){
            println "Need disable 'ProjectPath' parameter!"
            strip = strip.replace(/'ProjectPath'/, "'NotUse_ProjectPath'")
            parameters {
                stringParam('ProjectPath', "${projectPath}")
            }
        }

        if(projectPath != null && strip.contains('${KPT.ProjectPath_On_Unix}')){
            println "Need replace 'ProjectPath_On_Unix' parameter!"
            strip = strip.replace('${KPT.ProjectPath_On_Unix}', "${projectPathOnUnix}")
            parameters {
                stringParam('ProjectPath_On_Unix', "${projectPathOnUnix}")
            }
        }else if(projectPath != null && strip.contains('\'ProjectPath_On_Unix\'')){
            println "Need disable 'ProjectPath_On_Unix' parameter!"
            strip = strip.replace(/'ProjectPath_On_Unix'/, "'NotUse_ProjectPath_On_Unix'")
            parameters {
                stringParam('ProjectPath_On_Unix', "${projectPathOnUnix}")
            }
        }

        if(projectPath != null && strip.contains('${KPT.ProjectPath_On_Windows}')){
            println "Need replace 'ProjectPath_On_Windows' parameter!"
            // https://issues.apache.org/jira/browse/GROOVY-2225
            def groovyWinPath = projectPathOnWin.replaceAll('\\\\','\\\\\\\\')
            strip = strip.replace('${KPT.ProjectPath_On_Windows}', "${groovyWinPath}")
            parameters {
                stringParam('ProjectPath_On_Windows', "${projectPathOnWin}")
            }
        }else if(projectPath != null && strip.contains('\'ProjectPath_On_Windows\'')){
            println "Need disable 'ProjectPath_On_Windows' parameter!"
            strip = strip.replace(/'ProjectPath_On_Windows'/, "'NotUse_ProjectPath_On_Windows'")
            parameters {
                stringParam('ProjectPath_On_Windows', "${projectPathOnWin}")
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