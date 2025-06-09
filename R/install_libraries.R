# Lista delle librerie richieste
required_packages <- c(
  "tidyverse",
  "here",
  "janitor",
  "patchwork",
  "shiny",
  "shinyjs",
  "shinycssloaders",
  "shinyWidgets",
  "bslib",
  "sass",
  "waiter",
  "ggiraph",
  "gfonts",
  "gdtools",
  "quarto",
  "plyr"
)

# Installa i pacchetti mancanti
installed_packages <- rownames(installed.packages())
to_install <- setdiff(required_packages, installed_packages)

if (length(to_install) > 0) {
  install.packages(to_install)
}

# Carica tutte le librerie
lapply(required_packages, library, character.only = TRUE)
