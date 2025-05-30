# Dashboard Actuarial Life Reserving

Applicazione **Shiny + Quarto** per la visualizzazione e gestione di dati attuariali sui flussi.

[Repository GitHub](https://github.com/erikdeluca/Dashboard-Actuarial-Life-Reserving)

---

## Requisiti

- **R** (versione ≥ 4.0 consigliata)
- **Quarto** installato ([Guida ufficiale](https://quarto.org/docs/get-started/))
- I seguenti pacchetti R (puoi installarli tutti con pacman):

```r
pacman::p_load(
  tidyverse,
  ggiraph,
  gfonts,
  gdtools,
  here,
  janitor,
  patchwork,
  shiny,
  shinyjs,
  shinycssloaders,
  shinyWidgets,
  bslib,
  sass,
  waiter
)
```

---

## Avvio rapido

1. **Clona o scarica** la repository (per clonarla bisogna avere [Git](https://git-scm.com/downloads) installato): 
   ```
   git clone https://github.com/erikdeluca/Dashboard-Actuarial-Life-Reserving.git
   ```
2. **Apri R** o **RStudio** nella cartella del progetto.
3. **Installa i pacchetti mancanti** con il comando sopra.
4. **Lancia l’app** eseguendo il file `avvia_app.R`:
   ```r
   source("avvia_app.R")
   ```
   L’app si aprirà automaticamente nel browser!

---

## Aggiunta dati

### Dati pre-caricati

All'avvio dell'app, R proverà a caricare i dati presenti nel file `data/dati_precaricati.csv`.
Per aggiungere i tuoi dati:

1. Crea un file CSV con i tuoi dati attuariali.
2. Salvalo nella cartella `data/` con il nome `dati_precaricati.csv`.
3. Assicurati che il file abbia le colonne corrette:
   - `year` (Anno del flusso)
   - `group` (Fondo di appartenenza del flusso)
   - `time` (Tempo del flusso in mesi)
   - `period` (Etichetta del tempo)
   - `t_from` (Tempo di inizio del flusso)
   - `t_to` (Tempo di fine del flusso)

In alternativa, puoi avviare l'app senza dati pre-caricati e caricarli manualmente tramite l'interfaccia.
Inoltre, tramite l'app puoi salvare il dataset di lavoro in un file CSV per usi futuri.

### Dati aggiunti tramite l'interfaccia

Puoi aggiungere nuovi flussi direttamente dall'interfaccia dell'app.

1. Assicurati che il file sia in formato CSV con delimitatore `,` (virgola).
2. Assicurati che il file abbia le colonne corrette (`year` viene inserito da input):
   - `group` (Fondo di appartenenza del flusso)
   - `time` (Tempo del flusso in mesi)
   - `period` (Etichetta del tempo)
   - `t_from` (Tempo di inizio del flusso)
   - `t_to` (Tempo di fine del flusso)
3. Vai alla sezione "Gestione dati" e seleziona il file CSV da caricare.
4. Aspetta che il file sia caricato e seleziona l'anno di riferimento del file.
5. Clicca su "Carica il file".

## Struttura del progetto

- `app/ui.qmd` — Dashboard principale Quarto
- `app/global.qmd` — Configurazione globale dell’app
- `app/server.qmd` — Logica del server per l’app Shiny
- `avvia_app.R` — Script per l’avvio rapido dell’app
- `www/` — Risorse statiche per la personalizzazione dell’app
- `data/` — Cartella per i dati (formato CSV)
- `R/` — Funzioni R per l'app
- `plots/` — Grafici generati dall'app
- `LICENSE` — Licenza per il progetto

---

## Note

- Per domande o bug, apri una issue su GitHub

---