<#
.SYNOPSIS
A Powershell script to acquire Event Logs on a list of systems and export as CSV

.DESCRIPTION
This script utilizes WMI to acquire event logs in the past 7 days by default

.PARAMETER ComputerName
An array of fully qualified computer names to collect data from.

.PARAMETER ActiveDirectory
A switch to gather computer names from active directory (Requires RSAT)

.PARAMETER NoPing
A switch to bypass ping check on active directory computers

.PARAMETER Security
A switch to gather the Security log

.PARAMETER System
A switch to gather the System log

.PARAMETER Application
A switch to gather the Application log

.PARAMETER OutputLocation
The location to store CSV files. Default is output\

.PARAMETER Before
The date from which you would like to collect logs before Default is today

.PARAMETER After
The date from which you would like to collect logs after. Default is today-7 days

.EXAMPLE
.\Get-EventLogs.ps1 -ActiveDirectory -Security
Gets all computers from active directory, and collects the Security log.
#>

[CmdletBinding()]
Param(
    [Parameter(ValueFromPipeline=$true, ValueFromPipelineByPropertyName = $true)]
    [string[]]$ComputerName,
    [switch]$ActiveDirectory = $false,
    [switch]$NoPing = $false,
    [switch]$Security = $false,
    [switch]$System = $false,
    [switch]$Application = $false,
    [string]$OutputLocation = "output\",
    [DateTime]$Before = (Get-Date),
    [DateTime]$After = ((Get-Date).AddDays(-7))
)
begin
{
    if(!$Security -AND !$System -AND !$Application)
    {
        Write-Error "You must specify a log type"
        exit
    }
    
    if($ActiveDirectory)
    {
        $ADComputers = (Get-ADComputer -Filter *).DNSHostName
    
        if(!$NoPing)
        {
            ForEach($Com in $ADComputers)
            {
                Write-Progress -Activity "Pinging $Com"
                if(Test-Connection -ComputerName $Com -Count 1 -quiet)
                {
                    Write-Host "Host is up: "$Com
                    $ComputerName += $Com
                }
            }
        }
        else
        {
            $ComputerName = $ADComputers
        }
    }

    $i=0

    $date = Get-Date -Format yyyyMMdd

    $OutputLocationDate = $OUtputLocation+$date+"\"

    if(!(Test-Path $OutputLocationDate))
    {
        New-Item -ItemType Directory -Force -Path $OutputLocationDate | Out-Null
    }
}
process
{
    if(!$ActiveDirectory)
    {
        Write-Host "Collecting on "$ComputerName
        [string]$out = $OutputLocationDate + $ComputerName

        if($Security)
        {
            Write-Progress -Activity "Collecting Security Logs from $ComputerName" -Status "Finished collecting on $i systems"
            Get-EventLog -ComputerName $ComputerName -LogName Security -After $After -Before $Before | Export-csv $out"_Security.csv"
        }
        if($System)
        {
            Write-Progress -Activity "Collecting System Logs from $ComputerName" -Status "Finished collecting on $i systems"
            Get-EventLog -ComputerName $ComputerName -LogName System -After $After -Before $Before | Export-csv $out"_System.csv"
        }
        if($Application)
        {
            Write-Progress -Activity "Collecting Application Logs from $ComputerName" -Status "Finished collecting on $i systems"
            Get-EventLog -ComputerName $ComputerName -LogName Application -After $After -Before $Before | Export-csv $out"_Application.csv"
        }
        $i++
    }
    else
    {
        ForEach($Computer in $ComputerName)
        {
            Write-Host "Collecting on "$Computer
            [string]$out = $OutputLocationDate + $Computer

            if($Security)
            {
                Write-Progress -Activity "Collecting Security Logs from $Computer" -Status "Finished collecting on $i systems"
                Get-EventLog -ComputerName $Computer -LogName Security -After $After -Before $Before | Export-csv $out"_Security.csv"
            }
            if($System)
            {
                Write-Progress -Activity "Collecting System Logs from $Computer" -Status "Finished collecting on $i systems"
                Get-EventLog -ComputerName $Computer -LogName System -After $After -Before $Before | Export-csv $out"_System.csv"
            }
            if($Application)
            {
                Write-Progress -Activity "Collecting Application Logs from $Computer" -Status "Finished collecting on $i systems"
                Get-EventLog -ComputerName $Computer -LogName Application -After $After -Before $Before | Export-csv $out"_Application.csv"
            }
            $i++
        }
    }
}