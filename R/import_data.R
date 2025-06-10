# file utile per importare i dati, pulirli e prepararli per l'analisi

load_test_data <- function() {
  data_previous_year <- read_delim(
    here("data", "23_test.csv"),
    delim = ","
  )

  data_current_year <- read_delim(
    here("data", "24_test.csv"),
    delim = ","
  )

  bind_rows(
    data_previous_year |>
      mutate(
        year = lubridate::year(Sys.Date()) - 2,
        .before = 1
      ),
    data_current_year |>
      mutate(
        year = lubridate::year(Sys.Date()) - 1,
        .before = 1
      ),
  ) -> data

  data |>
    clean_names() |>
    remove_constant() |>
    mutate(across(where(is.character), as.factor)) -> data

  # fai la media dei scenari
  data |>
    summarise(
      across(
        -task_loop,
        ~ mean(.x, na.rm = TRUE)
      ),
      .by = c(year, group, time, period, t_from, t_to)
    ) -> data

  # store the data
  data |>
    write_delim(
      here("data", "test_merged.csv"),
      delim = ","
    )
}

upload_data <- function(previous_data, new_data_path, year_new_data) {
  message("Importing and reading data")

  # read new data
  new_data <- read_delim(
    new_data_path,
    delim = ",",
    show_col_types = F
  ) |>
    clean_names() |>
    remove_constant() |>
    mutate(
      across(where(is.character), as.factor),
      year = as.numeric(year_new_data)
    ) |>
    summarise(
      across(
        -task_loop,
        ~ mean(.x, na.rm = TRUE)
      ),
      .by = c(year, group, time, period, t_from, t_to)
    ) |>
    # create new column with the sum of "death_claims","disability_claims","surr_claims","partial_withdrawals_claims", "maturities", "ann_claims", "coupon_paid", "expense_ren" and call "capital_dip"
    mutate(
      capital_dip = rowSums(
        pick(
          death_claims,
          disability_claims,
          surr_claims,
          partial_withdrawals_claims,
          maturities,
          ann_claims,
          coupon_paid,
          expense_ren
        ),
        na.rm = TRUE
      )
    )

  if (is.null(previous_data)) {
    message("No previous data found, returning new data")
    showNotification(
      "Nessun dato precedente trovato, i nuovi dati verranno utilizzati",
      type = "message"
    )
    return(new_data)
  }

  # check if the new data doesn't have the same year
  if (any(new_data$year %in% previous_data$year)) {
    warning(
      "The new data has the same year as the previous data, it will be ignored"
    )
    showNotification(
      "I nuovi dati hanno lo stesso anno dei dati precedenti, verranno ignorati",
      type = "error"
    )
    return(previous_data)
  }

  # check if the new data has the same columns as the previous data
  if (!all(names(new_data) %in% names(previous_data))) {
    warning("The new data has different columns than the previous data")
    showNotification(
      "I nuovi dati hanno colonne diverse dai dati precedenti",
      type = "warning"
    )
  }

  message("New data loaded, joining with previous data...")

  # join the new data with the previous data
  bind_rows(
    previous_data,
    new_data
  ) -> data

  return(data)
}

# select the input elements for the mapping
mapping_input_elements <- function(df) {
  mapping_funds <- df |>
    distinct(group) |>
    pull(group) |>
    sort()

  mapping_vars <- df |>
    select(where(is.numeric)) |>
    names()

  mapping_years <- distinct(df, year) |>
    pull(year) |>
    sort()

  return(list(
    funds = mapping_funds,
    vars = mapping_vars,
    years = mapping_years
  ))
}

save_data <- function(data, dir = "data") {
  years <- unique(data$year)
  filename <- paste0("data_", paste(years, collapse = "_"), ".csv")
  filepath <- here::here(dir, filename)
  write_delim(data, filepath, delim = ",")
  message("Data saved to ", filepath)
}

# take 0 rows from the data, on this way the columns are preserved
remove_data <- function(data) {
  slice(data, 0)
}


# load data with separator ";" and save it with ","
change_format_csv <- function(path, new_name) {
  read_delim(
    path,
    delim = ";"
  ) |>
    write_delim(
      new_name,
      delim = ","
    )
}

# change_format_csv("data/test.csv", "24_test.csv")
# change_format_csv("data/test2.csv", "23_test.csv")
