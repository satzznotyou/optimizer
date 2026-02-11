# =============================
# AUTO ADMIN
# =============================
if (-not ([Security.Principal.WindowsPrincipal] `
[Security.Principal.WindowsIdentity]::GetCurrent() `
).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)) {

    Start-Process powershell "-ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

# =============================
# CONSENT SCREEN
# =============================
Clear-Host
Write-Host "====================================="
Write-Host "      ALL IN OPTIMIZER PRO"
Write-Host "====================================="
Write-Host ""
Write-Host "This software modifies Windows system settings."
Write-Host "Use at your own risk."
Write-Host ""
Write-Host "Type AGREE to continue:"
$agree = Read-Host
if ($agree -ne "AGREE") { exit }

# =============================
# SAFE RESTORE POINT
# =============================
try {
    Enable-ComputerRestore -Drive "C:\"
    Checkpoint-Computer -Description "Before Optimizer" -RestorePointType MODIFY_SETTINGS
}
catch {}

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.Text = "ALL IN OPTIMIZER PRO v2"
$form.Size = New-Object System.Drawing.Size(900,550)
$form.StartPosition = "CenterScreen"
$form.BackColor = "#121212"
$form.ForeColor = "White"

$log = New-Object System.Windows.Forms.TextBox
$log.Multiline = $true
$log.ScrollBars = "Vertical"
$log.Size = New-Object System.Drawing.Size(840,200)
$log.Location = New-Object System.Drawing.Point(20,320)
$log.BackColor = "#0d0d0d"
$log.ForeColor = "Lime"
$form.Controls.Add($log)

function Log($msg){
    $log.AppendText("$msg`r`n")
}

function NewButton($text,$x,$y){
    $btn = New-Object System.Windows.Forms.Button
    $btn.Text = $text
    $btn.Size = New-Object System.Drawing.Size(250,60)
    $btn.Location = New-Object System.Drawing.Point($x,$y)
    $btn.BackColor = "#1f1f1f"
    $btn.ForeColor = "White"
    return $btn
}

# =============================
# SAFE GAMING BOOST
# =============================
$btn1 = NewButton "SAFE GAMING BOOST" 50 50
$btn1.Add_Click({
    Log "Applying Safe Gaming Boost..."
    powercfg -setactive SCHEME_MIN
    reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v SystemResponsiveness /t REG_DWORD /d 0 /f
    reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v NetworkThrottlingIndex /t REG_DWORD /d 4294967295 /f
    Log "Done."
})
$form.Controls.Add($btn1)

# =============================
# SAFE DEBLOAT
# =============================
$btn2 = NewButton "SAFE DEBLOAT" 350 50
$btn2.Add_Click({
    Log "Removing optional apps..."
    Get-AppxPackage *Xbox* | Remove-AppxPackage
    Get-AppxPackage *GetHelp* | Remove-AppxPackage
    Get-AppxPackage *GetStarted* | Remove-AppxPackage
    Log "Done."
})
$form.Controls.Add($btn2)

# =============================
# SERVICE OPTIMIZE SAFE
# =============================
$btn3 = NewButton "SERVICE OPTIMIZE" 650 50
$btn3.Add_Click({
    Log "Optimizing services..."
    sc stop SysMain
    sc config SysMain start=disabled
    Log "Done."
})
$form.Controls.Add($btn3)

# =============================
# VISUAL PERFORMANCE
# =============================
$btn4 = NewButton "VISUAL PERFORMANCE" 200 150
$btn4.Add_Click({
    Log "Disabling animations..."
    reg add "HKCU\Control Panel\Desktop" /v MenuShowDelay /t REG_SZ /d 0 /f
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v DisableAnimations /t REG_DWORD /d 1 /f
    Log "Done."
})
$form.Controls.Add($btn4)

# =============================
# ADVANCED MODE
# =============================
$btn5 = NewButton "ADVANCED MODE (RISK)" 500 150
$btn5.Add_Click({
    Log "Applying advanced tweaks..."
    sc stop WSearch
    sc config WSearch start=disabled
    Log "Advanced tweaks applied."
})
$form.Controls.Add($btn5)

# =============================
# RESTORE DEFAULT
# =============================
$btn6 = NewButton "RESTORE DEFAULT" 350 230
$btn6.Add_Click({
    Log "Restoring defaults..."
    sc config SysMain start=auto
    sc config WSearch start=auto
    powercfg -setactive SCHEME_BALANCED
    Log "Restored."
})
$form.Controls.Add($btn6)

$form.Topmost = $true
[void]$form.ShowDialog()
