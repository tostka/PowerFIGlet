## Pre-Loaded Module code ##

<#
 Put all code that must be run prior to function dot sourcing here.

 This is a good place for module variables as well. The only rule is that no
 variable should rely upon any of the functions in your module as they
 will not have been loaded yet. Also, this file cannot be completely
 empty. Even leaving this comment is good enough.
#>

$PowerFIGletFontDirectory = Join-Path -Path $PSScriptRoot -ChildPath 'fonts'

## PRIVATE MODULE FUNCTIONS AND DATA ##

function Get-CallerPreference {
    <#
    .Synopsis
       Fetches "Preference" variable values from the caller's scope.
    .DESCRIPTION
       Script module functions do not automatically inherit their caller's variables, but they can be
       obtained through the $PSCmdlet variable in Advanced Functions.  This function is a helper function
       for any script module Advanced Function; by passing in the values of $ExecutionContext.SessionState
       and $PSCmdlet, Get-CallerPreference will set the caller's preference variables locally.
    .PARAMETER Cmdlet
       The $PSCmdlet object from a script module Advanced Function.
    .PARAMETER SessionState
       The $ExecutionContext.SessionState object from a script module Advanced Function.  This is how the
       Get-CallerPreference function sets variables in its callers' scope, even if that caller is in a different
       script module.
    .PARAMETER Name
       Optional array of parameter names to retrieve from the caller's scope.  Default is to retrieve all
       Preference variables as defined in the about_Preference_Variables help file (as of PowerShell 4.0)
       This parameter may also specify names of variables that are not in the about_Preference_Variables
       help file, and the function will retrieve and set those as well.
    .EXAMPLE
       Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState

       Imports the default PowerShell preference variables from the caller into the local scope.
    .EXAMPLE
       Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState -Name 'ErrorActionPreference','SomeOtherVariable'

       Imports only the ErrorActionPreference and SomeOtherVariable variables into the local scope.
    .EXAMPLE
       'ErrorActionPreference','SomeOtherVariable' | Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState

       Same as Example 2, but sends variable names to the Name parameter via pipeline input.
    .INPUTS
       String
    .OUTPUTS
       None.  This function does not produce pipeline output.
    .LINK
       about_Preference_Variables
    #>

    [CmdletBinding(DefaultParameterSetName = 'AllVariables')]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateScript({ $_.GetType().FullName -eq 'System.Management.Automation.PSScriptCmdlet' })]
        $Cmdlet,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.SessionState]$SessionState,

        [Parameter(ParameterSetName = 'Filtered', ValueFromPipeline = $true)]
        [string[]]$Name
    )

    begin {
        $filterHash = @{}
    }
    
    process {
        if ($null -ne $Name)
        {
            foreach ($string in $Name)
            {
                $filterHash[$string] = $true
            }
        }
    }

    end {
        # List of preference variables taken from the about_Preference_Variables help file in PowerShell version 4.0

        $vars = @{
            'ErrorView' = $null
            'FormatEnumerationLimit' = $null
            'LogCommandHealthEvent' = $null
            'LogCommandLifecycleEvent' = $null
            'LogEngineHealthEvent' = $null
            'LogEngineLifecycleEvent' = $null
            'LogProviderHealthEvent' = $null
            'LogProviderLifecycleEvent' = $null
            'MaximumAliasCount' = $null
            'MaximumDriveCount' = $null
            'MaximumErrorCount' = $null
            'MaximumFunctionCount' = $null
            'MaximumHistoryCount' = $null
            'MaximumVariableCount' = $null
            'OFS' = $null
            'OutputEncoding' = $null
            'ProgressPreference' = $null
            'PSDefaultParameterValues' = $null
            'PSEmailServer' = $null
            'PSModuleAutoLoadingPreference' = $null
            'PSSessionApplicationName' = $null
            'PSSessionConfigurationName' = $null
            'PSSessionOption' = $null

            'ErrorActionPreference' = 'ErrorAction'
            'DebugPreference' = 'Debug'
            'ConfirmPreference' = 'Confirm'
            'WhatIfPreference' = 'WhatIf'
            'VerbosePreference' = 'Verbose'
            'WarningPreference' = 'WarningAction'
        }

        foreach ($entry in $vars.GetEnumerator()) {
            if (([string]::IsNullOrEmpty($entry.Value) -or -not $Cmdlet.MyInvocation.BoundParameters.ContainsKey($entry.Value)) -and
                ($PSCmdlet.ParameterSetName -eq 'AllVariables' -or $filterHash.ContainsKey($entry.Name))) {
                
                $variable = $Cmdlet.SessionState.PSVariable.Get($entry.Key)
                
                if ($null -ne $variable) {
                    if ($SessionState -eq $ExecutionContext.SessionState) {
                        Set-Variable -Scope 1 -Name $variable.Name -Value $variable.Value -Force -Confirm:$false -WhatIf:$false
                    }
                    else {
                        $SessionState.PSVariable.Set($variable.Name, $variable.Value)
                    }
                }
            }
        }

        if ($PSCmdlet.ParameterSetName -eq 'Filtered') {
            foreach ($varName in $filterHash.Keys) {
                if (-not $vars.ContainsKey($varName)) {
                    $variable = $Cmdlet.SessionState.PSVariable.Get($varName)
                
                    if ($null -ne $variable)
                    {
                        if ($SessionState -eq $ExecutionContext.SessionState)
                        {
                            Set-Variable -Scope 1 -Name $variable.Name -Value $variable.Value -Force -Confirm:$false -WhatIf:$false
                        }
                        else
                        {
                            $SessionState.PSVariable.Set($variable.Name, $variable.Value)
                        }
                    }
                }
            }
        }
    }
}

