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
        app_icon="A:/fanqie_big.ico",
        timeout=1,
    )
    system(f"{filesync_path} {batch_path}")
    notification.notify(
        title='USBbackup_END',
        app_name='USBbackup',
        message='U盘A备份更新结束……',
        app_icon="A:/fanqie_big.ico",
        timeout=1,
    )
    sys.exit(0)

elif choose == "-e":
    old_path = sys.argv[2]
    new_path = sys.argv[3]
    rename(new_path,f"{old_path}_temp")
    rename(old_path,new_path)
    rename(f"{old_path}_temp",old_path)
