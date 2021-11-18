# Introduction


### RUN_REPOSITORY_JOB_OR_TRANSFORMATION

depend
- SET_ENVIRONMENT _maybe_
- SET_PARAM _maybe_

this batch can automatically find job or transformation
in file repositorie
based on the same file name of this script, or subdirectories.

**NOTE** find subdirectories need to use `.` to replace the path delimiter `\`.


_example:_
[config.ReadConfig.bat](../default/config.ReadConfig.bat) script
in repositorie [default](../default)

This script will use the `kitchen` command to run the
[ReadConfig.kjb](../default/config/ReadConfig.kjb) job
in repositorie path `config/`


At the same time, the script will check whether the `.SET_PARAM.bat` file exist
who use **this** script name as name prefix.

_example:_
[config.ReadConfig.bat](../default/config.ReadConfig.bat) script
in repositorie [default](../default)

This script will check `config.ReadConfig.SET_PARAM.bat` exist, and run it.




### RUN_SPOON

depend
- SET_ENVIRONMENT _maybe_

Run the kettle spoon and automatically connects to the current [project repository](../tool/Project/ProjectRepository.md)




### SET_ENVIRONMENT

This script checks the current directory for the following files or folders to determine whether the current directory is the file repository.

- repository.log
- .meta/
- \*.kdb
- config.xml

If exist, it will set current folder name to `KETTLE_REPOSITORY`

If the `.kettle` folder exists in the current folder, the current directory is considered `KETTLE_HOME`, the `KETTLE_HOME`
will be set.




### SET_PARAM

This script is used to combine user input KEYs and VALUEs into kettle command line parameters, like this:

` "-param:key1=value1" "-param:key2=value2"`
