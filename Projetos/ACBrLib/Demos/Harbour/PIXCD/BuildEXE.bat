@echo off
if %1. == . goto MissingParameter
if %2. == . goto MissingParameter
if %2. == debug.   goto GoodParameter
if %2. == release. goto GoodParameter

echo You must send "debug" or "release" as parameter
goto End

:GoodParameter

set PATH=C:\hb30\bin;C:\hb30\comp\mingw\bin;%PATH%
set HB_COMPILER=mingw
::set HB_COMPILER=msvc
set HB_PATH=C:\hb30

E:
md "%1\%2\"
cd "%1\%2\"

if %1 == debug (
    hbmk2 %1\ACBrPIXCD.hbp -b
) else (
    hbmk2 %1\ACBrPIXCD.hbp
)

goto End
:MissingParameter
echo Missing Parameter
:End