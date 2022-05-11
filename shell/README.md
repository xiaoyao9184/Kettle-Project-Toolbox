# Introduction




## KPT_RUN_COMMAND

depend
- [KPT_EXPORT_ENVIRONMENT]() _if exist_

This script will run kettle command by environment variables start with `KPT_KETTLE_`

The following are common variables not all

- KPT_COMMAND 
- KPT_LOG_PATH 
- KPT_ENGINE_PATH 
- KPT_PROJECT_PATH 
- KPT_KETTLE_JOB 
- KPT_KETTLE_TRANS 
- KPT_KETTLE_FILE
- KETTLE_HOME
- KETTLE_REPOSITORY


Starting with `KETTLE_` are variables defined by kettle, like `KETTLE_HOME`.


Starting with `KPT_KETTLE_` for building command line options,
see [Use the Pan and Kitchen Command Line](https://help.hitachivantara.com/Documentation/Pentaho/7.0/0L0/0Y0/070).

If you need use, uppercase option name and append with `KPT_KETTLE_` prefix then set it to environment variable

> E.g use `user` option, just set the environment variable `KPT_KETTLE_USER` 

Special is `param` option, there can be multiple options, and the names can be customized.

You need to convert the param name as follows

- Replace a period `.` with a single underscore `_`.
- Replace a dash `-` with double underscores `__`.
- Replace an underscore `_` with triple underscores `___`.

> E.g use 'param' multiple options `-param:MASTER_HOST=192.168.1.3 -param:MASTER_PORT=8181`
> set multiple environment variables `KPT_KETTLE_PARAM_MASTER___HOST` and `KPT_KETTLE_PARAM_MASTER___PORT`

> E.g use 'param' case options `-param:ProfileName=test -param:Config_Main_Job_Path=test/`
> set case environment variables `KPT_KETTLE_PARAM_ProfileName` and `KPT_KETTLE_PARAM_Config_Main_Job_Path`

Starting with 'KPT_' for this script

| variable | value |
|:-----:|:-----:|
| KPT_COMMAND | pan/kitchen or other commands of kettle |
| KPT_LOG_PATH | full path for log, if kettle's log option is not set, redirect console output to this |
| KPT_ENGINE_PATH | a named 'data-integration' path |
| KPT_PROJECT_PATH | full path for kettle file repository |




## KPT_EXPORT_ENVIRONMENT

this script can automatically set variables start with `KPT_KETTLE_` and some `KETTLE_`,
If these variables are already set, it will no do anything.


#### KPT_COMMAND 

Determined by the file extension for run, `.kjb` is job using `kitchen` and `.ktr` is transformation using `pan`


#### KPT_KETTLE_JOB or KPT_KETTLE_TRANS or KPT_KETTLE_FILE

based on position parameter 1, caller script like [KPT_RUN_COMMAND]() will pass itself file name to this. 
So it is easy to renaming script [KPT_RUN_COMMAND]() to tell which transformation or job to run

The lookup position is relative, 
If you want to run job `A` in the current directory, 
copy script [KPT_RUN_COMMAND]() and [KPT_EXPORT_ENVIRONMENT]() to this directory,
then rename the script [KPT_RUN_COMMAND]() to `A`.
If you run a file in a deeper directory, when you don't want to move the script location.
Add the sub-directory name to script name and use `.` instead of path separators.

> E.g 
> [kpt.patch.PatchPDI.bat](../default/kpt.patch.PatchPDI.bat) is name changed by [KPT_RUN_COMMAND]()
> and it will run [/kpt/patch/PatchPDI.kjb](../default/kpt/patch/PatchPDI.kjb)


#### KPT_ENGINE_PATH 

Usually the kettle engine path of the kpt project is in same level with the project path.


#### KPT_PROJECT_PATH 

Usually the kettle project path just for find files by convert relative paths to absolute paths


#### KETTLE_HOME

Usually the kpt project include `.kettle/` folder inside, so the project path is `KETTLE_HOME`


#### KETTLE_REPOSITORY

Usually the kpt project repository name is same as kpt project path name.