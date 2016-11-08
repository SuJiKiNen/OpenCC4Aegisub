@echo off
for /f "delims=." %%i in ('dir /b "*.txt"') do (
   opencc_dict -i %%i.txt -o %%i.ocd -f text -t ocd
)
pause