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
# CONFIRM BEFORE RUN
# =============================
Clear-Host
Write-Host "ALL IN OPTIMIZER PRO"
Write-Host ""
Write-Host "This tool will modify system settings."
Write-Host "Type YES to continue:"
$confirm = Read-Host
if ($confirm -ne "YES") { exit }

# =============================
# CREATE RESTORE POINT
# =============================
Checkpoint-Computer -Description "Before Optimizer" -RestorePointType MODIFY_SETTINGS

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.Text = "ALL IN OPTIMIZER PRO"
$form.Size = New-Object System.Drawing.Size(800,500)
$form.StartPosition = "CenterScreen"
$form.BackColor = "#121212"
$form.ForeColor = "White"

$log = New-Object System.Windows.Forms.TextBox
$log.Multiline = $true
$log.ScrollBars = "Vertical"
$log.Size = New-Object System.Drawing.Size(740,200)
$log.Location = New-Object System.Drawing.Point(20,250)
$log.BackColor = "#0d0d0d"
$log.ForeColor = "Lime"
$form.Controls.Add($log)

function Log($msg){
    $log.AppendText("$msg`r`n")
}

function NewButton($text,$x,$y){
    $btn = New-Object System.Windows.Forms.Button
    $btn.Text = $text
    $btn.Size = New-Object System.Drawing.Size(220,50)
    $btn.Location = New-Object System.Drawing.Point($x,$y)
    $btn.BackColor = "#1f1f1f"
    $btn.ForeColor = "White"
    return $btn
}

# =============================
# GAMING BOOST
# =============================
$btn1 = NewButton "Gaming Boost" 50 50
$btn1.Add_Click({
    Log "Applying Gaming Boost..."
    powercfg -setactive SCHEME_MIN
    reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v SystemResponsiveness /t REG_DWORD /d 0 /f
    reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v NetworkThrottlingIndex /t REG_DWORD /d 4294967295 /f
    Log "Gaming Boost Applied."
})
$form.Controls.Add($btn1)

# =============================
# DEBLOAT SAFE
# =============================
$btn2 = NewButton "Debloat Safe" 300 50
$btn2.Add_Click({
    Log "Removing Xbox / GetHelp..."
    Get-AppxPackage *Xbox* | Remove-AppxPackage
    Get-AppxPackage *GetHelp* | Remove-AppxPackage
    Get-AppxPackage *GetStarted* | Remove-AppxPackage
    Log "Debloat Done."
})
$form.Controls.Add($btn2)

# =============================
# SERVICE OPTIMIZE
# =============================
$btn3 = NewButton "Service Optimize" 50 130
$btn3.Add_Click({
    Log "Disabling SysMain & Search..."
    sc stop SysMain
    sc config SysMain start=disabled
    sc stop WSearch
    sc config WSearch start=disabled
    Log "Services Optimized."
})
$form.Controls.Add($btn3)

# =============================
# VISUAL PERFORMANCE
# =============================
$btn4 = NewButton "Visual Performance" 300 130
$btn4.Add_Click({
    Log "Disabling Animations..."
    reg add "HKCU\Control Panel\Desktop" /v MenuShowDelay /t REG_SZ /d 0 /f
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v DisableAnimations /t REG_DWORD /d 1 /f
    Log "Visual Tweaks Applied."
})
$form.Controls.Add($btn4)

# =============================
# RESTORE DEFAULT
# =============================
$btn5 = NewButton "Restore Default" 175 190
$btn5.Add_Click({
    Log "Restoring Defaults..."
    sc config SysMain start=auto
    sc config WSearch start=auto
    powercfg -setactive SCHEME_BALANCED
    Log "System Restored."
})
$form.Controls.Add($btn5)

$form.Topmost = $true
[void]$form.ShowDialog()
