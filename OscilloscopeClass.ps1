class Channel {
  [oscilloscope]$MyThis;
  [int]$ChannelID;

  Channel([oscilloscope]$MT,[int]$id) {
    $this.MyThis = $MT;
    $this.ChannelID = $id;
  }

  [string]Display() {
    $ChanID = $this.ChannelID
    $RetVal = ""
    write-host "Assuming Query"
    $RetVal = $this.MyThis.TCPStreamCommand(":CHAN"+$ChanID+":DISP?")
    return($RetVal);
  }

  [string]Display([string]$Command) {
    $ChanID = $this.ChannelID
    $RetVal = ""
    if ($Command.ToLower() -eq "off") {
      write-host("Stopping");
      $RetVal = $this.MyThis.TCPStreamCommand(":CHAN"+$ChanID+":DISP OFF")
    }
    if ($Command.ToLower() -eq "on") {
      write-host("Starting");
      $RetVal = $this.MyThis.TCPStreamCommand(":CHAN"+$ChanID+":DISP ON")
    }
    if ($Command.ToLower() -eq "?") {
      write-host("?");
      $RetVal = $this.MyThis.TCPStreamCommand(":CHAN"+$ChanID+":DISP?")
    }
    return($RetVal);
  }

  [string]Offset([string]$Divs) {
    $ChanID = $this.ChannelID
    $RetVal = ""
    $RetVal = $this.MyThis.TCPStreamCommand(":CHAN"+$ChanID+":OFFS "+$Divs+"")
    return($RetVal);
  }

  [string]Scale([string]$ScaleVal) {
    $ChanID = $this.ChannelID
    $RetVal = ""
    if ($ScaleVal.ToLower() -eq "2") {
      write-host("?");
      $RetVal = $this.MyThis.TCPStreamCommand(":CHAN"+$ChanID+":SCAL "+$ScaleVal+"")
    }
    if ($ScaleVal.ToLower() -eq "5") {
      write-host("?");
      $RetVal = $this.MyThis.TCPStreamCommand(":CHAN"+$ChanID+":SCAL "+$ScaleVal+"")
    }
    return($RetVal);
    #{5mv|10mv|20m v|50mv|100mv|200m v|500mv|1v|2v|5v}
  }

}

class Oscilloscope {

  [ipaddress]$IPAddr;
  [UInt16]$Port;
  [Channel]$Channel1;
  [Channel]$Channel2;


  Oscilloscope() {
    $this.IPAddr = "127.0.0.1";
    $this.Port = 5188;
    $this.Channel1 = [Channel]::new($this,1);
    $this.Channel2 = [Channel]::new($this,2);
    $this.Reset()
  }

  [string]Reset() {
    $this.Stop()
    $this.Channel1.Display("off")
    $this.Channel2.Display("off")
    $this.Channel1.Scale("5")
    $this.Channel2.Scale("5")
    $this.Channel1.offset("0")
    $this.Channel2.offset("0")
    $this.Timebase("100us")
    return("Reset")    
  }

  [string]Start() {
    Start-Sleep -Milliseconds 500
    if ($this.TCPStreamCommand('*RUNS?') -eq "STOP") {
      $this.TCPStreamCommand('*RUNS')
    } else {
      write-host "Already Started"
    }
    return("Started")
  }

  [string]Stop() {
    Start-Sleep -Milliseconds 500
    if ($this.TCPStreamCommand('*RUNS?') -eq "RUN") {
      $this.TCPStreamCommand('*RUNS')
    } else {
      write-host "Already Stopped"
    }
    return("Stopped")
  }


  [string]TCPStreamCommand ( [String]$CommandStream )
  {
    Try
    {
        $ErrorActionPreference = "Stop"
        $TCPClient  = New-Object Net.Sockets.TcpClient
        $IPEndpoint = New-Object Net.IPEndPoint($this.IPAddr, $this.Port)
        $TCPClient.Connect($IPEndpoint)
        $NetStream  = $TCPClient.GetStream()
        [Byte[]]$OBuffer = [Text.Encoding]::ASCII.GetBytes($CommandStream)
        $IBuffer = [Byte[]]::new(256)
        $NetStream.Write($OBuffer, 0, $OBuffer.Length)
        #Write-Host "BufO: " $CommandStream
        $NetStream.Flush()
        $RetLen = $NetStream.Read($IBuffer, 0, 50 )
        $ResponseStream = [System.Text.Encoding]::UTF8.GetString($IBuffer, 0 , $RetLen)
        return($ResponseStream.trim())
    }
    Finally
    {
        If ($this.NetStream) { $this.NetStream.Dispose() }
        If ($this.TCPClient) { $this.TCPClient.Dispose() }
    }
  }

  [string]SendCommand([string]$CommandString) {
    return("sent")
  }

  [string]Timebase([string]$Scale) {
    $RetVal = ""
    $RetVal = $this.TCPStreamCommand(":TIM:SCAL "+$Scale+"")
    return($RetVal);
  }

  [string]SingleTrigger([string]$Mode) {
    $RetVal = ""
    $RetVal = $this.TCPStreamCommand(":TRIG:SING "+$Mode+"")
    return($RetVal);
  }

  [string]Identify() {
    $RetVal = $this.TCPStreamCommand("*IDN?")
    return($RetVal)
  }

}
