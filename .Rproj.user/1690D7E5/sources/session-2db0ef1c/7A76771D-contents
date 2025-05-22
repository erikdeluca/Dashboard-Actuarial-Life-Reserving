# setting plots ------------------------
my_palette <- c(
  "#03045e", # federal-blue
  "#023e8a", # marian-blue
  "#0077b6", # honolulu-blue
  "#00b4d8" # pacific-cyan
  # "#90e0ef" # non-photo-blue
)

# funzione per selezionare i colori della palette più distanti tra loro
pick_palette <- function(palette, n, reverse = T) {
  idx <- switch(
    as.character(n),
    '1' = c(1),
    '2' = c(1, length(palette)),
    '3' = c(1, ceiling(length(palette) / 2), length(palette)),
    {
      seq(1, length(palette), length.out = n) |> round() |> unique()
    }
  )
  palette[sort(idx, decreasing = reverse)]
}


# plot --------------------------------------------
# Plotting functions for the values in absolute value or indexed
plot_time_series <- function(
  df,
  fondi = c("Fondo A", "Fondo B"),
  var_confronto = "partial_withdrawals_claims",
  type_plot = "abs",
  year = NULL
) {
  if (!type_plot %in% c("abs", "index_0", "index_t"))
    stop("type_plot must be 'abs' or 'index_0' or 'index_t'")
  var_confronto_title <- var_confronto |>
    str_replace_all("_", " ") |>
    str_to_title()
  if (is.null(year)) year <- unique(df$year)

  df |>
    select(
      year,
      group,
      time,
      reserve_math,
      all_of(var_confronto),
    ) |>
    filter(
      group %in% fondi,
      year %in% !!year
    ) |>
    mutate(
      across(year, as.factor),
      time = time / 12,
      y = case_when(
        type_plot == "abs" ~ .data[[var_confronto]],
        type_plot == "index_0" ~ .data[[var_confronto]] / first(reserve_math),
        type_plot == "index_t" ~ .data[[var_confronto]] / lag(reserve_math)
      )
    ) |>
    filter(time > 0) -> data_graph

  plot <- ggplot(
    data_graph,
    aes(
      x = time,
      y = y,
      color = year,
      linetype = group,
      group = interaction(year, group)
    )
  ) +
    geom_line() +
    scale_color_manual(
      name = "Year",
      values = pick_palette(my_palette, length(year)),
      labels = year
    ) +
    scale_linetype(
      name = "Funds",
    ) +
    labs(
      x = "",
      y = "",
      title = paste0(
        "Time Series of ",
        var_confronto_title,
        " for ",
        paste(fondi, collapse = ", ")
      )
    ) +
    theme_minimal(base_family = "Figtree") +
    theme(
      legend.position = "bottom",
      plot.title = element_text(family = "Parkinsans", face = "bold"),
      plot.subtitle = element_text(family = "Figtree"),
      axis.title = element_text(family = "Figtree"),
      axis.text = element_text(family = "Figtree"),
      legend.text = element_text(family = "Figtree"),
      legend.title = element_text(family = "Parkinsans", face = "bold")
    )

  if (type_plot == "abs") {
    plot <- plot +
      scale_y_continuous(
        labels = scales::dollar_format(accuracy = 1, prefix = "€")
      ) +
      labs(
        subtitle = "Absolute values"
      )
  } else {
    plot <- plot +
      scale_y_continuous(labels = scales::percent_format(accuracy = 1))
  }

  return(plot)
}

# plot_time_series(data, c("Fondo D", "Fondo B"), "partial_withdrawals_claims", "abs")
# plot_time_series(data, c("Fondo D", "Fondo B"), "partial_withdrawals_claims", "index_0")
# plot_time_series(data, c("Fondo D", "Fondo B"), "partial_withdrawals_claims", "index_t", year = 2023)
# plot_time_series(data, c("Fondo D", "Fondo B"), "partial_withdrawals_claims", "index_t", year = 2023)
