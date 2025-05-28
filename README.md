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

1. **Clona o scarica** la repository:
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