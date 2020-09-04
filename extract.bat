@echo off

cd %~dp0

REM https://stackoverflow.com/a/31721353/5522348
for /f "delims== tokens=1,2" %%G in (.env) do set %%G=%%H

for %%t in (%*) do (
    %MHW_TEXT_CONVERTER_BY_JODO% "%%t"
    
)


for %%d in (%*) do (
    REM Output dir + "BC7_" + filename + ".dds"
    echo "%%~dpdBC7_%%~nd.dds"
    %NVIDIA_TEXTURE_TOOLS_EXPORTER% "%%~dpdBC7_%%~nd.dds" --format bc7 --output "%%~dpdBC7_%%~nd.png"
)
    
    
