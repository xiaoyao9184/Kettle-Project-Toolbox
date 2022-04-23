# ProjectRepository

The project repository is not a simple repository

**Note:** only support Kettle File Repository as ProjectRepository




# Different

ProjectRepository is Kettle File Repository, no different.

But, some conventions will make it easier to create a common unified project repository.


## feature

- Self contained KETTLE_HOME directory
- Profile
- Log


### Self contained KETTLE_HOME directory

A project folder should contain all the description information,
also included KETTLE_HOME, rather than using the user's KETTLE_HOME directory.

JAVA support "../" that the parent relative path, so that kettle.
It is happy to be, the relative goal is the **kettle engine directory** (data-integration/ directory).
We usually put the **kettle engine directory** together with the project repository.

Like this:
```
├─data-integration     kettle engine
├─default              kettle file repository
│  └─.kettle           KETTLE_HOME
├─tool
│  ├─Repository
│  ├─Path
│  └─Project
└─shell
```


### Profile

_Future realization..._

### Log

As a file repository based project, you should use a file hosting log.

Of course, the existing scheduling script will output the log to the project repository/log/ directory


# How to use

1. Oo tool folder.
2. Run INIT_PROJECT.bat/INIT_PROJECT.sh, enter a name of ProjectRepository after the prompt
3. Get the following directory.

```
├─.kettle
├─.pdi
├─log
└─.profile
    └─dev
```

4. Run RUN_SPOON.bat/RUN_SPOON.sh in project directory,
successful if you see the kettle welcome page, and already connected to ProjectRepository.