## PUBLIC MODULE FUNCTIONS AND DATA ##

function ConvertTo-FIGletFont {
    <#
    .EXTERNALHELP PowerFIGlet-help.xml
    .LINK
        https://github.com/MischaBoender/PowerFIGlet/tree/master/release/0.0.2/docs/Functions/ConvertTo-FIGletFont.md
    #>

    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline=$true, Position=0)]
        [object]$InputObject,
        [string]$Font="standard",
        [string]$FontDirectory=$PowerFIGletFontDirectory,
        [int]$TerminalWidth=$Host.UI.RawUI.BufferSize.Width,
        [switch]$Center
    )

    begin {
        $FIGletFont = Get-FIGletFont -Font $Font -FontDirectory $FontDirectory
        $TerminalWidth += 1
    }

    process {
        $OutputLines = @()
        for ($Line=0; $Line -lt $FIGletFont.Height; $Line++) {
            $TotalWidth = 0

            foreach ($Char in [char[]]($InputObject.ToString())) {
                $CharLine = $FIGletFont.Characters[[int]$Char][$Line]
                $TotalWidth += $CharLine.Length
                $OutputLineIndex = [math]::Floor($TotalWidth / $TerminalWidth)
                if (-not $OutputLines[$OutputLineIndex]) {$OutputLines += ,@("")}
                if (-not $OutputLines[$OutputLineIndex][$Line]) {$OutputLines[$OutputLineIndex] += ""}
                $OutputLines[$OutputLineIndex][$Line] += $CharLine
            }
        }

        for ($i=0; $i -lt $OutputLines.Count; $i++) {
            if ($Center.IsPresent) {
                $LineWidth = $OutputLines[$i][0].Length
                $Prepend = ($TerminalWidth - $LineWidth) /2
                Write-Output ([string]::Join("`r`n", ($OutputLines[$i] | %{(" " * $Prepend) + $_}))).TrimEnd()
            }
            else {
                Write-Output ([string]::Join("`r`n", $OutputLines[$i])).TrimEnd()
            }
        }
    }
}


