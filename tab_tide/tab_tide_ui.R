### UI code for the tide tab
tab_tide_ui <- tags$div(
  div(id = "div_tide",
      fluidRow(tb_tide_text, align = "center"),
      fluidRow(align = 'center',
        # Tidal datum selector
        selectizeInput('tide_datum', 'Tidal Datum',
                       choices = unique(tidal_datums$datum),
                       selected = 'NAVD88'),
        # Tide date range selector
        dateRangeInput('tide_dates', 'Tide Date Range',
          start = Sys.Date() - lubridate::weeks(),
          end = Sys.Date(),
          min = tide_min_date,
          max = Sys.Date())
      ),
      # Row to house the output plot
      fluidRow(
        plotly::plotlyOutput('tide_plot')
      )
  )
)