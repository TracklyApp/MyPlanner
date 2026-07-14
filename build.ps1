$planner = Get-Content -LiteralPath 'planner.html' -Raw -Encoding UTF8
$manual  = Get-Content -LiteralPath 'manual.html'  -Raw -Encoding UTF8
$iconSvg = Get-Content -LiteralPath 'icon.svg'     -Raw -Encoding UTF8

function ToBase64Utf8($text) {
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($text)
    return [Convert]::ToBase64String($bytes)
}

$iconB64   = ToBase64Utf8($iconSvg)
$manualB64 = ToBase64Utf8($manual)

# Inline the favicon as a data URI; drop external manifest/apple-touch-icon links
# (this single-file build doesn't ship manifest.json / icon-512.png alongside it)
$planner = $planner -replace '<link rel="icon" type="image/svg\+xml" href="icon\.svg">', "<link rel=`"icon`" type=`"image/svg+xml`" href=`"data:image/svg+xml;base64,$iconB64`">"
$planner = $planner -replace '<link rel="manifest" href="manifest\.json">\r?\n', ''
$planner = $planner -replace '<link rel="apple-touch-icon" href="icon-512\.png">\r?\n', ''

# Drop the service worker registration block (no separate service-worker.js ships with this build)
$planner = $planner -replace '(?s)if \("serviceWorker" in navigator.*?\n\}\r?\n', ''

# Open the manual inside the app instead of linking to the separate manual.html file
$planner = $planner -replace "window\.open\('manual\.html','_blank'\)", 'openManualOverlay()'

# Embed the whole manual as a base64 blob, shown in an isolated iframe (so its CSS/JS can't collide with the app's)
$manualOverlayHtml = @"
<div class="overlay" id="manualOverlay">
  <div class="modal" style="max-width:960px;width:94vw;height:88vh;padding:0;overflow:hidden;display:flex;flex-direction:column">
    <div style="display:flex;justify-content:flex-end;padding:10px 14px;border-bottom:1px solid var(--border)">
      <button class="btn secondary" onclick="closeManualOverlay()">Close</button>
    </div>
    <iframe id="manualFrame" style="flex:1;width:100%;border:none;background:#fff"></iframe>
  </div>
</div>
<script>
const MANUAL_HTML_B64 = "$manualB64";
let manualLoaded = false;
function openManualOverlay(){
  const ov = document.getElementById('manualOverlay');
  if(!manualLoaded){
    const bytes = Uint8Array.from(atob(MANUAL_HTML_B64), c => c.charCodeAt(0));
    document.getElementById('manualFrame').srcdoc = new TextDecoder('utf-8').decode(bytes);
    manualLoaded = true;
  }
  ov.classList.add('show');
}
function closeManualOverlay(){
  document.getElementById('manualOverlay').classList.remove('show');
}
</script>
</body>
"@

$planner = $planner.Replace('</body>', $manualOverlayHtml)

if (!(Test-Path 'dist')) { New-Item -ItemType Directory -Path 'dist' | Out-Null }
$out = 'dist\MyPlanner.html'
Set-Content -LiteralPath $out -Value $planner -Encoding UTF8
Write-Host "Done: $out"
