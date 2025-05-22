# load libraries ---------------------------------------------------------------
pacman::p_load(
  tidyverse,
  here,
  janitor,
  patchwork, # for combining plots
  shiny, # for the app
  shinyjs,
  shinycssloaders,
  # shinydashboard,
  shinyWidgets,
  bslib,
  sass,
  waiter # for loading screen
)

sass(
  input = sass_file("www/styles.scss"),
  output = "www/sass-styles.css",
  options = sass_options(output_style = "compressed") # OPTIONAL, but speeds up page load time by removing white-space & line-breaks that make css files more human-readable
)

# set the max file size to 1 GB
options(shiny.maxRequestSize = 1000 * 1024^2)

# thematic::thematic_shiny(
#   font = thematic::font_spec(
#     families = c("Figtree", "sans-serif"),
#     scale = 3
#   ),
#   fg = "#003459",
#   bg = "#ffffff",
#   accent = "#0077b6",
#   sequential = c("#03045e", "#023e8a", "#0077b6", "#00b4d8", "#90e0ef")
# )

# load functions ---------------------------------------------------------------
source(here("R", "import_data.R"))
source(here("R", "plots.R"))


# load data ---------------------------------------------------------------
# carica i dati dalla cartella data, questo lo fa all'avvio dell'app.
# In modo da evitare di caricare ogni volta i dati.
# In alternativa si caricheranno attraverso l'apposita maschera
data <- read_delim(
  here("data", "test_merged.csv"),
  delim = ";"
)


# mapping input elements ---------------------------------------------------------------
mapping <- mapping_input_elements(data)
