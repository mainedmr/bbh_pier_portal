### Server code for the line animation tab

output$line_anim <- renderImage({
  # Return a list containing the filename
  file_name <- ifelse(input$temp_is_c, 'line_plot_c.gif', 'line_plot_f.gif')
  list(src = file_name,
       contentType = 'image/gif'
       # width = 400,
       # height = 300,
       # alt = "This is alternate text"
  )
}, deleteFile = F)

