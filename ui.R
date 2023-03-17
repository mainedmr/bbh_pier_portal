library(shiny)
library(shinyjs)
library(shinyalert)
library(shinydashboard)
library(shinydashboardPlus)

shinyUI(function(req) {
 dashboardPage(
   tagList(
     # Turn on shinyjs
     shinyjs::useShinyjs(),
     # Turn on shiny alert
     #useShinyalert()
   ),
    header = dashboardHeader(
      title = app_title
    ),
    sidebar = dashboardSidebar(
      sidebarMenu(
        # Prevent sidebar from dissappearing when scrolling
        #style = 'position: fixed; overflow: visible;',
        # Id used to get selected tab
        id = 'tab_panel',
        # About section
        menuItem('About', tabName = 'about', icon = icon('info')),
        # Real time
        menuItem('Current Conditions', tabName = 'rt', icon = icon('temperature-low')),
        # Time Series
        menuItem('Historic Time Series', tabName = 'ts', icon = icon('chart-line')),
        # Heatmap
        menuItem('Heatmap', tabName = 'heatmap', icon = icon('fire')),
        # Line animation
        menuItem('Line Animation', tabName = 'line_anim', icon = icon('chart-area')),
        # Spiral animation
        menuItem('Spiral Animation', tabName = 'spiral_anim', icon = icon('arrows-spin')),
        # Swimdays
        menuItem('Swim Days', tabName = 'swimdays', icon = icon('person-swimming'))
      )
    ),
    body = dashboardBody(
      tabItems(
        # About tab content
        tabItem(tabName = 'about',
          # The content of this tab will be rendered from a separate file as
          # specified in server.ui
          br(), br(),
          uiOutput('about_page')
        ),
        # Current conditions/realtime
        tabItem(tabName = 'rt',
                tab_rt_ui
        ),
        # Time series tab content
        tabItem(tabName = 'ts',
          tab_ts_ui
        ),
        # Heatmap tab content
        tabItem(tabName = 'heatmap',
                tab_heatmap_ui
        ),
        # Line animation tab content
        tabItem(tabName = 'line_anim',
                tab_line_anim_ui
        ),
        # Spiral animation tab content
        tabItem(tabName = 'spiral_anim',
                tab_spiral_anim_ui
        ),
        # Swim days tab content
        tabItem(tabName = 'swimdays',
                tab_swimdays_ui
        )
      )
    ) # End dashboard body
  ) # End dashboardpagePlus
}) # End ShinyUI