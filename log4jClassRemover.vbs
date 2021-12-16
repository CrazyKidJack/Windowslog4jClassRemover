'https://dlcdn.apache.org/logging/log4j/2.15.0/apache-log4j-2.15.0-bin.zip
'https://dlcdn.apache.org/logging/log4j/2.16.0/apache-log4j-2.16.0-bin.zip

'/////////////////////////////////////////////////////////////////////////////
'GLOBAL CONSTANTS
'/////////////////////////////////////////////////////////////////////////////
JNDI_CLASS_RELPATH="\org\apache\logging\log4j\core\lookup\JndiLookup.class"
JNDI_CLASS_FILENAME="JndiLookup.class"
LOG4J_GLOB="log4j-core-*.jar"
LOG4J_REGEX="log4j-core-2.([0-9]+\.){1,2}jar"

'/////////////////////////////////////////////////////////////////////////////
'PROCEDURES & FUNCTIONS
'/////////////////////////////////////////////////////////////////////////////
Sub handleEmptyDirRes(dirRes)
    if dirRes=vbnullstring then
        wscript.echo "Log4j not found"
        wscript.Quit
    end if
End Sub 'handleEmptyDirRes

'splits dirRes string into array and removes empty elements
Function fixDirRes(dirRes)
    'split result into an array of files
    dirRes = split(dirRes,vbcrlf)

    'remove empty lines in result
    fixDirRes = Filter(dirRes,"log4j-core",vbtrue)
End Function 'fixDirRes

'checks for empty dirRes then...
'splits dir res string into array and removes empty elements
Function handleDirRes(dirRes)
    handleEmptyDirRes dirRes

    handleDirRes = fixDirRes(dirRes)
End Function 'handleDirRes

Sub handleEmptylog4jFileLst(log4jFileLst)
    if log4jFileLst = "" then
        wscript.echo LOG4J_REGEX & " not found"
        wscript.Quit
    end if
End Sub 'handleEmptylog4jFileLst

'use regex to filter results down to the specific file we want
'  matching regex: LOG4J_REGEX
'OUTPUT: array containing only filenames that match the regex
Function getLog4jFileLst(dirRes)
    Set re = New RegExp
    With re
        .Pattern    = LOG4J_REGEX
        .IgnoreCase = False
        .Global     = False
    End With
    log4jFileLst = "" 'initally is a tab separated list of matching files

    for idx = 0 to ubound(dirRes) Step 1
        'if file from dir matches regex
        if re.Test(dirRes(idx)) then
            'if this is the first match
            if log4jFileLst = "" then
                log4jFileLst = dirRes(idx)
            else 'if this is not the first match
                log4jFileLst = log4jFileLst & vbTab & dirRes(idx)
            end if
        end if
    next

    handleEmptylog4jFileLst log4jFileLst

    'split log4jFileLst string into array
    getLog4jFileLst = split(log4jFileLst,vbTab)
End Function 'getLog4jFileLst

Function jar2zip(FS, jarPath)
    'changes last 3 chars to "zip"
    zipPath = FS.GetAbsolutePathName(Left(jarPath,Len(jarPath)-3) & "zip")
    FS.MoveFile jarPath, zipPath

    jar2zip = zipPath
End Function 'jar2zip

Function zip2Jar(FS, zipPath)
    'changes last 3 chars to "jar"
    jarPath = FS.GetAbsolutePathName(Left(zipPath,Len(zipPath)-3) & "jar")
    wscript.echo "zipPath: " & zipPath
    wscript.echo "jarPath: " & jarPath
    FS.MoveFile zipPath, jarPath

    zip2Jar = jarPath
End Function

Sub createFldr(FS, fldrPath)
    if NOT FS.FolderExists(fldrPath) then
        FS.CreateFolder(fldrPath)
    end if
End Sub 'createFldr

Function unzipJar(FS, objShell, jarPath)
    zipPath = jar2zip(FS, jarPath)
    'removes .zip
    unzipPath = FS.GetAbsolutePathName(Left(zipPath,Len(zipPath)-3))
    createFldr FS, unzipPath

    set filesInZip = objShell.NameSpace(zipPath).items
    objShell.NameSpace(unzipPath).CopyHere(filesInZip)

    FS.DeleteFile zipPath

    unzipJar = Array(unzipPath, zipPath)
End Function 'unzipJar

Function wait4Copy(zipPath, source)
    numSources = source.Count
    numDests   =  objShell.NameSpace(zipPath).Items.Count
    maxIterations=60

    iter=0
    Do Until numDests = numSources
        iter = iter + 1
        wscript.Sleep(1000)
        numDests   =  objShell.NameSpace(zipPath).Items.Count
    Loop
End Function

Function zipJar(FS, objShell, unzipPath, zipPath)
    'create empty zip
    FS.CreateTextFile(zipPath, True).Write "PK" & Chr(5) & Chr(6) & String(18, vbNullChar)
    'get items to copy to zip
    Set source = objShell.NameSpace(unzipPath).Items
    'copy items
    objShell.NameSpace(zipPath).CopyHere(source)

    Call wait4Copy(zipPath, source)
    Call zip2Jar(FS, zipPath)
End Function 'zipJar

'/////////////////////////////////////////////////////////////////////////////
'MAIN
'/////////////////////////////////////////////////////////////////////////////
' Get command-line arguments.
Set objArgs = WScript.Arguments

'allow interaction with file system
Set FS = CreateObject("Scripting.FileSystemObject")
workingDir = FS.GetParentFolderName(WScript.ScriptFullName)

'allow interaction with cmd
Set ows = CreateObject("Wscript.shell")
Set objShell = CreateObject("Shell.Application")

'run dir in cmd to get initial list of files in working directory that match LOG4J_GLOB
Set oExec = ows.Exec("%comspec% /c dir /b " & chr(34) & workingDir & "\" & LOG4J_GLOB & chr(34))
dirRes = oExec.StdOut.ReadAll()
dirRes = handleDirRes(dirRes)

'print num results
wscript.echo "GLOB " & LOG4J_GLOB & " found: " & (ubound(dirRes) + 1)

'use regex to filter results down to the specific file we want
'  matching regex: LOG4J_REGEX
log4jFileLst = getLog4jFileLst(dirRes)
wscript.echo "REGEX " & LOG4J_REGEX & " found: " & (ubound(log4jFileLst) + 1)

'loop thru REGEX identified LOG4J_REGEX files
for each log4jFile in log4jFileLst
    log4jPath = FS.GetAbsolutePathName(log4jFile)

    unzipRtn = unzipJar(FS, objShell, log4jPath)
    unzipPath = unzipRtn(0)
    zipPath   = unzipRtn(1)
    
    'remove class file
    jndiClassFullPath = unzipPath & JNDI_CLASS_RELPATH
    if FS.FileExists(jndiClassFullPath) then
        jndiZipFldrPath = workingDir & "\" & JNDI_CLASS_FILENAME & "_" & log4jFile
        createFldr FS, jndiZipFldrPath
        wscript.echo "source: " & jndiClassFullPath
        wscript.echo "dest  : " & jndiZipFldrPath & "\" & JNDI_CLASS_FILENAME
        FS.MoveFile jndiClassFullPath, jndiZipFldrPath & "\" & JNDI_CLASS_FILENAME
    end if

    'zip jar
    Call zipJar(FS, objShell, unzipPath, zipPath)

    'cleanUp
    FS.DeleteFolder unzipPath
next
'unzip jars

'change log4j file extension to .zip

'InputFolder = FS.GetAbsolutePathName(objArgs(0))
'ZipFile = FS.GetAbsolutePathName(objArgs(1))