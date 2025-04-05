# 🔄 Power BI Automation: Capacity Control + Paginated Report Export

Questo repository contiene una soluzione ibrida che combina **Azure Automation Runbook** e **Power Automate Flow** per gestire in modo efficiente i report Power BI impaginati.

---

## 📌 Obiettivo

Automatizzare il processo di:

1. Accensione della capacità Power BI Embedded
2. Esportazione automatica di un **report impaginato** (.RDL)
3. Invio del report esportato via email
4. Arresto della capacità per ottimizzare i costi

---

## 🧩 Architettura


| Step | Componente             | Azione                                                        |
|------|------------------------|----------------------------------------------------------------|
| 1️⃣   | ⏰ Power Automate Flow | Avviato manualmente o tramite schedulazione                   |
| 2️⃣   | ☁️ Azure Runbook       | Accende la capacità Power BI Embedded                         |
| 3️⃣   | 📊 Power BI Service    | La capacità è attiva, il report può essere esportato          |
| 4️⃣   | 📤 Power Automate Flow | Esporta il report impaginato e lo invia via email             |
| 5️⃣   | ☁️ Azure Runbook       | Spegne la capacità Power BI                                   |
| 6️⃣   | ✅ HealthChecks.io     | Registra stato esecuzione (start, success, error)             |


---

## 🛠 Componenti

### 🔁 Azure Runbook

Script PowerShell che:

- Si autentica con App Registration (Service Principal)
- Avvia e arresta una capacità Power BI Embedded
- Invia ping a [HealthChecks.io](https://healthchecks.io) per monitoraggio

### ⚡ Power Automate Flow

- Usa l’azione **"Esporta report impaginato"** (paginated report export)
- Usa un **connettore Outlook / SMTP** per inviare l’email con il PDF allegato
- Può essere schedulato o attivato da Power Apps, bot, SharePoint o altro trigger

---

## 🔐 Configurazione

### 🔐 App Registration

- Registra un'app su Entra ID
- Dai permessi API: `Power BI Service`, `Report.Read.All`, `Capacity.ReadWrite.All`
- Salva `ClientId`, `ClientSecret`, `TenantId` come Automation Variables

### 🔐 Variabili in Azure Automation

| Nome variabile         | Tipo     | Descrizione                                        |
|------------------------|----------|----------------------------------------------------|
| `SP-App-ClientId`      | String   | Client ID App Registration                         |
| `SP-App-ClientSecret`  | String   | Secret app — **criptata**                          |
| `SP-App-TenantId`      | String   | Directory (Tenant) ID                              |
| `Resource-Group`       | String   | Nome del resource group Azure                      |
| `Capacity-Name`        | String   | Nome della capacità Power BI                       |
| `Capacity-Location`    | String   | Regione Azure (es. `Italy North`)                  |
| `HealthCheck-URL`      | String   | Endpoint HealthChecks.io                           |

---

## 📦 Moduli richiesti

- `Az.Accounts`
- `Az.Resources`
- `Az.PowerBIEmbedded`

> Tutti installabili dalla Modules Gallery di Azure Automation.

---

## 💡 Esempi d’uso

- 🔄 Schedulazione giornaliera alle 18:00
- 📩 Invio automatico del report PDF a un gruppo utenti
- 📊 Export automatico verso SharePoint o archivio

---

## 🧪 Monitoraggio

Il Runbook invia notifiche a HealthChecks.io:

- `/start`: inizio esecuzione
- `/fail`: errori
- `/`: completamento con successo

---

## 📤 Deployment rapido

Puoi clonare questo repo ed eseguire lo script PowerShell nel portale Azure Automation.  
Il Flow può essere importato da Power Automate Designer (`.zip`) se incluso.

---

## 📝 Licenza

MIT

---

## 🙌 Contribuisci

Hai idee per migliorare l’integrazione, esportare altri formati o supportare SharePoint/Teams?  
💬 Apri una issue o manda una pull request!
