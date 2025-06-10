# load libraries ---------------------------------------------------------------
pacman::p_load(
  tidyverse,
  ggiraph,
  gfonts, # for custom fonts
  gdtools # for custom fonts
)
source(here("R", "label_number.R"))

# setting plots ------------------------
my_palette <- c(
  "#03045e", # federal-blue
  "#023e8a", # marian-blue
  "#0077b6", # honolulu-blue
  "#00b4d8" # pacific-cyan
  # "#90e0ef" # non-photo-blue
)
# register the Figtree font
register_gfont("Figtree")
systemfonts::match_fonts("Figtree")

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
  year = NULL,
  show_text = TRUE,
  show_funds_legend = TRUE,
  ...
) {
  if (!type_plot %in% c("abs", "index_0", "index_t"))
    stop("type_plot must be 'abs' or 'index_0' or 'index_t'")
  var_confronto_title <- var_confronto |>
    str_replace_all("_", " ") |>
    str_to_title()
  if (is.null(year)) year <- unique(df$year)

  # prepare the data for plotting
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
    arrange(
      time
    ) |>
    mutate(
      y = case_when(
        type_plot == "abs" ~ .data[[var_confronto]],
        type_plot == "index_0" ~ .data[[var_confronto]] / first(reserve_math),
        type_plot == "index_t" ~ .data[[var_confronto]] / lag(reserve_math)
      ),
      .by = c(group, year)
    ) |>
    mutate(
      across(year, as.factor),
      time = time / 12,
      label = case_when(
        str_detect(var_confronto, "rate") ~ scales::percent(y, accuracy = .1),
        type_plot == "abs" ~
          number(
            y,
            accuracy = .1,
            # prefix = "€",
            scale_cut = cut_short_scale()
          ),
        type_plot == "index_0" ~ scales::percent(y, accuracy = .1),
        type_plot == "index_t" ~ scales::percent(y, accuracy = .1)
      ),
    ) |>
    # only if var_confronto is not “reserve_math”, “int_rate_f_average” e “int_rate_c_average”
    filter(
      var_confronto %in%
        c("reserve_math", "int_rate_f_average", "int_rate_c_average") |
        time > 0
    ) -> data_graph

  # plotting the data
  plot <-
    ggplot(
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
      text = element_text(family = "Figtree", size = 12),
      # plot.title = element_text(family = "Parkinsans", face = "bold"),
      plot.title = element_text(family = "Figtree", face = "bold"),
      plot.subtitle = element_text(family = "Figtree"),
      axis.title = element_text(family = "Figtree"),
      axis.text = element_text(family = "Figtree"),
      legend.text = element_text(family = "Figtree"),
      legend.title = element_text(family = "Figtree", face = "bold"),
      # remove minor grid lines
      panel.grid.minor = element_blank(),
    )

  if (type_plot == "abs") {
    plot <- plot +
      scale_y_continuous(
        labels = scales::dollar_format(accuracy = 1, prefix = "€")
      ) +
      labs(
        subtitle = "Absolute values"
      )
  } else if (type_plot == "index_0") {
    plot <- plot +
      scale_y_continuous(labels = scales::percent_format(accuracy = .1)) +
      labs(
        subtitle = "Indexed to the first value of the reserve math"
      )
  } else if (type_plot == "index_t") {
    plot <- plot +
      scale_y_continuous(labels = scales::percent_format(accuracy = .1)) +
      labs(
        subtitle = "Indexed to the previous value of the reserve math"
      )
  }

  # set percentage format if var_confronto contains "rate"
  if (str_detect(var_confronto, "rate")) {
    plot <- plot +
      scale_y_continuous(labels = scales::percent_format(accuracy = .1))
  }

  # Add text labels if show_text is TRUE
  if (show_text) {
    plot <- plot +
      ggrepel::geom_text_repel(
        aes(
          label = label,
        ),
        box.padding = 0.5,
        point.padding = 0.5,
        # fill = scales::alpha("white", 0.9),
        # nudge_y = 0.01 * max(data_graph$y, na.rm = TRUE),
        # nudge_x = 0.1,
        # size = 2.8,
        segment.linetype = "dotted",
        segment.color = "grey70",
        segment.size = 0.5,
        verbose = F
        # max.overlaps = 10,
        # max.time = 1,
        # max.iter = 10000,
      )
  }

  # remove the legend for funds if show_funds_legend is FALSE
  if (!show_funds_legend) {
    plot <- plot +
      guides(linetype = "none")
  }

  return(plot)
}

# plot_time_series(
#   data,
#   c("Fondo C", "Fondo E"),
#   "partial_withdrawals_claims",
#   "abs"
# )
# plot_time_series(
#   data,
#   c("Fondo D", "Fondo B"),
#   "partial_withdrawals_claims",
#   "index_t"
# )
# plot_time_series(data, c("Fondo D", "Fondo B"), "partial_withdrawals_claims", "index_t", year = 2023)
# plot_time_series(
#   data,
#   c("Fondo D", "Fondo B"),
#   "partial_withdrawals_claims",
#   "abs",
#   year = c(2023, 2024)
# )
# #
