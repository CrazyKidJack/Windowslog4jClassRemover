# Windowslog4jClassRemover

## !!!IMPORTANT!!!
This script is TEMPORARY stop gap... it is NOT a remediation.  
The log4j problems are an area of active research and guidance on remediation updates nearly by the minute.  

Consult the interwebs for how you *should* fix this.  
[Apache Log4j Security Vulnerabilities](https://logging.apache.org/log4j/2.x/security.html)  
[CISA.gov - Apache Log4j Vulnerability Guidance](https://www.cisa.gov/uscert/apache-log4j-vulnerability-guidance)  
[GitHub cisagov/log4j-affected-db](https://github.com/cisagov/log4j-affected-db)  

## Description
* This script takes the JndiLookup.class file out of log4j-core JAR files
  * Searches installation directory for log4j-core jars
  * unzips them
  * moves JndiLookup.class out of jar into it's own NEW folder within the installation directory
  * re-zips jar (default timeout is 60 seconds... can add command line param to override)
  * Handles multiple log4j-core jars within the same installation folder so long as they all have different names  

* This is a stop gap and not remediation primarily (but not necessarily only) because:
  * It is not the officially recommended approach
  * It just removes the JndiLookup.class file from the JAR on the actual running maching... it does not update your code
    * This means that the next time the app is built and released / deployed, the changes applied by this script will be overwritten.
  * Because the script just removes the JndiLookup.class files, it is possible that it could cause some applications that depend on that class file to break

## Compatibility
This script should be compatible on any system that can run VBScript files on the command line using the CScript command.  
By default that should include all Windows machines running XP or newer

## Installation, Run, & uninstallation
See [release](https://github.com/CrazyKidJack/Windowslog4jClassRemover/releases/latest)
