### UI code for the time series tab
tab_line_anim_ui <- tags$div(
  div(id = "div_line_anim",
      fluidRow(tb_line_anim_text, align = "center"),
      # Row to house the output plot
      fluidRow(imageOutput('line_anim'), align = 'center')
  )
)