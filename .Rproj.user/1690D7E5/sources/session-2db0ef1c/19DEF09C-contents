pacman::p_load(
  tidyverse,
  here,
  janitor,
  patchwork # for combining plots
)

# Load the data
df <- read_delim(here("data", "test.csv"), delim = ";")

# apply noise to the data and save as "test2.csv"
# don't apply the noise to task_loop, time, t_from and t_to
df |>
  select(-c(task_loop, time, t_from, t_to, disc_rate)) |>
  mutate(across(
    where(is.numeric),
    ~ 1.1 * .x + rnorm(length(.x), mean = 0, sd = 1 * abs(.x))
  )) |>
  bind_cols(
    df |>
      select(task_loop, time, t_from, t_to)
  ) |>
  write_delim(here("data", "test2.csv"), delim = ";")

# clean the data with janitor
df |>
  clean_names() |>
  remove_empty() |>
  remove_constant() |>
  mutate(across(where(is.character), as.factor)) -> df

# Check the data
df |>
  glimpse()

# plot reserve by group and time
# df |>
#   select(reserve_math, death_claims, group, time, task_loop) |>
#   summarise(
#     reserve_math = mean(reserve_math, na.rm = TRUE),
#     reserve_ph = mean(reserve_ph, na.rm = TRUE),
#     .by = c("group", "time")
#   ) |>
#   pivot_longer(
#     starts_with("reserve"),
#     names_to = "reserve_type",
#     values_to = "reserve"
#   ) |>
#   replace_na(list(reserve = 0)) |>
#   ggplot(aes(x = time, y = reserve)) +
#   geom_line() +
#   # facet_wrap(~ reserve_type, scales = "free") +
#   facet_grid(rows = vars(group), cols = vars(reserve_type), scales = "free") +
#   theme_minimal()
#
# # plot reserve by group and time
# df |>
#   select(reserve_math, death_claims, group, time, task_loop) |>
#   filter(
#     group %in% "Fondo A",
#     task_loop == 1
#   ) |>
#   ggplot(aes(x = time / 12, y = reserve_math)) +
#   geom_line()

plot_time_series_old <- function(
  df,
  fondi = c("Fondo A", "Fondo B"),
  var_confronto = "partial_withdrawals_claims",
  task_loop_sel = 1
) {
  data_graph <- df %>%
    select(
      reserve_math,
      group,
      time,
      task_loop,
      !!sym(var_confronto)
    ) %>%
    filter(
      group %in% fondi,
      task_loop == task_loop_sel
    ) %>%
    mutate(
      tasso_base_fissa = !!sym(var_confronto) / first(reserve_math),
      tasso_base_mobile = !!sym(var_confronto) / lag(reserve_math)
    ) %>%
    filter(time > 0) %>%
    pivot_longer(
      starts_with("tasso"),
      names_to = "tasso_type",
      values_to = "tasso"
    )

  p1 <- ggplot(
    data_graph,
    aes(
      x = time / 12,
      y = .data[[var_confronto]],
      color = group
    )
  ) +
    geom_line() +
    scale_y_continuous(
      labels = scales::dollar_format(accuracy = 1, prefix = "€")
    ) +
    theme_minimal() +
    theme(legend.position = "none") +
    scale_color_brewer(
      palette = "Set1",
      labels = fondi
    ) +
    labs(
      x = "",
      y = "Amount",
    )

  p2 <- ggplot(
    data_graph,
    aes(
      x = time / 12,
      y = tasso,
      color = group
    )
  ) +
    facet_grid(vars(tasso_type), scales = "free") +
    geom_line() +
    theme_minimal() +
    scale_color_brewer(
      palette = "Set1",
      labels = fondi
    ) +
    scale_y_continuous(labels = scales::percent_format(accuracy = 1)) +
    theme(legend.position = "bottom") +
    labs(
      x = "Time (years)",
      y = "Index"
    )

  p1 /
    p2 +
    plot_annotation(
      title = var_confronto |> str_replace_all("_", " ") |> str_to_title(),
      subtitle = paste(fondi, collapse = " vs "),
    )
}

plot_time_series_old(
  df,
  fondi = c("Fondo D", "Fondo B"),
  var_confronto = "partial_withdrawals_claims",
  task_loop_sel = 3
)
