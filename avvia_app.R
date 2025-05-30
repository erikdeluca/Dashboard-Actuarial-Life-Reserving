# check if here is installed
if (!requireNamespace("here", quietly = TRUE)) {
  install.packages("here")
}
source(here::here("R/install_libraries.R"))
quarto::quarto_preview(
  here::here("app", "ui.qmd"),
)
