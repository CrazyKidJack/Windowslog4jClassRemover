# Windowslog4jClassRemover

## !!!IMPORTANT!!!
This script is TEMPORARY stop gap... it is NOT a remediation.
The log4j problems are an area of active research and guidance on remediation updates nearly by the minute.
Consult the interwebs for how you *should* fix this

## Description
* Searches installation directory for log4j-core jars
* unzips them
* moves JndiLookup.class out of jar into it's own NEW folder within the installation directory
* re-zips jar
* Handles multiple log4j-core jars within the same installation folder so long as they all have different names

## Compatibility
This script should be compatible on any system that can run VBScript files on the command line using the CScript command.
By default that should include all Windows machines running XP or newer

## Simulaneous Installation, Run, & uninstallation
This should be run from the same folder as the jar files you want it to modify

```cd "[path/to/jarFiles]" && certutil -urlcache -split -f https://github.com/CrazyKidJack/Windowslog4jClassRemover/releases/download/v1.0.0/log4jClassRemover.vbs log4jClassRemover.vbs && CScript log4jClassRemover.vbs && del log4jClassRemover.vbs```

## Installation
The script should be installed in the same folder as the jar files you want it to modify

```cd "[path/to/jarFiles]" && certutil -urlcache -split -f https://github.com/CrazyKidJack/Windowslog4jClassRemover/releases/download/v1.0.0/log4jClassRemover.vbs log4jClassRemover.vbs```

## Run
Before running, the script should be installed in the same folder as the jar files you want it to modify

```cd "[path/to/jarFiles]" && CScript log4jClassRemover.vbs```

## Uninstallation
```cd "[path/to/jarFiles]" && del log4jClassRemover.vbs```
