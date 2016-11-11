#Get-EventLogs

##Overview
This PowerShell script collects event logs from systems and saves them in a CSV format

There was a need for a script to collect event logs on a network at work, saving them in CSV for later extraction off the network. This was a perfect opportunity to develop a script for both work and DSU's CSC842 class.

This script can gather a list of systems from which to collect from Active Directory by using the -ActiveDirectory command line switch. This will pull a list of all systems. Please note, this requires Remote Server Administration Tools (RSAT) to be installed for the use of the Get-ADComputer CMDlet.

Note: This script was created during Dakota State University's CSC-842 Rapid Tool Development course.

##Usage
```PowerShell
 .\Get-EventLogs.ps1 [[-ComputerName] <String[]>] [-ActiveDirectory] [-NoPing] [-Security] [-System] [-Application] [-OutputLocation] [-Before <DateTime>] [-After <DateTime>]  [<CommonParameters>]
```
For detailed help and examples, run 
````PowerShell
Get-Help .\Get-EventLogs.ps1
````

##Future Work
* Utilize threading to collect from multiple computers concurrently.
* Research a method to collect these logs more quickly. 

##Resources
* [Video Demo](https://youtu.be/6IayZZXNyUk)
