@echo off
chcp 65001
REM --------------------------------------------------------------------------------
REM Configuration:
REM   Set a Quick Save and Quick Load hotkey - http://www.pygame.org/docs/ref/key.html
REM --------------------------------------------------------------------------------
set "quicksavekey=K_F5"
set "quickloadkey=K_F9"
REM --------------------------------------------------------------------------------
REM !! END CONFIG !!
REM --------------------------------------------------------------------------------
REM The following variables are Base64 encoded strings for unrpyc and rpatool
REM Due to batch limitations on variable lengths, they need to be split into
REM multiple variables, and joined later using powershell.
REM --------------------------------------------------------------------------------
REM unrpyc by CensoredUsername
REM   https://github.com/CensoredUsername/unrpyc
REM Edited to remove multiprocessing and adjust output spacing 44febb0 2019-10-07T07:06:47.000Z
REM   https://github.com/F95Sam/unrpyc
REM --------------------------------------------------------------------------------
REM !! DO NOT EDIT BELOW THIS LINE !!
REM --------------------------------------------------------------------------------
set "version=dev"
title UnRen.bat - %version%
:init
REM --------------------------------------------------------------------------------
REM Splash screen
REM --------------------------------------------------------------------------------
cls
echo.
echo     __  __      ____               __          __
echo    / / / /___  / __ \___  ____    / /_  ____ _/ /_
echo   / / / / __ \/ /_/ / _ \/ __ \  / __ \/ __ ^`/ __/
echo  / /_/ / / / / _^, _/  __/ / / / / /_/ / /_/ / /_
echo  \____/_/ /_/_/ ^|_^|\___/_/ /_(_)_.___/\__^,_/\__/ - %version%
echo   Sam @ www.f95zone.to
echo.
echo  ----------------------------------------------------
echo.
REM --------------------------------------------------------------------------------
REM We need powershell for later, make sure it exists
REM --------------------------------------------------------------------------------
if not exist "%SystemRoot%\system32\WindowsPowerShell\v1.0\powershell.exe" (
	echo    ! Error: Powershell is required, unable to continue.
	echo             This is included in Windows 7, 8, 10. XP/Vista users can
	echo             download it here: http://support.microsoft.com/kb/968929
	echo.
	pause>nul|set/p=.            Press any key to exit...
	exit
)

setlocal
for /f "tokens=4-5 delims=. " %%i in ('ver') do set version=%%i.%%j

REM --------------------------------------------------------------------------------
REM Set our paths, and make sure we can find python exe
REM --------------------------------------------------------------------------------

if exist "lib\windows-x86_64\python.exe" (
	if not "%PROCESSOR_ARCHITECTURE%"=="x86" (
		set "pythondir=%cd%\lib\windows-x86_64\"
	)
	if exist "lib\windows-i686\python.exe" (
		set "pythondir=%cd%\lib\windows-i686\"
	)
) else if exist "lib\windows-i686\python.exe" (
	set "pythondir=%cd%\lib\windows-i686\"
)
if exist "lib\py2-windows-x86_64\python.exe" (
	if not "%PROCESSOR_ARCHITECTURE%"=="x86" (
		set "pythondir=%cd%\lib\py2-windows-x86_64\"
    )
	if exist "lib\py2-windows-i686\python.exe" (
		set "pythondir=%cd%\lib\py2-windows-i686\"
	)
) else if exist "lib\py2-windows-i686\python.exe" (
	set "pythondir=%cd%\lib\py2-windows-i686\"
)
if exist "lib\py3-windows-x86_64\python.exe" (
	if not "%PROCESSOR_ARCHITECTURE%"=="x86" (
		set "pythondir=%cd%\lib\py3-windows-x86_64\"
    )
	if exist "lib\py3-windows-i686\python.exe" (
		set "pythondir=%cd%\lib\py3-windows-i686\"
	)
) else if exist "lib\py3-windows-i686\python.exe" (
	set "pythondir=%cd%\lib\py3-windows-i686\"
)
if not exist "%pythondir%" (
	echo    ! Error: Cannot locate python directory, unable to continue.
	echo             Are you sure we're in the game's root directory?
	echo.
	pause>nul|set/p=.            Press any key to exit...
	exit
)

if exist "game" if exist "renpy" (
	set "renpydir=%cd%\renpy\"
	set "gamedir=%cd%\game\"
) else (
	echo    ! Error: Cannot locate game directory, unable to continue.
	echo             Are you sure we're in the game's root directory?
	echo.
	pause>nul|set/p=.            Press any key to exit...
	exit
)
set "PYTHONHOME=%pythondir%"
set "currentdir=%cd%"
if exist "lib\pythonlib2.7" (
	set "PYTHONPATH=%cd%\lib\pythonlib2.7"
) else if exist "lib\python2.7" (
	set "PYTHONPATH=%cd%\lib\python2.7"
) else if exist "lib\python3.9" (
	set "PYTHONPATH=%cd%\lib\python3.9"
)

:menu
REM --------------------------------------------------------------------------------
REM Menu selection
REM --------------------------------------------------------------------------------
set exitoption=
echo   Available Options:
echo     1) Extract RPA packages
echo     2) Decompile rpyc files
echo     3) Enable Console and Developer Menu
echo     4) Enable Quick Save and Quick Load
echo     5) Force enable skipping of unseen content
echo     6) Force enable rollback (scroll wheel)
echo     7) Deobfuscate Decompile rpyc files
echo     8) Extract and Decompile
echo     9) All of the above
echo.
set /p option=.  Enter a number:
echo.
echo  ----------------------------------------------------
echo.
if "%option%"=="1" goto extract
if "%option%"=="2" goto decompile
if "%option%"=="3" goto console
if "%option%"=="4" goto quick
if "%option%"=="5" goto skip
if "%option%"=="6" goto rollback
if "%option%"=="7" goto decompile
if "%option%"=="8" goto extract
if "%option%"=="9" goto extract
goto init

:extract
REM --------------------------------------------------------------------------------
REM Write _rpatool.py from our base64 strings
REM --------------------------------------------------------------------------------
set "rpatool=%cd%\rpatool.py"

REM --------------------------------------------------------------------------------
REM Unpack RPA
REM --------------------------------------------------------------------------------
echo   Searching for RPA packages
cd %gamedir%
"%pythondir%python.exe" -O "%rpatool%" "%cd%
echo.
cd %currentdir%
if not "%option%" == "9" (
	if not "%option%" == "8" (
		goto finish
	)
)

:decompile
REM --------------------------------------------------------------------------------
REM Write to temporary file first, then convert. Needed due to binary file
REM --------------------------------------------------------------------------------

set "unrpycpy=%cd%\unrpyc.py"

REM --------------------------------------------------------------------------------
REM Decompile rpyc files
REM --------------------------------------------------------------------------------
echo   Searching for rpyc files...

if exist "%pythondir%Lib" (
	if "%option%" == "2" (
		echo    + Searching for rpyc files in %gamedir%
		"%pythondir%python.exe" -O "%unrpycpy%" -c --init-offset "%gamedir%
	)
	if "%option%" == "9" (
		echo    + Searching for rpyc files in %gamedir%
		"%pythondir%python.exe" -O "%unrpycpy%" -c --init-offset "%gamedir%
	)
	if "%option%" == "8" (
		echo    + Searching for rpyc files in %gamedir%
		"%pythondir%python.exe" -O "%unrpycpy%" -c --init-offset "%gamedir%
	)
	if "%option%" == "7" (
		echo    + Searching for rpyc files in %gamedir%
		"%pythondir%python.exe" -O "%unrpycpy%" -c --init-offset --try-harder "%gamedir%
	)
) else (
	if "%option%" == "2" (
		echo    + Searching for rpyc files in %gamedir%
		"%pythondir%python.exe" "%unrpycpy%" -c --init-offset "%gamedir%
	)
	if "%option%" == "9" (
		echo    + Searching for rpyc files in %gamedir%
		"%pythondir%python.exe" "%unrpycpy%" -c --init-offset "%gamedir%
	)
	if "%option%" == "8" (
		echo    + Searching for rpyc files in %gamedir%
		"%pythondir%python.exe" "%unrpycpy%" -c --init-offset "%gamedir%
	)
	if "%option%" == "7" (
		echo    + Searching for rpyc files in %gamedir%
		"%pythondir%python.exe" "%unrpycpy%" -c --init-offset --try-harder "%gamedir%
	)
)
echo.

echo.
cd %currentdir%
if not "%option%" == "9" (
	goto finish
)

:console
REM --------------------------------------------------------------------------------
REM Drop our console/dev mode enabler into the game folder
REM --------------------------------------------------------------------------------
echo   Creating Developer/Console file...
set "consolefile=%gamedir%unren-dev.rpy"
if exist "%consolefile%" (
	del "%consolefile%"
)

echo init 999 python:>> "%consolefile%"
echo   config.developer = True>> "%consolefile%"
echo   config.console = True>> "%consolefile%"

echo    + Console: SHIFT+O
echo    + Dev Menu: SHIFT+D
echo.

:consoleend
if not "%option%" == "9" (
	goto finish
)

:quick
REM --------------------------------------------------------------------------------
REM Drop our Quick Save/Load file into the game folder
REM --------------------------------------------------------------------------------
echo   Creating Quick Save/Quick Load file...
set "quickfile=%gamedir%unren-quick.rpy"
if exist "%quickfile%" (
	del "%quickfile%"
)

echo init 999 python:>> "%quickfile%"
echo   try:>> "%quickfile%"
echo     config.underlay[0].keymap['quickSave'] = QuickSave()>> "%quickfile%"
echo     config.keymap['quickSave'] = '%quicksavekey%'>> "%quickfile%"
echo     config.underlay[0].keymap['quickLoad'] = QuickLoad()>> "%quickfile%"
echo     config.keymap['quickLoad'] = '%quickloadkey%'>> "%quickfile%"
echo   except:>> "%quickfile%"
echo     pass>> "%quickfile%"

echo    Default hotkeys:
echo    + Quick Save: F5
echo    + Quick Load: F9
echo.

if not "%option%" == "9" (
	goto finish
)

:skip
REM --------------------------------------------------------------------------------
REM Drop our skip file into the game folder
REM --------------------------------------------------------------------------------
echo   Creating skip file...
set "skipfile=%gamedir%unren-skip.rpy"
if exist "%skipfile%" (
	del "%skipfile%"
)

echo init 999 python:>> "%skipfile%"
echo   _preferences.skip_unseen = True>> "%skipfile%"
echo   renpy.game.preferences.skip_unseen = True>> "%skipfile%"
echo   renpy.config.allow_skipping = True>> "%skipfile%"
echo   renpy.config.fast_skipping = True>> "%skipfile%"

echo    + You can now skip all text using TAB and CTRL keys
echo.

if not "%option%" == "9" (
	goto finish
)

:rollback
REM --------------------------------------------------------------------------------
REM Drop our rollback file into the game folder
REM --------------------------------------------------------------------------------
echo   Creating rollback file...
set "rollbackfile=%gamedir%unren-rollback.rpy"
if exist "%rollbackfile%" (
	del "%rollbackfile%"
)

echo init 999 python:>> "%rollbackfile%"
echo   renpy.config.rollback_enabled = True>> "%rollbackfile%"
echo   renpy.config.hard_rollback_limit = 256>> "%rollbackfile%"
echo   renpy.config.rollback_length = 256>> "%rollbackfile%"
echo   def unren_noblock( *args, **kwargs ):>> "%rollbackfile%"
echo     return>> "%rollbackfile%"
echo   renpy.block_rollback = unren_noblock>> "%rollbackfile%"
echo   try:>> "%rollbackfile%"
echo     config.keymap['rollback'] = [ 'K_PAGEUP', 'repeat_K_PAGEUP', 'K_AC_BACK', 'mousedown_4' ]>> "%rollbackfile%"
echo   except:>> "%rollbackfile%"
echo     pass>> "%rollbackfile%"

echo    + You can now rollback using the scrollwheel
echo.

if not "%option%" == "9" (
	goto finish
)

:finish
REM --------------------------------------------------------------------------------
REM We are done
REM --------------------------------------------------------------------------------
echo  ----------------------------------------------------
echo.
echo    Finished!
echo.
echo    Enter "1" to go back to the menu, or any other
set /p exitoption=.   key to exit:
echo.
echo  ----------------------------------------------------
echo.
if "%exitoption%"=="1" goto menu
exit
