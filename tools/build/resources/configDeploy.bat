@echo off
setLocal

rem Get paths into variables
rem Batpath gets the path to this bat file.
set batpath=%~dp0

REM Determine the Environment Name.
set TARGET=%1

IF "%TARGET:~0,9%"=="WCMS-Prod" (
	set TARGET=Prod
) ELSE IF "%TARGET:~0,9%"=="WCMS-Colo" (
	set TARGET=Colo
) ELSE IF "%TARGET:~0,10%"=="WCMS-Stage" (
	set TARGET=Stage
) ELSE IF "%TARGET:~0,13%"=="WCMS-Training" (
	set TARGET=Training
) ELSE IF "%TARGET:~0,7%"=="WCMS-QA" (
	set TARGET=QA
) ELSE IF "%TARGET:~0,7%"=="WCMS-DT" (
	set TARGET=DT
) ELSE IF "%TARGET:~0,9%"=="WCMS-Blue" (
	set TARGET=BLUE
) ELSE IF "%TARGET:~0,8%"=="WCMS-Red" (
	set TARGET=RED
) ELSE IF "%TARGET:~0,9%"=="WCMS-Pink" (
	set TARGET=PINK
) ELSE (
	ECHO The Computer '%TARGET%', is not a configured build environment.  Exiting...
	GOTO :EOF
)

powershell -ExecutionPolicy RemoteSigned %batpath%configDeploy.ps1 -source %batpath% -env %TARGET%
