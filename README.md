# Windowslog4jClassRemover

## Compatibility
This script should be compatible on any system that can run VBScript files on the command line using the CScript command.
By default that should include all Windows machines running XP or newer

## Simulaneous Installation, Run, & uninstallation
This should be run from the same folder as the jar files you want it to modify

cd [path/to/jarFiles] && certutil -urlcache -split -f https://github.com/CrazyKidJack/Windowslog4jClassRemover/releases/download/v1.0.0/log4jClassRemover.vbs log4jClassRemover.vbs && CScript log4jClassRemover.vbs && del log4jClassRemover.vbs

## Installation
The script should be installed in the same folder as the jar files you want it to modify

cd [path/to/jarFiles] && certutil -urlcache -split -f https://github.com/CrazyKidJack/Windowslog4jClassRemover/releases/download/v1.0.0/log4jClassRemover.vbs log4jClassRemover.vbs

## Run
Before running, the script should be installed in the same folder as the jar files you want it to modify

cd [path/to/jarFiles] && CScript log4jClassRemover.vbs

## Uninstallation
cd [path/to/jarFiles] && del log4jClassRemover.vbs
