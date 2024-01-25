rem 参考自https://blog.csdn.net/qq_29864051/article/details/132174208

rem 纯净输出
@echo off
rem 设置utf-8可以正常显示中文
chcp 65001 > nul

rem 获取当前日期和时间，并将其格式为 yyyy-MM-dd-HH_mm_ss
for /f "usebackq tokens=1,2 delims==" %%G in (`wmic OS Get LocalDateTime /VALUE`) do if '.%%G.'=='.LocalDateTime.' set datetime=%%H
set "datetime=%datetime:~0,4%-%datetime:~4,2%-%datetime:~6,2%-%datetime:~8,2%_%datetime:~10,2%_%datetime:~12,2%"
set "datetime=%datetime:.=-%"
rem echo %datetime%

rem PalServer存档文件夹
set "sourceFolder=D:\Apps\Steam\steamapps\common\PalServer\Pal\Saved"
rem 压缩后的文件
set "destinationZip=D:\PalServer-backup\Saved-bk%datetime%.zip"
rem 备份的位置
set "destinationCopyTo=Y:\share\server_backups\PalServer-backup"
rem 本脚本的日志输出位置 >> %backuperLogFile%
set "backuperLogFile=D:\PalServer-backup\backup.log"

rem 打印设置信息
echo ================================================================== >> %backuperLogFile%
echo 备份执行时间 %datetime% >> %backuperLogFile%
echo 当前设置为： >> %backuperLogFile%
echo 存档目录：%sourceFolder% >> %backuperLogFile%
echo 备份保存为以下文件：%destinationZip% >> %backuperLogFile%
echo 复制到远程目录：%destinationCopyTo% >> %backuperLogFile%
echo. >> %backuperLogFile%

echo 执行7-Zip压缩 %sourceFolder% 到 %destinationZip% 文件 ... >> %backuperLogFile%
"C:\Program Files\7-Zip\7z.exe" a -tzip "%destinationZip%" "%sourceFolder%" >> %backuperLogFile%
echo 压缩完成 >> %backuperLogFile%
echo. >> %backuperLogFile%

echo 复制 %destinationZip% 到 %destinationCopyTo% ... >> %backuperLogFile%
copy "%destinationZip%" "%destinationCopyTo%" >> %backuperLogFile%
echo 复制完成 >> %backuperLogFile%
echo. >> %backuperLogFile%

rem 统计备份文件数量
for %%F in ("%destinationCopyTo%\*") do (
    set /a fileCountDestCopy+=1
)
echo 当前，远程目录共有 %fileCountDestCopy% 份备份 >> %backuperLogFile%

echo ================================================================== >> %backuperLogFile%
echo. >> %backuperLogFile%
