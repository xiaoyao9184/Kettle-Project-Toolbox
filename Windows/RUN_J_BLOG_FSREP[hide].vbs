nowpath = CreateObject("Scripting.FileSystemObject").GetFile(Wscript.ScriptFullName).ParentFolder.Path
nowpath = """" + nowpath  + "\RUN_J_BLOG_FSREP.BAT"""

Wscript.Echo "将在后台运行Kettle调度程序：" + nowpath

Set ws = CreateObject("Wscript.Shell") 
ws.run "cmd /c " + nowpath,vbhide