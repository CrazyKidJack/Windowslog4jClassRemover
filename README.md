# Windowslog4jClassRemover

## !!!IMPORTANT!!!
This script is TEMPORARY stop gap... it is NOT a remediation.
The log4j problems are an area of active research and guidance on remediation updates nearly by the minute.
Consult the interwebs for how you *should* fix this

## Description
* Searches installation directory for log4j-core jars
* unzips them
* moves JndiLookup.class out of jar into it's own NEW folder within the installation directory
* re-zips jar (default timeout is 60 seconds... can add command line param to override)
* Handles multiple log4j-core jars within the same installation folder so long as they all have different names

## Compatibility
This script should be compatible on any system that can run VBScript files on the command line using the CScript command.
By default that should include all Windows machines running XP or newer

## Simulaneous Installation, Run, & uninstallation
See release
