# Mapa Limpio - ver la app en el celular por wifi
# Levanta un servidor web chiquito en esta compu y muestra un QR para abrirlo desde el celular.
# El celular tiene que estar conectado al MISMO wifi que la compu.

$ErrorActionPreference = 'Stop'
$root = [IO.Path]::GetFullPath((Split-Path -Parent $MyInvocation.MyCommand.Path)).TrimEnd('\') + '\'

# IP de esta compu en la red local (la placa que tiene salida a internet)
$ip = $null
try { $ip = (Get-NetIPConfiguration | Where-Object { $_.IPv4DefaultGateway -and $_.NetAdapter.Status -eq 'Up' } | Select-Object -First 1).IPv4Address.IPAddress } catch {}
if (-not $ip) {
  $ip = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.IPAddress -notlike '127.*' -and $_.IPAddress -notlike '169.254.*' } | Select-Object -First 1).IPAddress
}
if (-not $ip) { Write-Host 'No encontre la conexion wifi de esta compu. Conectate a un wifi y proba de nuevo.' -ForegroundColor Red; exit 1 }
if ($ip -is [array]) { $ip = $ip[0] }

# Primer puerto libre entre 8080 y 8090
$listener = $null
foreach ($p in 8080..8090) {
  try { $listener = [System.Net.Sockets.TcpListener]::new([System.Net.IPAddress]::Any, $p); $listener.Start(); $port = $p; break } catch { $listener = $null }
}
if (-not $listener) { Write-Host 'No hay ningun puerto libre (8080-8090).' -ForegroundColor Red; exit 1 }

$url = "http://${ip}:${port}/"

# Pagina con el QR (se abre en esta compu)
$qrImg = 'https://api.qrserver.com/v1/create-qr-code/?size=360x360&margin=10&data=' + [Uri]::EscapeDataString($url)
$qrHtml = @"
<!DOCTYPE html><html lang="es"><head><meta charset="utf-8"><title>Mapa Limpio - Abrir en el celular</title>
<style>body{font-family:Segoe UI,Arial,sans-serif;background:#064e3b;color:#fff;display:flex;align-items:center;justify-content:center;min-height:100vh;margin:0}
.c{background:#fff;color:#0f172a;border-radius:20px;padding:28px 32px;text-align:center;max-width:440px;box-shadow:0 10px 40px rgba(0,0,0,.3)}
h1{margin:0 0 4px;font-size:22px;color:#064e3b}img{width:300px;height:300px;margin:14px 0;border-radius:8px}
.u{font:600 18px Consolas,monospace;background:#f1f5f9;border-radius:8px;padding:8px 12px;display:inline-block}
ol{text-align:left;font-size:14px;color:#334155;padding-left:20px}p.n{font-size:12px;color:#64748b}</style></head>
<body><div class="c"><h1>Abrir Mapa Limpio en el celular</h1>
<div style="color:#64748b;font-size:14px">Escane&aacute; el QR con la c&aacute;mara del celular</div>
<img src="$qrImg" alt="QR" onerror="this.style.display='none'">
<div class="u">$url</div>
<ol><li>El celular tiene que estar en el <b>mismo wifi</b> que esta compu.</li>
<li>Abr&iacute; la c&aacute;mara, apunt&aacute; al QR y toc&aacute; el link que aparece.</li>
<li>Si no abre, escrib&iacute; la direcci&oacute;n de arriba en Chrome del celular.</li></ol>
<p class="n">Dej&aacute; abierta la ventana negra mientras lo us&aacute;s. Por wifi local el GPS del celular no funciona (el navegador lo exige con https): mov&eacute; el mapa con el dedo. Con el link de GitHub s&iacute; funciona.</p></div></body></html>
"@
$qrFile = Join-Path $env:TEMP 'mapa-limpio-qr.html'
[IO.File]::WriteAllText($qrFile, $qrHtml, [Text.Encoding]::UTF8)
Start-Process $qrFile

Clear-Host
Write-Host ''
Write-Host '  MAPA LIMPIO - VER EN EL CELULAR' -ForegroundColor Green
Write-Host '  ================================'
Write-Host ''
Write-Host '  Escanea el QR que se abrio en el navegador, o escribi en el celular:'
Write-Host ''
Write-Host "     $url" -ForegroundColor Yellow
Write-Host ''
Write-Host '  - El celular tiene que estar en el MISMO wifi que esta compu.'
Write-Host '  - Si Windows pregunta por el Firewall, toca "Permitir acceso".'
Write-Host '  - NO cierres esta ventana mientras lo uses. Para terminar: cerrala.'
Write-Host ''
Write-Host '  Pedidos del celular:' -ForegroundColor DarkGray

$mime = @{
  '.html' = 'text/html; charset=utf-8'; '.htm' = 'text/html; charset=utf-8'; '.js' = 'application/javascript; charset=utf-8'
  '.css' = 'text/css; charset=utf-8'; '.json' = 'application/json; charset=utf-8'; '.md' = 'text/plain; charset=utf-8'
  '.png' = 'image/png'; '.jpg' = 'image/jpeg'; '.jpeg' = 'image/jpeg'; '.svg' = 'image/svg+xml'; '.ico' = 'image/x-icon'; '.webp' = 'image/webp'
}

while ($true) {
  $client = $listener.AcceptTcpClient()
  try {
    $stream = $client.GetStream()
    $stream.ReadTimeout = 5000
    $reader = [System.IO.StreamReader]::new($stream, [Text.Encoding]::ASCII, $false, 4096, $true)
    $line = $reader.ReadLine()
    while ($true) { $h = $reader.ReadLine(); if ($null -eq $h -or $h -eq '') { break } }  # salteamos los encabezados

    $path = '/'
    if ($line -match '^(GET|HEAD) (\S+)') { $path = $Matches[2] }
    $path = [Uri]::UnescapeDataString(($path -split '\?')[0])
    if ($path -eq '/') { $path = '/index.html' }

    $file = [IO.Path]::GetFullPath((Join-Path $root ($path.TrimStart('/') -replace '/', '\')))
    # Solo archivos de esta carpeta, y nunca archivos ocultos como .git
    $ok = $file.StartsWith($root, [StringComparison]::OrdinalIgnoreCase) -and ($path -notmatch '/\.') -and (Test-Path -LiteralPath $file -PathType Leaf)
    if ($ok) {
      $body = [IO.File]::ReadAllBytes($file); $status = '200 OK'
      $type = $mime[[IO.Path]::GetExtension($file).ToLower()]; if (-not $type) { $type = 'application/octet-stream' }
    } else {
      $body = [Text.Encoding]::UTF8.GetBytes('No encontrado'); $status = '404 Not Found'; $type = 'text/plain; charset=utf-8'
    }
    $head = [Text.Encoding]::ASCII.GetBytes("HTTP/1.1 $status`r`nContent-Type: $type`r`nContent-Length: $($body.Length)`r`nCache-Control: no-cache`r`nConnection: close`r`n`r`n")
    $stream.Write($head, 0, $head.Length)
    if ($line -notmatch '^HEAD') { $stream.Write($body, 0, $body.Length) }
    Write-Host ("  {0}  {1}  {2}" -f (Get-Date -Format 'HH:mm:ss'), $status.Split(' ')[0], $path) -ForegroundColor DarkGray
  } catch {
    # pedido cortado o vacio: lo ignoramos
  } finally {
    $client.Close()
  }
}
