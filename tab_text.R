#### Build text for tags in here to avoid cluttering up ui files

tb_ts_text <- tagList(
  h3('Historic Temperature Time Series'),
  paste0(
    'This tab displays the historic temperature time series for the ',
    ' BBH Environmental Monitoring Station. The time series can be filtered to',
    ' a year range using the slider.'
  ),
  br(), br(),
  'For the data shown, the linear trend is shown as the blue line.',
  br(), br(),
  paste0(
    'The temperature series can be grouped by month and season to illustrate the',
    ' trend per season.'
  ),
  br(), br(),
  'Which months/seasons indicate the strongest warming trend?',
  br()
)

tb_heatmap_text <- tagList(
  h3('Heatmap'),
  paste0(
    'This tab displays temperature as a heatmap. Each square in the map represents',
    ' the temperature on a single day.'
  ),
  br(), br(),
  paste0(
    'The temperature can also be mapped as the difference from a baseline average',
    ' for each day by choosing "Change from Baseline". When this option is active,',
    ' a slider to choose the baseline average period appears.',
    ' TODO: dropdown to choose different baseline ranges (US/EU/etc)'
  )
)

tb_line_anim_text <- tagList(
  h3('Line Animation'),
  paste0(
    'The animation below shows the monthly average temperature as a cumulative ',
    ' line plot.'
  ),
  br(), br(),
  'Which years appear the warmest in this animation?'
)