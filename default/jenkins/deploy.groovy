import hudson.model.*

def executor = Executor.currentExecutor()
def customizeDeployPath = null
def customizeProjectPath = null
def deployPath = null
def projectPath = null
def projectName = null

if(executor == null){
    println 'Job DSL in pipeline job, use variables for running!'
    
    // Get proper standard output from bindings
    def configuration = new HashMap()
    def binding = getBinding()
    configuration.putAll(binding.getVariables())

    customizeDeployPath = configuration["DeployPath"] ?: null
    if(!customizeDeployPath?.trim()){
        customizeDeployPath = configuration["deployPath"] ?: null
    }

    customizeProjectPath = configuration["ProjectPath"] ?: null
    if(!customizeProjectPath?.trim()){
        customizeProjectPath = configuration["projectPath"] ?: null
    }

    projectName = configuration["ProjectName"] ?: null
    if(!projectName?.trim()){
        projectName = configuration["projectName"] ?: null
    }
}else{
    println 'Job DSL in normal job, use Jenkins API for running!'

    Build build = executor.currentExecutable
    ParametersAction parametersAction = build.getAction(ParametersAction)
    parametersAction.parameters.each { ParameterValue v ->
        println v
    }
    
    ParameterValue pvDeployPath = parametersAction.getParameter("DeployPath")
    if(pvDeployPath != null){
        customizeDeployPath = pvDeployPath.getValue().toString()
    }

    ParameterValue pvProjectPath = parametersAction.getParameter("ProjectPath")
    if(pvProjectPath != null){
        customizeProjectPath = pvProjectPath.getValue().toString()
    }
    
    ParameterValue pvProjectName = parametersAction.getParameter("ProjectName")
    if(pvProjectName != null){
        projectName = pvProjectName.getValue().toString()
    }
}

if(customizeProjectPath?.trim()){
    println 'Try use parameter for project directory!'
    projectPath = new File(customizeProjectPath)
}else{
    throw new Exception("Cant find any project directory!")
    return
}
if(customizeDeployPath?.trim()){
    println 'Try use parameter for deploy directory!'
    deployPath = new File(customizeDeployPath)
}else{
    throw new Exception("Cant find any deploy directory!")
    return
}


def regex = '\\[Deploy\\]' + projectName + '.*.zip'

// println regex
// deployPath.listFiles({d, f -> f ==~ regex } as FilenameFilter).sort{ it.name }.reverse().each { def f ->
//     println f.name
// }

def deployPackage = deployPath.listFiles({d, f -> f ==~ regex } as FilenameFilter).sort{ it.name }.reverse().first()

println 'Last deploy package is: ' + deployPackage.absolutePath

def ant = new AntBuilder()
ant.unzip(src:deployPackage.absolutePath,
            dest:projectPath.absolutePath,
            overwrite:"true")
            
println 'Deploy package done in: ' + projectPath.absolutePath
