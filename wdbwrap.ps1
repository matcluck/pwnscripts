$WinDbgPath = "C:\Program Files (x86)\Windows Kits\8.0\Debuggers\x86\windbg.exe" # Update with path to WinDBG
$breakpoints = @("kernel32!LoadLibraryA", "kernel32!GetProcAddress") # Set your desired breakpoints here
$halt = $true # Halt execution once the debugger attaches

$path = $args[0]
$process = Start-Process -FilePath $path -PassThru
$procPid = $process.Id
Start-Sleep -Seconds 3

$args = @("-p $procPid")
$commandString = ""
foreach ($bp in $breakpoints) {
    $commandString = $commandString + "bp $bp;";
}

if (!$halt) {
    $commandString += "g;"
}

$args = @("-p $procPid", "-c `"$commandString`"");

Start-Process $WinDbgPath -argumentList $args -Verb RunAs
