@ECHO OFF
TITLE Windows Settings Backup Tool
SETLOCAL ENABLEDELAYEDEXPANSION
CD /d "%~dp0"

ECHO  -^> Starting backup...

IF EXIST "Backup\StartMenu" (

    ECHO  -^> Archiving old backup...

    IF EXIST "Backup.zip" (
        DEL /F /Q "Backup.zip"
    )

    PowerShell.exe -ExecutionPolicy Bypass -Command Compress-Archive -LiteralPath "Backup" -DestinationPath "Backup.zip" -Force >NUL 2>&1
)

IF NOT EXIST "Backup" (
    MKDIR "Backup"
)

CD "Backup"

ECHO  -^> Removing Old Backup...
IF EXIST "StartMenu" (
    RMDIR /S /Q "StartMenu"
)
IF EXIST "Taskbar" (
    RMDIR /S /Q "Taskbar"
)
IF EXIST "LibreWolf" (
    RMDIR /S /Q "LibreWolf"
)
IF EXIST "LenovoToolKit" (
    RMDIR /S /Q "LenovoToolKit"
)
IF EXIST "MSIAfterburner" (
    RMDIR /S /Q "MSIAfterburner"
)
IF EXIST "DefenderExcludeList" (
    RMDIR /S /Q "DefenderExcludeList"
)
IF EXIST "FirewallRules" (
    RMDIR /S /Q "FirewallRules"
)

ECHO  -^> Creating backup folder...
MKDIR "StartMenu"
MKDIR "Taskbar\TaskBar"
MKDIR "LibreWolf"
MKDIR "LenovoToolKit"
MKDIR "MSIAfterburner\Afterburner"
MKDIR "MSIAfterburner\RivaTunerStatisticsServer"
MKDIR "DefenderExcludeList"
MKDIR "FirewallRules"

ECHO  -^> Backing Up Start Menu
COPY /Y "%UserProfile%\AppData\Local\Packages\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\LocalState\start2.bin" "StartMenu\start2.bin" >NUL 2>&1

ECHO  -^> Backing Taskbar
XCOPY /S /Y "%AppData%\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar" "Taskbar\TaskBar" >NUL 2>&1
REG EXPORT "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Taskband" "Taskbar\Taskbar.reg" /y >NUL 2>&1

CALL :LIBREWOLF >NUL 2>&1
CALL :LLT >NUL 2>&1
CALL :AFTERBURNER >NUL 2>&1
CALL :DEFENDEREXCLUDELIST >NUL 2>&1
CALL :FIREWALL >NUL 2>&1



PAUSE
EXIT


:LIBREWOLF
@REM Backing LibreWolf
IF EXIST "%AppData%\LibreWolf" (
    ECHO  -^> Backing LibreWolf
    XCOPY /S /Y "%AppData%\librewolf" "LibreWolf"
)
EXIT /B

:LLT
@REM Backing LenovoToolKit
IF EXIST "%UserProfile%\AppData\Local\LenovoLegionToolkit" (
    ECHO  -^> Backing LenovoToolKit
    XCOPY /S /Y "%UserProfile%\AppData\Local\LenovoLegionToolkit" "LenovoToolKit"
)
EXIT /B

:AFTERBURNER
@REM Backing MSI Afterburner
IF EXIST "C:\Program Files (x86)\MSI Afterburner\Profiles" (
ECHO  -^> Backing MSI Afterburner
    XCOPY /S /Y "C:\Program Files (x86)\MSI Afterburner\Profiles" "MSIAfterburner\Afterburner"
)

@REM Backing Riva Tuner
IF EXIST "C:\Program Files (x86)\RivaTuner Statistics Server\Profiles" (
ECHO  -^> Backing Riva Tuner
    XCOPY /S /Y "C:\Program Files (x86)\RivaTuner Statistics Server\Profiles" "MSIAfterburner\RivaTunerStatisticsServer"
)
EXIT /B

:DEFENDEREXCLUDELIST
@REM Backing Defender Exclusion List
ECHO  -^> Backing Defender Exclusion List
PowerShell.exe -ExecutionPolicy Bypass -Command "Get-MpPreference | Select-Object -Property ExclusionPath -ExpandProperty ExclusionPath" > "DefenderExcludeList\DefenderExcludeList.txt"
EXIT /B

:FIREWALL
@REM Backing Firewall Rules
ECHO  -^> Backing Firewall Rules
netsh advfirewall export "FirewallRules\FirewallRules.wfw"
EXIT /B

