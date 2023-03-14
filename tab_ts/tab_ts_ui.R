### UI code for the time series tab
tab_ts_ui <- tags$div(
  div(id = "div_ts",
      fluidRow(h1("Historic Temperature Data"), align = "center"),
      # Row for the filter conditions
      fluidRow(align = "center",
        # Define the date range selector, setting initial value to
        # min/max of input data
        sliderInput("sel_years", "Filter by Year Range", 
                    min = year_min, max = year_max,
                    value = c(year_min, year_max), sep = '', animate = T)
      ),
      fluidRow(align = 'center',
        radioGroupButtons(
          inputId = 'ts_groupby',
          label = 'Group by:',
          choices = c('None', 'Month', 'Oceanic Season', 
                      'Meteorological Season', 'Astronomical Season'),
          status = 'success'
        )
      ),
      # Row to house the output plot
      fluidRow(
        plotOutput('ts_plot')
      )
  )
)