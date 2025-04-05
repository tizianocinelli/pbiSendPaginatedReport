# ⚡ Power Automate Flow - Paginated Report Export

Questo Flow esporta un **report impaginato Power BI (RDL)** e lo invia via email come file PDF.

## 📦 Importazione

1. Vai su [Power Automate](https://make.powerautomate.com/)
2. Clicca su **"Import"** (barra laterale sinistra)
3. Carica il file `PaginatedReportFlow.zip`
4. Configura i connettori richiesti:
   - Power BI (con permessi su report impaginati)
   - Outlook / SMTP / Gmail per l'invio dell'email

## 🔐 Note

- Il Flow richiede che la **capacità Power BI sia attiva (accesa)** (gestita dal Runbook)
- Può essere collegato al Runbook tramite webhook (se licenza premium di Power Automate) o eseguito separatamente

## 💡 Idee

- Se si vuole dare all'utente la possibilità di eseguire il tutto in autonomia è necessaria la licenza di Power Automate premium, in modo che l'utente possa scatenare il flow autonomamente che va a chiamare anche l'Azure Runbook per l'accensione e lo spegnimento.
