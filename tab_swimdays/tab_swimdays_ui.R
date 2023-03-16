### UI code for the time series tab
tab_swimdays_ui <- tags$div(
  div(id = "div_swimdays",
      fluidRow(tb_swimdays_text, align = "center"),
      # Row for the filter conditions
      fluidRow(align = "center",
        sliderInput("sel_swim_thresh", "Select minimum swimming temperature (F):", 
                    min = 32, max = 80, value = 60)
      ),
      # Row to house the output plot
      fluidRow(
        plotOutput('swimdays_plot')
      )
  )
)