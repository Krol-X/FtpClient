@echo off
set /p x=cmdname? 
set x=%x%.lua
echo return {> %x%
echo   help = [[...]];>> %x%
echo   main = function(args)>> %x%
echo   end;>> %x%
echo }>> %x%