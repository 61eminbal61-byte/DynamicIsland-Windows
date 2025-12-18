Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.FormBorderStyle = 'None'
$form.TopMost = $true
$form.ShowInTaskbar = $false
$form.BackColor = [System.Drawing.Color]::FromArgb(5,5,5)
$form.StartPosition = 'Manual'

$kapali = 220
$acik   = 420
$yukseklik = 46

$ekran = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds
$form.Size = New-Object System.Drawing.Size($kapali,$yukseklik)
$form.Location = New-Object System.Drawing.Point(
    [int](($ekran.Width - $kapali)/2), 8
)

function Oval($w){
    $path = New-Object System.Drawing.Drawing2D.GraphicsPath
    $r = $yukseklik
    $path.AddArc(0,0,$r,$r,90,180)
    $path.AddArc($w-$r,0,$r,$r,270,180)
    $path.CloseFigure()
    $form.Region = New-Object System.Drawing.Region($path)
}
Oval $kapali

$etiket = New-Object System.Windows.Forms.Label
$etiket.Dock = 'Fill'
$etiket.ForeColor = [System.Drawing.Color]::White
$etiket.BackColor = [System.Drawing.Color]::Transparent
$etiket.Font = New-Object System.Drawing.Font("Segoe UI Semibold",10)
$etiket.TextAlign = 'MiddleCenter'
$form.Controls.Add($etiket)

$zaman = New-Object System.Windows.Forms.Timer
$zaman.Interval = 1000
$zaman.Add_Tick({
    $saat = Get-Date -Format "HH:mm"
    $bat = Get-WmiObject Win32_Battery -ErrorAction SilentlyContinue
    $pil = if ($bat) { "🔋 $($bat.EstimatedChargeRemaining)%" } else { "🔌 Şarjda" }

    if ($form.Width -gt $kapali) {
        $etiket.Text = "🎵 Müzik Çalıyor     $saat     $pil   🔊"
    } else {
        $etiket.Text = "●     $saat     ●"
    }
})

$acil = {
    for ($i=$kapali; $i -le $acik; $i+=14){
        $form.Width = $i
        $form.Left = [int](($ekran.Width-$i)/2)
        Oval $i
        Start-Sleep -Milliseconds 8
    }
}

$kapan = {
    for ($i=$acik; $i -ge $kapali; $i-=14){
        $form.Width = $i
        $form.Left = [int](($ekran.Width-$i)/2)
        Oval $i
        Start-Sleep -Milliseconds 8
    }
}

$form.Add_MouseEnter($acil)
$form.Add_MouseLeave($kapan)
$etiket.Add_MouseEnter($acil)
$etiket.Add_MouseLeave($kapan)

$zaman.Start()
[System.Windows.Forms.Application]::Run($form)
