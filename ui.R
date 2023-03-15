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
      title = 'BBH Environmental Station'
    ),
    sidebar = dashboardSidebar(
      sidebarMenu(
        # Prevent sidebar from dissappearing when scrolling
        #style = 'position: fixed; overflow: visible;',
        # Id used to get selected tab
        id = 'tab_panel',
        # About section
        menuItem('About', tabName = 'about', icon = icon('info')),
        # Time Series
        menuItem('Time Series', tabName = 'ts', icon = icon('chart-line')),
        # Heatmap
        menuItem('Heatmap', tabName = 'heatmap', icon = icon('fire')),
        # Line animation
        menuItem('Line Animation', tabName = 'line_anim', icon = icon('chart-area'))
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
        )
      )
    ) # End dashboard body
  ) # End dashboardpagePlus
}) # End ShinyUI