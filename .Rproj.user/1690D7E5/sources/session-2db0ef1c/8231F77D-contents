# server <- function(input, output, session) {
server <- function(input, output, session) {
  data <- reactiveVal(data)
  mapping <- reactiveVal()

  observeEvent(input$load_button, {
    # show the loading screen
    # waiter_show(html = spin_1())

    req(input$file, input$year_input)
    message(paste0(
      "Loading data from file: ",
      input$file$name,
      " for year: ",
      input$year_input
    ))
    showNotification("Caricando i dati", type = "message")

    # carica i dati e uniscili con i vecchi
    new_data <- upload_data(data(), input$file$datapath, input$year_input)
    data(new_data)

    # update the mapping of the input elements
    new_mapping <- mapping_input_elements(new_data)
    mapping(new_mapping)

    # Aggiorna le selectizeInput con i nuovi choices
    updateSelectizeInput(
      session,
      "funds",
      choices = mapping()$funds,
      selected = mapping()$funds[1]
    )
    updateSelectizeInput(
      session,
      "var_to_analyze",
      choices = mapping()$vars,
      selected = "partial_withdrawals_claims"
    )
    updateSelectizeInput(
      session,
      "years",
      choices = mapping()$years,
      selected = mapping()$years
    )

    showNotification("Dati caricati con successo!", type = "message")
    #
    #     # hide the loading screen
    #     waiter_hide()
  })

  # avoid errors during loading file and selecting year
  observeEvent(input$file, {
    disable("year_input")
  })
  observe({
    if (!is.null(input$file)) {
      enable("year_input")
    }
  })

  # save the data
  observeEvent(input$save_button, {
    req(data())
    save_data(data())
    showNotification("Dati salvati!", type = "message")
  })

  # delete the data
  observeEvent(input$delete_button, {
    data(remove_data(data()))
    showNotification("Dati eliminati!", type = "warning")
  })

  # save the plots
  observeEvent(input$print_button, {
    showNotification("Salvando i grafici", type = "message")
    funds <- input$funds_print
    vars <- if (input$all_vars) mapping$vars else input$var_to_analyze_print
    years <- input$years_print
    type_plot <- input$type_plot
    show_text <- input$show_text_in_plot
    width <- input$plot_width
    height <- input$plot_height

    save_fund_plots(
      data = data(),
      funds = funds,
      vars = vars,
      years = years,
      show_text = show_text,
      width = width,
      height = height,
      path = "plots"
    )
    showNotification(
      "Grafici salvati nelle cartelle dei fondi!",
      type = "message"
    )
  })

  # render the plot
  output$plot <- renderPlot({
    req(data())
    plot_time_series(
      data(),
      input$funds,
      input$var_to_analyze,
      input$type_plot,
      input$years,
      input$show_text_in_plot
    ) -> plot
    plot(plot)
  })
}
