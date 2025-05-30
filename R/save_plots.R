save_fund_plots <- function(
  data,
  funds,
  vars,
  years,
  show_text,
  width = 8,
  height = 6,
  path = "plots"
) {
  input_combo <- expand.grid(
    fondo = funds,
    var = vars,
    plot_type = c("abs", "index_0", "index_t"),
    stringsAsFactors = FALSE
  )

  total <- nrow(input_combo)

  pwalk(
    input_combo,
    function(fondo, var, plot_type) {
      idx <- which(
        input_combo$fondo == fondo &
          input_combo$var == var &
          input_combo$plot_type == plot_type
      )[1]
      message(
        paste0(
          "[",
          idx,
          "/",
          total,
          "] Stampo grafico: fondo=",
          fondo,
          ", variabile=",
          var,
          ", tipo=",
          plot_type
        )
      )
      fondo_dir <- here::here(path, fondo)
      fs::dir_create(fondo_dir)
      file_name <- paste0(
        var,
        "_",
        plot_type,
        "_",
        paste(years, collapse = "_"),
        ".png"
      )
      tryCatch(
        {
          p <- plot_time_series(
            df = data,
            fondi = fondo,
            var_confronto = var,
            type_plot = plot_type,
            year = years,
            show_text = show_text,
            show_funds_legend = FALSE
          )
          ggsave(
            filename = here::here(path, fondo, file_name),
            plot = p,
            width = width,
            height = height,
            dpi = 300
          )
        },
        error = function(e) {
          showNotification(
            paste0(
              "Errore per fondo: ",
              fondo,
              ", variabile: ",
              var,
              ", tipo: ",
              plot_type,
              ". Il grafico non sarà mostrato."
            ),
            type = "error"
          )
        }
      )
    }
  )
}

# example
# save_fund_plots(
#   data = data,
#   funds = c("Fondo A", "Fondo B"),
#   vars = c("maturities_beg", "partial_withdrawals_claims_beg"),
#   years = c(2023, 2024),
#   show_text = TRUE,
#   width = 10,
#   height = 8,
#   path = "plots"
# )
