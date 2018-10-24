# Kettle-Project-Toolbox

[Chinese](README_ZH.md)

The toolbox commonly used in the kettle project are gathered.
This includes running scripts, deployment scripts, and repository templates.

In general, we need to use in the background PDI, this time it will not run Spoon, but run Pan and Kitchen, and for complex ETL, a common set of scheduling script can simplify development.

Here I offer a set of toolbox script has been used in the actual project.

Of course, now only Batch script for Windows.



# Compatibility


| Version | Supported | Why |
|:-----:|:-----:|:-----:|
| pdi-ce-7.0.0.0-25 | Yes | Develop on this |
| pdi-ce-7.1.0.0-12 | Yes | Test default flow directory |
| pdi-ce-8.0.0.0-28 | Yes | Test default flow directory |
| pdi-ce-8.1.0.0-365 | No | Some variables fail |

## compatibility test log

### pdi-ce-8.1.0.0-365

Set variable with **valid in the root job** in steps `Set Variables` and `Modified Java Script Value` fail,
cant read it form other transformation,
i think variable must replace by parameter,
and especially at `Transformation (job entry)`,
it cant use static characters mixed with variables.



# Use with jenkins

All scripts can run on jenkins
The JAVA_HOME environment variable must be set.
Otherwise kitchen and pan will return the error exit code, and jenkins will error.
