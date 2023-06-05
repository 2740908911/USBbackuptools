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