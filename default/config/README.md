# ConfigReader

Kettle can load configuration data into the kettle engine
by the `kettle.properties` file in `KETTLE_HOME`

But it is global, and Run-time static.


## Based on any (file) type of configuration data load into the kettle

Using the job/transformation to load the configuration data
will resolve the Run-time static problem.

Combined with the use of dynamic execute transformation,
you can do any logic to read the configuration data, like plug-ins system.

Here we prefabricate logics of read 3 type of file, and a generic reader job.

[ReadConfig.kjb](/ReadConfig.kjb) select the read logic according to the parameters.

3 type of file read logic
- [ReadLogical_xml.ktr](/ReadLogical_xml.ktr)
- [ReadLogical_ini.ktr](/ReadLogical_ini.kjb)
- [ReadLogical_properties.ktr](/ReadLogical_properties.kjb)

1 empty only print parameters not reading anything logic for test
- [ReadLogical_print.ktr](/ReadLogical_print.ktr)


## Use it

Run script [config.ReadConfig.bat](../config.ReadConfig.bat) it will use
[ReadLogical_xml.ktr](/ReadLogical_xml.ktr) to load [config.xml](../config.xml).

Because not specify any parameters, so it use the default read logic priority
[ReadLogical_xml.ktr](/ReadLogical_xml.ktr) to read current repository
[config.xml](../config.xml) file not KETTLE_HOME[/.kettle/config.xml](../.kettle/config.xml).

Read path precedence order:
1. customize
2. current repository
3. KETTLE_HOME

Read logical precedence order:
1. customize(need to customize the read path at the same time)
2. xml
3. ini
4. properties

The parameter `CfgPath` controls the read path,
parameter `CfgType` controls the read logical.

Parameters in different logic in the meaning of different,
But usually should be based on these parameters to determine the uniqueness.
- CfgPath
- CfgName
- CfgTag
- CfgType

*example* we want load KETTLE_HOME's `kettle.properties`,
just run [ReadConfig.kjb](/ReadConfig.kjb) use provide such parameters

- CfgPath:
- CfgName:kettle
- CfgTag:
- CfgType:properties




## Custom read logic transformation

1. Create a transformation
2. Add the following parameters
    - Parameters.Cfg.Path
    - Parameters.Cfg.Name
    - Parameters.Cfg.Tag
    - Parameters.Cfg.Type
3. Logical flow processing according to parameters, generate the `Config` variable
4. Save transformation in the `config` folder as `ReadLogical_{type}` name style.


**NOTE** `type` in name style is same concept with parameter `Parameters.Cfg.Type`

*example* [ReadLogical_ini.ktr](/ReadLogical_ini.ktr)

Is an INI file read logic, the full path of the file will be necessary, so these parameters are mapping to:

- Parameters.Cfg.Path *->* INI file folder
- Parameters.Cfg.Name *->* INI file name
- Parameters.Cfg.Type *->* INI file extension name
- Parameters.Cfg.Tag *->* INI content section

According to which you can easily read the contents of the variable into a variable.

Select this logic at run time, just set the parameter `CfgType` of [ReadConfig.kjb](/ReadConfig.kjb) to `ini`.



# Dynamic execute transformation with variable

Since Kettle develops dynamic conversions in the absence of variables,
Resulting in the inability to read the conversion, the inability to run the job,
You only need to create a conversion with the same name as the variable string.


## E.g

See [ReadConfig.kjb](../ReadConfig.kjb)

You can find Item **ReadConfig: Config.Transformation**

This item will use the variable:

```java
${Config.Transformation}
```

and you can find
[${Config.Transformation}.kjb](../${Config.Transformation}.kjb)
 in this directory too.
