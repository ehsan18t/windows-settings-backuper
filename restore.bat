@ECHO OFF
TITLE Windows Settings Restore Tool
SETLOCAL ENABLEDELAYEDEXPANSION
CD /d "%~dp0\Backup"

ECHO  -^> Starting restore...

IF EXIST "StartMenu" (
    ECHO  -^> Restoring Start Menu
    COPY /Y "StartMenu\start2.bin" "%UserProfile%\AppData\Local\Packages\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\LocalState\start2.bin" >NUL 2>&1
)

IF EXIST "Taskbar" (
    ECHO  -^> Restoring Taskbar
    XCOPY /S /Y "Taskbar\TaskBar" "%AppData%\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar" >NUL 2>&1
    REGEDIT /S "Taskbar\Taskbar.reg" /y >NUL 2>&1
)

IF EXIST "LibreWolf" (
    ECHO  -^> Restoring LibreWolf
    CALL :LIBREWOLF >NUL 2>&1
)
IF EXIST "LenovoToolKit" (
    ECHO  -^> Restoring LenovoToolKit
    CALL :LLT >NUL 2>&1
)
IF EXIST "MSIAfterburner" (
    ECHO  -^> Restoring MSI Afterburner ^& Riva Tuner
    CALL :AFTERBURNER >NUL 2>&1
)
IF EXIST "DefenderExcludeList" (
    ECHO  -^> Restoring Defender Exclusion List
    CALL :DEFENDEREXCLUDELIST >NUL 2>&1
)
IF EXIST "FirewallRules" (
ECHO  -^> Restoring Firewall Rules
    CALL :FIREWALL >NUL 2>&1
)


PAUSE
EXIT


:LIBREWOLF
@REM Restoring LibreWolf
IF EXIST "%AppData%\LibreWolf" (
    XCOPY /S /Y "LibreWolf" "%AppData%\librewolf"
)
EXIT /B

:LLT
@REM Restoring LenovoToolKit
IF EXIST "%UserProfile%\AppData\Local\LenovoLegionToolkit" (
    XCOPY /S /Y "LenovoToolKit" "%UserProfile%\AppData\Local\LenovoLegionToolkit"
)
EXIT /B

:AFTERBURNER
@REM Restoring MSI Afterburner
IF EXIST "C:\Program Files (x86)\MSI Afterburner\Profiles" (
    XCOPY /S /Y "MSIAfterburner\Afterburner" "C:\Program Files (x86)\MSI Afterburner\Profiles"
)

@REM Restoring Riva Tuner
IF EXIST "C:\Program Files (x86)\RivaTuner Statistics Server\Profiles" (
    XCOPY /S /Y "MSIAfterburner\RivaTunerStatisticsServer" "C:\Program Files (x86)\RivaTuner Statistics Server\Profiles"
)
EXIT /B

:DEFENDEREXCLUDELIST
@REM Restoring Defender Exclusion List

@REM Disable Services
SET "excludeList=DefenderExcludeList\DefenderExcludeList.txt"

FOR /F "usebackq tokens=*" %%A IN ("%excludeList%") DO (
    SET "line=%%A"
    IF NOT "!line:~0,1!" == "#" (
        PowerShell -ExecutionPolicy Bypass -Command Add-MpPreference -ExclusionPath "%%A"
	)
)
EXIT /B

:FIREWALL
@REM Restoring Firewall Rules
netsh advfirewall import "FirewallRules\FirewallRules.wfw"
EXIT /B