function Get-FIGletFont {
    <#
    .EXTERNALHELP PowerFIGlet-help.xml
    .LINK
        https://github.com/MischaBoender/PowerFIGlet/tree/master/release/0.0.2/docs/Functions/Get-FIGletFont.md
    #>

    [CmdletBinding(DefaultParameterSetName="Font")]
    param(
        [Parameter(ParameterSetName="Font", ValueFromPipelineByPropertyName=$true)]
        [string]$Font="standard",
        [Parameter(ParameterSetName="ListAvailable")]
        [switch]$ListAvailable,
        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [string]$FontDirectory=$PowerFIGletFontDirectory
    )

    process {
        switch ($PSCmdlet.ParameterSetName) {
            "ListAvailable" {
                foreach ($FontFile in @(Get-ChildItem -Path $Folder -Filter "*.flf" -Recurse)) {
                    $FontObject = [PSCustomObject]@{
                        Font = $FontFile.BaseName
                        FontDirectory = $FontFile.Directory
                    }
                    $FontObject.PSObject.TypeNames.Insert(0, "MischaBoender.PowerShell.PowerFiglet.FigletFont")
                    Write-Output $FontObject
                }
            }
            "Font" {
                $FontFile = Get-ChildItem -Path $Folder -Filter "$Font.flf" -Recurse | Select-Object -First 1

                if ($FontFile) {
                    $FontFileContent = Get-Content -Path $FontFile.FullName
                    $FontMetadata = @($FontFileContent[0] -split ' ') + @(0,0,0)
                    if ($FontMetadata[0].Substring(0,5) -ne "flf2a") {
                        Write-Error "`"$Font`" is not a Figlet font"
                    }
                    $CharacterHeight = [int]$FontMetadata[1]
                    $BlankCharacter = [string]$FontMetadata[0].Substring(5,1)
                    $LineEndCharacter = $FontFileContent[[int]$FontMetadata[5] + 1][-1]

                    $FontTable = @{}
                    $FontCharacters = $FontFileContent[([int]$FontMetadata[5] + 1)..($FontFileContent.Length - 1)] -join "`r`n" -split "$LineEndCharacter$LineEndCharacter`r`n"

                    for ($iFontCharacter = 0; $iFontCharacter -lt $FontCharacters.Length; $iFontCharacter++) {
                        $FIGletCharacter = @()
                        $CharacterLines = $FontCharacters[$iFontCharacter] -split "`r`n"
                        foreach ($CharacterLine in $CharacterLines[($CharacterLines.Length - $CharacterHeight)..($CharacterLines.Length - 1)]) {
                            if ($CharacterLine.EndsWith($LineEndCharacter)) {
                                $FIGletCharacter += $CharacterLine.Substring(0, ($CharacterLine.Length - 1)).Replace($BlankCharacter, " ")
                            }
                            else {
                                $FIGletCharacter += $CharacterLine.Replace($BlankCharacter, " ")
                            }

                        }

                        try {
                            if ($CharacterLines.Length -gt $CharacterHeight) {
                                $sCharacterValue = $CharacterLines[0].Split(" ")[0]
                                if ($sCharacterValue.IndexOf("x") -eq 1) {
                                    $iCharacterValue = [convert]::ToInt32($sCharacterValue,16)
                                }
                                else {
                                    $iCharacterValue = [convert]::ToInt32($sCharacterValue,10)
                                }
                                $FontTable.Add($iCharacterValue, $FIGletCharacter)
                            }
                            else {
                                $FontTable.Add($iFontCharacter + 32, $FIGletCharacter)
                            }
                        } catch {}
                    }

                    $FontObject = [PSCustomObject]@{
                        Font = $FontFile.BaseName
                        FontDirectory = $FontFile.Directory
                        BlankCharacter = [string]$FontMetadata[0].Substring(5,1)
                        Height = [int]$FontMetadata[1]
                        BaseLine = [int]$FontMetadata[2]
                        #MaxLen = [int]$FontMetadata[3]
                        #OldLayout = [int]$FontMetadata[4]
                        #CommentLines = [int]$FontMetadata[5]
                        RightToLeft = [bool][int]$FontMetadata[6]
                        #FullLayout = [int]$FontMetadata[7]
                        #CodeTagCount = [int]$FontMetadata[8]
                        Comment = $FontFileContent[1..$FontMetadata[5]]
                        Characters = $FontTable
                    }
                    $FontObject.PSObject.TypeNames.Insert(0, "MischaBoender.PowerShell.PowerFiglet.FigletFont")

                    Write-Output $FontObject
                }
                else {
                    Write-Error "Font `"$Font`" not found in `"$Folder`""
                }
            }
        }
    }
}


## Post-Load Module code ##

# Use this variable for any path-sepecific actions (like loading dlls and such) to ensure it will work in testing and after being built
$MyModulePath = $(
    Function Get-ScriptPath {
        $Invocation = (Get-Variable MyInvocation -Scope 1).Value
        if($Invocation.PSScriptRoot) {
            $Invocation.PSScriptRoot
        }
        Elseif($Invocation.MyCommand.Path) {
            Split-Path $Invocation.MyCommand.Path
        }
        elseif ($Invocation.InvocationName.Length -eq 0) {
            (Get-Location).Path
        }
        else {
            $Invocation.InvocationName.Substring(0,$Invocation.InvocationName.LastIndexOf("\"));
        }
    }

    Get-ScriptPath
)

# Load any plugins found in the plugins directory
if (Test-Path (Join-Path $MyModulePath 'plugins')) {
    Get-ChildItem (Join-Path $MyModulePath 'plugins') -Directory | ForEach-Object {
        if (Test-Path (Join-Path $_.FullName "Load.ps1")) {
            Invoke-Command -NoNewScope -ScriptBlock ([Scriptblock]::create(".{$(Get-Content -Path (Join-Path $_.FullName "Load.ps1") -Raw)}")) -ErrorVariable errmsg 2>$null
        }
    }
}

$ExecutionContext.SessionState.Module.OnRemove = {
    # Action to take if the module is removed
    # Unload any plugins found in the plugins directory
    if (Test-Path (Join-Path $MyModulePath 'plugins')) {
        Get-ChildItem (Join-Path $MyModulePath 'plugins') -Directory | ForEach-Object {
            if (Test-Path (Join-Path $_.FullName "UnLoad.ps1")) {
                Invoke-Command -NoNewScope -ScriptBlock ([Scriptblock]::create(".{$(Get-Content -Path (Join-Path $_.FullName "UnLoad.ps1") -Raw)}")) -ErrorVariable errmsg 2>$null
            }
        }
    }
}

$null = Register-EngineEvent -SourceIdentifier ( [System.Management.Automation.PsEngineEvent]::Exiting ) -Action {
    # Action to take if the whole pssession is killed
    # Unload any plugins found in the plugins directory
    if (Test-Path (Join-Path $MyModulePath 'plugins')) {
        Get-ChildItem (Join-Path $MyModulePath 'plugins') -Directory | ForEach-Object {
            if (Test-Path (Join-Path $_.FullName "UnLoad.ps1")) {
                Invoke-Command -NoNewScope -ScriptBlock [Scriptblock]::create(".{$(Get-Content -Path (Join-Path $_.FullName "UnLoad.ps1") -Raw)}") -ErrorVariable errmsg 2>$null
            }
        }
    }
}

# Use this in your scripts to check if the function is being called from your module or independantly.
$ThisModuleLoaded = $true

# Non-function exported public module members might go here.
#Export-ModuleMember -Variable SomeVariable -Function  *


