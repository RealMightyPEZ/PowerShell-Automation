#
# Example simple code for managing test instruments unsing Powershell, VISA and SCPI 
#
# Bibliography:
# [1] https://documentation.help/NI-VISA/BeginningTerminology.html
# [2] UNI-T Program Manual; UTG Series Programmable Signal Source; June, 2017 UNI-T TECHNOLOGIES， INC.
#

# Load the NI-VISA .NET assembly so powershell can access the required methods
#
$void = [System.Reflection.Assembly]::LoadWithPartialName("NationalInstruments.Visa")

#
# Create a ResourceManager Object
# A resource is simply a complete description of a particular set of capabilities of a device [1]
#
[NationalInstruments.Visa.ResourceManager]$ResourceManager = New-Object -typename NationalInstruments.Visa.ResourceManager 

#
#  Find method will find all available resources based off the command filter '?*' [2]
#
$filter = '?*'
$resources = $ResourceManager.Find($filter);
write-host "[Resource count] " $resources.Count

#  We will open the a session to the first resource (Index offset 0) $resource[0] in this case.  Currently I only have one managable device
#  In the future I will modify to manage multiple devices
#
# $resources[0]
#
#  A session connects you to the device resource you addressed in the $ResourceManager.Open() operation and keeps your communication and attribute 
#  settings unique from other sessions to the same resource. [1]
#
$MessageBasedSession = $ResourceManager.Open($resources[0])

# $MessageBasedSession | Get-Member | Where-Object {$_.membertype -eq 'Property' }
#
# Example: Accessing properties of the session
#
write-host "[Session Manufacturer & Model] "$MessageBasedSession.ManufacturerName $MessageBasedSession.ModelName

#
# Commands are sent to the device using RawIO.Write followed by a RawIO.ReadString to read the device response
#
# example:
# Send a request identification '*IDN?' followed by reading the response
#
$MessageBasedSession.RawIO.Write('*IDN?\n');
write-host "[Session *IDN? Query Response] " $MessageBasedSession.RawIO.ReadString()

#
#  Request and read the current configured frequency for each of the 2 channels
#
$MessageBasedSession.RawIO.Write(':CHANnel1:BASE:FREQuency?');
write-host "[Session CH1 Freq] " $MessageBasedSession.RawIO.ReadString()
$MessageBasedSession.RawIO.Write(':CHANnel2:BASE:FREQuency?');
write-host "[Session CH2 Freq] " $MessageBasedSession.RawIO.ReadString()

#
#  Request and read the current configured phase for each of the 2 channels
#
$MessageBasedSession.RawIO.Write(':CHANnel1:BASE:PHASE?');
write-host "[Session CH1 Phase] " $MessageBasedSession.RawIO.ReadString()
$MessageBasedSession.RawIO.Write(':CHANnel2:BASE:PHASE?');
write-host "[Session CH2 Phase] " $MessageBasedSession.RawIO.ReadString()


#
# The rest of the code is the example automation proper:
#
# Demonstration of Automation
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
write-host "Turning CH 1 Output On"
$MessageBasedSession.RawIO.Write(':CHANnel1:OUTput ON');
write-host "Turning CH 2 Output On"
$MessageBasedSession.RawIO.Write(':CHANnel2:OUTput ON');
Start-Sleep 5
write-host "Invert CH 2"
$MessageBasedSession.RawIO.Write(':CHANnel2:INV 1');
Start-Sleep 5
write-host "Changing CH 2 Frequency: 2HZ"
$MessageBasedSession.RawIO.Write(':CHANnel2:BASE:FREQuency 2');
Start-Sleep 5
write-host "Change Offset CH1 2.5V"
$MessageBasedSession.RawIO.Write(':CHANnel1:BASE:OFFS 2.5');
Start-Sleep 5
write-host "Change Offset CH2 2.5V"
$MessageBasedSession.RawIO.Write(':CHANnel2:BASE:OFFS 2.5');
Start-Sleep 5
write-host "Un Invert CH 2"
$MessageBasedSession.RawIO.Write(':CHANnel2:INV 0');
Start-Sleep 5
write-host "Change CH 1 Wave: Square"
$MessageBasedSession.RawIO.Write(':CHANnel1:BASE:WAVE SQU');
Start-Sleep 5
write-host "Change CH2 Phase: 180deg"
$MessageBasedSession.RawIO.Write(':CHANnel2:BASE:PHASE 180');
Start-Sleep 5
write-host "Outputs Off"
$MessageBasedSession.RawIO.Write(':CHANnel1:OUTput OFF');
$MessageBasedSession.RawIO.Write(':CHANnel2:OUTput OFF');


