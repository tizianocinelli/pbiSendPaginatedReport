# ================================
# Azure Runbook - Start/Stop Power BI Capacity + HealthChecks
# ================================


# Recupera tutte le variabili di automazione
$clientId           = Get-AutomationVariable -Name "SP-App-ClientId"
$clientSecret       = Get-AutomationVariable -Name "SP-App-ClientSecret"
$tenantId           = Get-AutomationVariable -Name "SP-App-TenantId"
$resourceGroupName  = Get-AutomationVariable -Name "Resource-Group"
$capacityName       = Get-AutomationVariable -Name "Capacity-Name"
$location           = Get-AutomationVariable -Name "Capacity-Location"
$healthCheckUrl     = Get-AutomationVariable -Name "HealthCheck-URL"

# Ping inizio esecuzione
Invoke-WebRequest -Uri "$healthCheckUrl/start" -Method Get -UseBasicParsing

# Costruisce le credenziali
$secureSecret = ConvertTo-SecureString -String $clientSecret -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential($clientId, $secureSecret)

# Connessione ad Azure
try {
    Connect-AzAccount -ServicePrincipal -TenantId $tenantId -Credential $cred -ErrorAction Stop
    Write-Host "✅ Connessione ad Azure riuscita." -ForegroundColor Cyan
} catch {
    $msg = "❌ Connessione ad Azure fallita: $_"
    Write-Host $msg -ForegroundColor Red
    Invoke-WebRequest -Uri "$healthCheckUrl/fail" -Method Post -Body $msg -UseBasicParsing
    exit 1
}

# Avvio capacità
try {
    Write-Host "▶️ Avvio della capacità Power BI: $capacityName..." -ForegroundColor Green
    Resume-AzPowerBIEmbeddedCapacity -Name $capacityName -ResourceGroupName $resourceGroupName -PassThru
} catch {
    $msg = "❌ Errore durante l'avvio della capacità: $_"
    Write-Host $msg -ForegroundColor Red
    Invoke-WebRequest -Uri "$healthCheckUrl/fail" -Method Post -Body $msg -UseBasicParsing
    exit 1
}

# Attendere 5 minuti
Write-Host "⏳ Attendere 5 minuti..." -ForegroundColor Yellow
Start-Sleep -Seconds 300

# Arresto capacità
try {
    Write-Host "⛔ Arresto della capacità Power BI: $capacityName..." -ForegroundColor Red
    Suspend-AzPowerBIEmbeddedCapacity -Name $capacityName -ResourceGroupName $resourceGroupName -PassThru
    Write-Host "✅ Capacità sospesa con successo." -ForegroundColor Green
} catch {
    $msg = "❌ Errore durante l'arresto della capacità: $_"
    Write-Host $msg -ForegroundColor Red
    Invoke-WebRequest -Uri "$healthCheckUrl/fail" -Method Post -Body $msg -UseBasicParsing
    exit 1
}

# Ping successo completato
Invoke-WebRequest -Uri $healthCheckUrl -Method Get -UseBasicParsing

Write-Host "🏁 Operazione completata!"
