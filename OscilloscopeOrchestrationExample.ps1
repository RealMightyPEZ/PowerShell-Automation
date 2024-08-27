.\OscilloscopeClass.ps1

Start-Sleep 5
$MyScope = [Oscilloscope]::new();
Start-Sleep 5
$MyScope.Identify();
Start-Sleep 5
$MyScope.Channel1.Display("on")
Start-Sleep 5
$MyScope.Channel2.Display("off")
$MyScope.SingleTrigger("VIDEO")


$MyScope.Start()
Start-Sleep 5
$MyScope.Channel2.Display("?")
Start-Sleep 5
$MyScope.Channel2.Display()
Start-Sleep 5
$MyScope.Channel1.Scale("2")
Start-Sleep 5
$MyScope.Channel2.Scale("5")
Start-Sleep 5
$MyScope.SingleTrigger("EDGE")
$MyScope.Timebase("10ns")
Start-Sleep 2
$MyScope.Timebase("100ns")
Start-Sleep 2
$MyScope.Timebase("1us")
Start-Sleep 2
$MyScope.Timebase("10us")
Start-Sleep 2
$MyScope.Timebase("100us")
Start-Sleep 2
$MyScope.Timebase("1ms")
Start-Sleep 5
$MyScope.Channel1.Offset("-10")
$MyScope.Channel2.Display("on")
Start-Sleep 1
$MyScope.Channel2.Offset("10")
Start-Sleep 2
$MyScope.Channel1.Offset("-20")
$MyScope.Channel2.Offset("20")
Start-Sleep 2
$MyScope.Channel1.Offset("-30")
$MyScope.Channel2.Offset("30")
Start-Sleep 2
$MyScope.Channel1.Offset("-40")
$MyScope.Channel2.Offset("40")
Start-Sleep 5
$MyScope.Channel2.Display("on")
Start-Sleep 5
$MyScope.Stop()
Start-Sleep 5
$MyScope.Reset()
