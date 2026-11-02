@echo off
setlocal
cd /d "%~dp0"

set CMAKE="C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin\cmake.exe"
if not exist %CMAKE% (
  echo CMake from Visual Studio 2022 was not found.
  exit /b 1
)

if not exist build\CMakeCache.txt (
  %CMAKE% -S . -B build -G "Visual Studio 17 2022" -A x64
  if errorlevel 1 exit /b 1
)

%CMAKE% --build build --config Release --target wolf3d
if errorlevel 1 exit /b 1

pushd build\Release
wolf3d.exe
set EXITCODE=%ERRORLEVEL%
popd
exit /b %EXITCODE%
