# Kettle-Scheduling-Scripts
关于几项工具的说明

LINK_PDI
	基本工具
	Windows中创建文件夹链接工具，用于对data-integration文件夹的链接进行创建替换删除操作

LINK_TOOL
	基本工具
	Windows中创建文件夹链接工具，用于对tool文件夹的链接进行创建替换删除操作

COPY_REP
	复制工具
	复制资源库，可复制资源库配置条目和资源库文件夹

COPY_REP_CFG
	复制工具
	复制资源库配置，可复制资源库配置条目到任意位置，可与原有的配置文件合并
	已经存在的同名配置自动增加“[Copy]”前缀

COPY_REP_PATH
	复制工具
	复制资源库文件夹，复制的是资源库配置条目指向的文件夹
	已经存在的路径自动增加“[Copy]”前缀

ZIP_DEPLOY_KETTLE
	部署工具
	生成kettle配置目录的zip部署文件
	对于资源库配置文件，使用CopyRepositoryPath作为子作业实现

ZIP_DEPLOY_FSREP
	部署工具
	生成文件资源库文件夹zip部署文件（不含log）

ZIP_DEPLOY_PATH
	部署工具
	生成文件夹zip部署文件（不含log，不含Kettle引擎目录）



关于几个文件夹的说明

FsRep/
	文件资源库相关转换模块
	包括读取，保存，复制合并等

Kettle/
	kettle文件夹相关转换模块
	包括读取文件，打印数据

Path/
	普通文件夹相关转换模块
	包括读取文件，打印数据
