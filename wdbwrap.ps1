$WinDbgPath = "C:\Program Files (x86)\Windows Kits\8.0\Debuggers\x86\windbg.exe" # Update with path to WinDBG
$breakpoints = @("0x12345678") # Set your desired breakpoints here
$halt = $true # Halt execution once the debugger attaches

$path = $args[0]

$procPid = 0;

if ($path -match "iexplore.exe") {
    $process = Start-Process -FilePath $path -PassThru;
    Start-Sleep -Seconds 1
    $childProcess = Get-WmiObject Win32_Process | Where-Object { $_.ParentProcessId -eq $process.Id };
    $procPid = $childProcess.ProcessId;
}
else {

    $process = Start-Process -FilePath $path -PassThru
    $procPid = $process.Id
}

$args = @("-p $procPid")
$commandString = ""
foreach ($bp in $breakpoints) {
    $commandString = $commandString + "bp $bp;";
}

if (!$halt) {
    $commandString += "g;"
}

$args = @("-p $procPid", "-c `"$commandString`"");
Write-Output $args

Start-Process $WinDbgPath -argumentList $args -Verb RunAs
