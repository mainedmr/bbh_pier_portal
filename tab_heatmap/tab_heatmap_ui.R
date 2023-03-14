### UI code for the time series tab
tab_heatmap_ui <- tags$div(
  div(id = "div_heatmap",
      fluidRow(h1("Heatmap"), align = "center"),
      fluidRow(align = 'center',
        radioGroupButtons(
          inputId = 'heatmap_var',
          label = 'Plot:',
          choices = c('Actual', 'Change from Baseline'),
          status = 'success'
        )
      ),
      # Slider for baseline years - needs to be in a div to toggle on/off
      div(id = 'div_heatmap_baseline',
        fluidRow(align = "center",
                 # Define the date range selector, setting initial value to
                 # min/max of input data
                 sliderInput("sel_baseline", "Set baseline year range", 
                             min = year_min, max = year_max,
                             value = c(1991, 2020), sep = '')
        )
      ),
      # Row to house the output plot
      fluidRow(
        plotOutput('heatmap_plot')
      )
  )
)