@echo off
rem change to the directory where the script itself; this is required when running as an administrator
cd /d "%~dp0"

rem check if 64-bit OS, which shouldn't be
if exist "%SYSTEMROOT%\SysWOW64" ( goto JAVA_ARCH )

rem check if java is installed
java -help 2> nul
if not %errorlevel% equ 0 ( goto JAVA_MISSING )

rem check the path of java executable if exist and configured
set JAVA_CMD="%JAVA_HOME%\bin\java.exe"
if not %errorlevel% equ 0 ( goto JAVA_MISSING )

rem Use -Xmx768m for Windows XP, -Xmx1024m for all other Windows versions
ver | findstr "5\.1\." 2> nul
if %errorlevel% equ 0 ( set MAX_MEM_SIZE=768m ) else ( set MAX_MEM_SIZE=1024m )

java -version
echo JAVA_HOME Path: %JAVA_HOME%

echo Running JPCSP 32-bit...
%JAVA_CMD%^
    -Xmx%MAX_MEM_SIZE% -Xss2m -XX:ReservedCodeCacheSize=64m^
    -Djava.library.path=lib/windows-x86;lib/jinput-2.0.9-natives-all^
    -Dorg.lwjgl.system.allocator=system^
    -classpath "bin/jpcsp.jar;lib/lwjgl-3.2.3/lwjgl.jar;lib/lwjgl-3.2.3/lwjgl-openal.jar;lib/lwjgl-3.2.3/lwjgl-opengl.jar;lib/lwjgl-3.2.3/lwjgl-jawt.jar;lib/lwjgl-3.2.3/lwjgl-natives-windows-x86.jar;lib/lwjgl-3.2.3/lwjgl-openal-natives-windows-x86.jar;lib/lwjgl-3.2.3/lwjgl-opengl-natives-windows-x86.jar;lib/lwjgl-3.2.3/lwjgl-glfw.jar;lib/lwjgl-3.2.3/lwjgl-glfw-natives-windows-x86.jar"^
    jpcsp.MainGUI %*
goto END

:JAVA_MISSING
echo The required version of Java Runtime Environment(JRE) has not been installed or isn't recognized.
echo Go to https://adoptium.net/temurin/releases/ to install the 32-bit(x86) JRE.
echo NOTE:
echo   If you already installed the JRE then you need to set up the JAVA_HOME variable
echo   and add to the PATH with \bin like this: %%JAVA_HOME%%\bin
goto END

:JAVA_ARCH
echo Unable to properly run a 32-bit JPCSP from a 64-bit JRE on a 64-bit system 
echo because the 32-bit application needs a build from 32-bit libraries.
goto END

:END
pause