$void = [System.Reflection.Assembly]::LoadWithPartialName("NationalInstruments.Visa")

#
# Create a ResourceManager Object
#
[NationalInstruments.Visa.ResourceManager]$ResourceManager = New-Object -typename NationalInstruments.Visa.ResourceManager 

#
#  Find method will find all available resources based off the command filter '?*'
#
$filter = '?*'
$resources = $ResourceManager.Find($filter);
write-host "[Resource] " $Resources[0]

#
#  We will open the first resource $resource[0] in this case.  Currently I only have one managable device
#  In the future I will modify to manage multiple devices
#
$MessageBasedSession = $ResourceManager.Open($resources[0])
write-host "[Session Manufacturer & Model] "$MessageBasedSession.ManufacturerName $MessageBasedSession.ModelName

$MessageBasedSession.RawIO.Write('*IDN?\n');
write-host "[Session *IDN? Query Response] " $MessageBasedSession.RawIO.ReadString()

#
#  Read the current configured frequency for each of the 2 channels
#
$MessageBasedSession.RawIO.Write(':CHANnel1:BASE:FREQuency?');
write-host "[Session CH1 Freq] " $MessageBasedSession.RawIO.ReadString()
$MessageBasedSession.RawIO.Write(':CHANnel2:BASE:FREQuency?');
write-host "[Session CH2 Freq] " $MessageBasedSession.RawIO.ReadString()

#
#  Read the current configured phase for each of the 2 channels
#
$MessageBasedSession.RawIO.Write(':CHANnel1:BASE:PHASE?');
write-host "[Session CH1 Phase] " $MessageBasedSession.RawIO.ReadString()
$MessageBasedSession.RawIO.Write(':CHANnel2:BASE:PHASE?');
write-host "[Session CH2 Phase] " $MessageBasedSession.RawIO.ReadString()


#
#Demonstration of Automation
#
$MessageBasedSession.RawIO.Write(':CHANnel1:OUTput OFF');
$MessageBasedSession.RawIO.Write(':CHANnel2:OUTput OFF');
$MessageBasedSession.RawIO.Write(':CHANnel1:BASE:FREQuency 1');
$MessageBasedSession.RawIO.Write(':CHANnel2:BASE:FREQuency 1');
$MessageBasedSession.RawIO.Write(':CHANnel1:BASE:OFFS 0');
$MessageBasedSession.RawIO.Write(':CHANnel2:BASE:OFFS 0');
$MessageBasedSession.RawIO.Write(':CHANnel1:BASE:PHASE 0');
$MessageBasedSession.RawIO.Write(':CHANnel2:BASE:PHASE 0');
$MessageBasedSession.RawIO.Write(':CHAN1:BASE:WAVE SINE');
$MessageBasedSession.RawIO.Write(':CHAN2:BASE:WAVE SINE');
write-host "Turning Outputs On"
$MessageBasedSession.RawIO.Write(':CHANnel1:OUTput ON');
$MessageBasedSession.RawIO.Write(':CHANnel2:OUTput ON');
Start-Sleep 5
write-host "Invert Channel 2"
$MessageBasedSession.RawIO.Write(':CHANnel2:INV 1');
Start-Sleep 5
write-host "Changing Frequency"
$MessageBasedSession.RawIO.Write(':CHANnel2:BASE:FREQuency 2');
Start-Sleep 5
write-host "Change Offset CH1"
$MessageBasedSession.RawIO.Write(':CHANnel1:BASE:OFFS 2.5');
Start-Sleep 5
write-host "Change Offset CH2"
$MessageBasedSession.RawIO.Write(':CHANnel2:BASE:OFFS 2.5');
Start-Sleep 5
write-host "Invert Channel 2"
$MessageBasedSession.RawIO.Write(':CHANnel2:INV 0');
Start-Sleep 5
write-host "Changing Wave"
$MessageBasedSession.RawIO.Write(':CHANnel1:BASE:WAVE SQU');
Start-Sleep 5
write-host "Changing Phase"
$MessageBasedSession.RawIO.Write(':CHANnel2:BASE:PHASE 180');
Start-Sleep 5
write-host "Outputs Off"
$MessageBasedSession.RawIO.Write(':CHANnel1:OUTput OFF');
$MessageBasedSession.RawIO.Write(':CHANnel2:OUTput OFF');


