### UI code for the time series tab
tab_ytd_ui <- tags$div(
  div(id = "div_ytd",
      fluidRow(tb_ytd_text, align = "center"),
      # Row for the filter conditions
      fluidRow(align = "center",
        # Define the date range selector, setting initial value to
        # min/max of input data
        sliderInput("sel_ytd_baseline", "Set baseline year range", 
                    min = year_min, max = year_max,
                    value = c(1991, 2020), sep = '')
      ),
      # Row to house the output plot
      fluidRow(
        plotOutput('ytd_plot')
      )
  )
)