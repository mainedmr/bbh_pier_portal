### UI code for the time series tab
tab_rt_ui <- tags$div(
  div(id = 'div_rt',
      fluidRow(tb_rt_text, align = 'center'),
      # Row to house the output plot
      fluidRow(
        valueBoxOutput('val_time', width = 4),
        valueBoxOutput('val_sst', width = 2),
        valueBoxOutput('val_air_temp', width = 2),
        valueBoxOutput('val_pressure', width = 2),
        valueBoxOutput('val_rh', width = 2)
      ),
      fluidRow(
        h3('Hourly Data from the Past Week', align = 'center')
      ),
      fluidRow(
        # Place holder to render a dropdown for fields in the RT data
        uiOutput('ui_rt_field')
      ),
      fluidRow(
        plotly::plotlyOutput('rt_weekly', height = gbl_plot_height)
      )
  )
)