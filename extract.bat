@echo off
setlocal enabledelayedexpansion

cd %~dp0

REM https://stackoverflow.com/a/31721353/5522348
for /f "delims== tokens=1,2" %%G in (.env) do set %%G=%%H

for %%t in (%*) do (
    %MHW_TEXT_CONVERTER_BY_JODO% "%%t"
)


for %%d in (%*) do (
    REM Output dir + "BC7_" + filename + ".dds"

    for %%f in ("%%~dpd*%%~nd.dds") do (
        set oldfilename="%%f"
    )


    rem set oldfilename="%%~dpdBC7_%%~nd.dds"
    set newfilename="%%~dpdBC7_%%~nd.png"
    set icondir=%%~dpdBC7_%%~nd\

    echo "Converting tex to dds"
    %NVIDIA_TEXTURE_TOOLS_EXPORTER% !oldfilename! --format bc7 --output !newfilename!
    magick convert !newfilename! -trim !newfilename! 

    set icon="n"

    if !icon!=="y" (
        REM Saving output to variable: https://stackoverflow.com/a/2340018/5522348
        REM cmd console command: magick identify -format "%[w]" "BC7_cmn_creature00_ID.png
        magick identify -format "%%[w]" !newfilename! > width.tmp
        magick identify -format "%%[h]" !newfilename! > height.tmp


        mkdir "!icondir!"

        set /p width=<width.tmp
        set /p height=<height.tmp

        echo !width!
        echo !height!
        
        explorer.exe !newfilename!

        set /p hor="# of icons horizontally: "
        set /p ver="# of icons vertically: "

        set /a iconwidth=!width! / !hor! + 1
        set /a iconheight=!height! / !ver! + 1

        echo !iconwidth!
        echo !iconheight!

        for /L %%v in (0,!iconheight!,!height!) do (
            echo "V: %%v"
            for /L %%h in (0,!iconwidth!,!width!) do (
                echo "H: %%h"
                magick convert -extract "!iconwidth!x!iconheight!+%%h+%%v" !newfilename! +profile "*" "!icondir!%%h-%%v.png"
            )
        )
    )
)
    
