### UI code for the time series tab
tab_spiral_anim_ui <- tags$div(
  div(id = "div_spiral_anim",
      fluidRow(tb_spiral_anim_text, align = "center"),
      # Row to house the output plot
      fluidRow(imageOutput('spiral_anim'), align = 'center')
  )
)