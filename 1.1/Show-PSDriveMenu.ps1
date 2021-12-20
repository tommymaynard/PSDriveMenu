<#PSScriptInfo

.VERSION 1.1

.GUID 7a50aaa2-c265-48ff-a1ab-5247de1f8e63

.AUTHOR tommymaynard

.COMPANYNAME 

.COPYRIGHT 

.TAGS 

.LICENSEURI 

.PROJECTURI 

.ICONURI 

.EXTERNALMODULEDEPENDENCIES 

.REQUIREDSCRIPTS 

.EXTERNALSCRIPTDEPENDENCIES 

.RELEASENOTES


#>

<# 

.DESCRIPTION 
 This advanced function creates a menu of the drives in the current session, indicates the current drive with a marker, and allow you to set a different location from a text-based menu. 

#> 
Param()

Function Show-PSDriveMenu {
<#
.SYNOPSIS
    This advanced function creates a menu of the drives in the current session, indicates the current drive with a marker, and allow you to set a different location from a text-based menu.
.EXAMPLE
    This example displays changing the drive location from the C:\ drive, to HKCU Registry drive, and then to the Variable drive with two sequential invocations.
    PS C:\> Show-PSDriveMenu
     [ 1] Alias
    >[ 2] C
     [ 3] Cert
     [ 4] D
     [ 5] Env
     [ 6] Function
     [ 7] HKCU
     [ 8] HKLM
     [ 9] IDI
     [10] IDT
     [11] S
     [12] Variable
     [13] WSMan
     [14] [Exit]
     Choose a PSDrive: 7
    PS HKCU:\> Show-PSDriveMenu
     [ 1] Alias
     [ 2] C
     [ 3] Cert
     [ 4] D
     [ 5] Env
     [ 6] Function
    >[ 7] HKCU
     [ 8] HKLM
     [ 9] IDI
     [10] IDT
     [11] S
     [12] Variable
     [13] WSMan
     [14] [Exit]
     Choose a PSDrive: 12
    PS Variable:\>
.NOTES
    Name: Show-PSDriveMenu
    Author: Tommy Maynard
    Comments: --
    Last Edit: 08/14/2018 [1.0], 08/28/2018 [1.1]
    Version 1.0
    Version 1.1
        - Corrected assignment for $CurrentLocation variable inside Begin block:
        -- WAS: $CurrentLocation = (Get-Location).Path
        -- IS : $CurrentLocation = "$((Get-Location).Drive.Name):\"
#>
    [CmdletBinding()]
    Param()

    Begin {
        #region Set variables.
        Write-Verbose -Message 'Setting variables.'
        $Drives = Get-PSDrive
        $CurrentLocation = "$((Get-Location).Drive.Name):\"
        #endregion.
    }

    Process {
        #region Create PSDrive menu.
        Write-Verbose -Message 'Creating PSDrive menu.'
        For ($i = 1; $i -lt $Drives.Count; $i++) {
            If ($CurrentLocation -eq "$(($Drives[$i]).Name):\") {
                $Here = '>'
            } Else {
                $Here = ' '
            }
            # Manage numeric spacing.
            If ($i.ToString().Length -eq 1) {
                "$Here[ $i] $(($Drives[$i]).Name)"
            } Else {
                "$Here[$i] $(($Drives[$i]).Name)"
            }
            Remove-Variable -Name Here -ErrorAction SilentlyContinue
        } # End For.
        " [$i] [Exit]"
        #endregion

        #region Choose PSDrive menu option.
        Write-Verbose -Message 'Checking for valid menu option.'
        Do {
            $MenuOption = Read-Host -Prompt ' Choose PSDrive'
        } Until (
            ($MenuOption -in (1..$Drives.Count))
        ) # End Do-Until.
        #endregion.

        #region Change drive location.
        If ($MenuOption -eq $i) {
            Write-Verbose -Message 'Exiting.'
            break
        } Else {
            Write-Verbose -Message "Changing to the $($Drives[$MenuOption].Name):\ drive."
            Set-Location -Path "$($Drives[$MenuOption].Name):\"
        } # End If.
        #endregion
    } # End Process.

    End {} # End End.
} # End Function: Show-PSDriveMenu.