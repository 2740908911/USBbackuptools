# 外部存储自动数据同步工具USBbackuptools

开源一款自动化数据备份（同步）工具，将USB外部存储设备连接时进行自动备份，搭配FreeFileSync使用。本工具旨在解决备份盘的随时同步问题，同时确保数据的即时更新，以免在数据出现问题时即时找回。

<!--more-->

项目名称：外部存储自动数据同步工具USBbackuptools

完成时间：2023年5月10日

记录时间：2023年6月5日

项目作者：Fanqie

联系方式：2740908911@qq.com

> 注：本文及文中内容未经允许禁止私自转载或使用！

---

## 作者前言

数据毁了，不想多说，遂买了固态做备份盘，写了这个工具，以免再次丢数据，并且为了解决加了windows弹窗通知。。。

## 工具介绍

本工具需要搭配FreeFileSync使用，系统环境WINDOWS均可，用法简单：

1. 在电脑某盘解压文件夹，在备份盘解压相应文件夹；
2. 添加事件触发器；
3. 打开工具做备份配置；
4. 拔出USB设备，再插入USB设备，检查功能是否正确；

>  本工具配合备份工具FreeFileSync使用，并在压缩包中提供了一个便携版的FreeFileSync，无需安装即可使用；也可以直接使用FreeFileSync手动同步数据，使用方法可以参考CSDN；本工具无需网络环境。

> 正常情况下插入U盘时会弹窗提示，备份完成后同样弹窗提示；为了保障数据安全提高可恢复性，工具提供双备份文件夹，即一个当前备份目录，一个历史备份目录，每次更新备份会重写旧的备份文件；您也可以在backup文件夹内创建其他文件夹，如backup2023-6-6，来保存您的备份记录。

> 若对工具有自定义需求且有一定的阅读代码基础，可以通过修改BatchRun.ffs_batch和backup_lock.vbs文件实现，具体代码可以参考下文。

## 安装与配置

1. 将压缩包FreeFileSync.zip解压，放入外部存储设备**根目录**中

   ![1](http://img.imfanqie.top/program/USBbackuptools/1.png)

   ![2](http://img.imfanqie.top/program/USBbackuptools/2.png)

   在USB设备**根目录**创建backup文件夹以及new_backup和last_history文件夹（temp不用），见图片1：

   ![3](http://img.imfanqie.top/program/USBbackuptools/3.png)

   下载backup_lock.vbs文件，放在电脑任意位置即可

2. win+R打开运行，输入`compmgmt.msc`，打开计算机管理，选择系统工具》任务计划程序库：
   ![4](http://img.imfanqie.top/program/USBbackuptools/4.png)

   完成以下四项配置后保存关闭：
   ![5](http://img.imfanqie.top/program/USBbackuptools/5.png)

   ![6](http://img.imfanqie.top/program/USBbackuptools/6.png)

   ![7](http://img.imfanqie.top/program/USBbackuptools/7.png)

   ![8](F:\Desktop\8.png)

   **注意backup_lock.vbs设置路径**

3. 打开备份文件，设置同步文件夹，并保存，具体使用和其他操作可以百度搜：
   ![9](http://img.imfanqie.top/program/USBbackuptools/9.png)

   ![10](http://img.imfanqie.top/program/USBbackuptools/10.png)

   上图配置命令：`A:\FreeFileSync\USBbackuptools.exe -e A:\backup\last_history A:\backup\new_backup`

   保存的batch脚本文件命名：`BatchRun.ffs_batch`，与`USBbackuptools.exe`放在同一目录中

5. 正常情况下使用：

   * 插入U盘：

     ![11](http://img.imfanqie.top/program/USBbackuptools/11.png)

   * 拔出U盘：

     ![12](http://img.imfanqie.top/program/USBbackuptools/12.png)

   * 在拔出设备后请确认数据是否已经同步。
   * **注：如果图标消失不见或有修改图标需求，在外部存储设备根目录放入`fanqie_big.ico`，并隐藏即可，`fanqie_big.ico`可以在我的仓库中下载**

## 代码设计

* USBbackuptools.exe，通过python编译：

  ```python
  from plyer import notification
  from os import system, rename
  import sys
  
  choose = sys.argv[1]
  
  if choose == "-s":
      filesync_path = sys.argv[2]
      batch_path = sys.argv[3]
      notification.notify(
          title='USBbackup_START',
          app_name='USBbackup',
          message='U盘A正在更新对设定文件夹的备份',
          timeout=1,
      )
      system(f"{filesync_path} {batch_path}")
      notification.notify(
          title='USBbackup_END',
          app_name='USBbackup',
          message='U盘A备份更新结束……',
          timeout=1,
      )
      sys.exit(0)
  
  elif choose == "-e":
      old_path = sys.argv[2]
      new_path = sys.argv[3]
      rename(new_path,f"{old_path}_temp")
      rename(old_path,new_path)
      rename(f"{old_path}_temp",old_path)
  
  ```

* backup_lock.vbs：

  ```vbscript
  Set objShell = CreateObject("WScript.Shell")
  Set objFSO = CreateObject("Scripting.FileSystemObject")
  
  WScript.Sleep 2000
  
  ' 检查 U 盘 A 是否存在
  If objFSO.DriveExists("A:\") Then
      ' 禁止 U 盘 A 弹出
      objShell.Run "cmd /c echo. > A:\$leech$", 0, True
  
      ' 运行备份命令
      objShell.Run "cmd /c start /B """" ""A:\FreeFileSync\USBbackuptools.exe"" -s ""A:\FreeFileSync\FreeFileSyncPortable.exe"" ""A:\FreeFileSync\BatchRun.ffs_batch""", 0, True
  
      ' 解除禁止 U 盘 A 弹出
      objShell.Run "cmd /c del A:\$leech$", 0, True
  End If
  
  ' 持续监测 U 盘 A 是否存在
  Do Until Not objFSO.DriveExists("A:\")
      WScript.Sleep 3000
  Loop
  ```

## 其他

有问题请提交issus
