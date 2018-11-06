# Kettle项目工具箱

[English](README.md)

汇聚了Kettle项目常用的工具。
包括运行脚本，部署脚本，资源库模板。

一般来说，我们需要在后台使用PDI，这次它不会运行Spoon，而是运行Pan和Kitchen，
而对于复杂的ETL，一组通用的调度脚本可以简化开发。

这里我提供了一套已在实际项目中使用的工具脚本。

当然，现在只有Windows的Batch脚本。



# 兼容性


| 版本 | 支持度 | 原因 |
|:-----:|:-----:|:-----:|
| pdi-ce-7.0.0.0-25 | 支持 | 基于此版本开发 |
| pdi-ce-7.1.0.0-12 | 支持 | 测试过 default 资源库中的 flow 目录 |
| pdi-ce-8.0.0.0-28 | 支持 | 测试过 default 资源库中的 flow 目录 |
| pdi-ce-8.1.0.0-365 | 不支持 | 因变量问题造成失败 |

## 兼容性测试日志

### pdi-ce-8.1.0.0-365

使用步骤 `Set Variables` 或  `Modified Java Script Value` 设置变量为 **valid in the root job** 失败，
从其他的转换中无法读取变量,
我猜测变量不能像以前一样不声明就可使用，可能需要声明称参数，
尤其是在 `Transformation (job entry)` 作业项中，
可能无法使用混合变量与字符串常量一起使用，或者因为下面的原因。

### pdi-ce-7.1.0.0-12

由于7.1变更了相对资源库选择窗口变更，比如作业项：Job (Job Entry)、Transformation (Job Entry)，
转换步骤：Simple Mapping、Mapping等都省略了原来的路径填写框，合并为一个文本框填写路径+名称，
但是这个文本框仍然是两个属性，会根据最后一个‘/’分割为路径+名称，与7.0不同的是名称不支持填写路径。

但是这个可以被支持！


# 与 Jenkins 配合运行

所有脚本都可运行在Jenkins中。
必须设置 JAVA_HOME 环境变量，
否则 kitchen 和 pan 将返回错误的退出代码，造成jenkins错误。



# 教程

[快速开始](../../wiki/快速开始)

_这里是我写的一些Kettle教程，维护在Google Doc上，应对基本的低耦合项目还是没问题的。_

[ETL工具Kettle使用教程](https://drive.google.com/folderview?id=0B3tzMIqntqjFfnduVXB5TU9EbWFhejRLRnhkMkNwRVFWbXIwT3dtQWs0d2xWSnZtWkwzdkU&usp=sharing)
