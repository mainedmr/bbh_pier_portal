### Server code for the line animation tab

output$spiral_anim <- renderImage({
  # A temp file to save the output
  #outfile <- tempfile(fileext =' .gif')
  file_name <- ifelse(input$temp_is_c, 'spiral_plot_c.gif', 'spiral_plot_f.gif')
  # Return a list containing the filename
  list(src = file_name,
       contentType = 'image/gif'
       # width = 400,
       # height = 300,
       # alt = "This is alternate text"
  )
}, deleteFile = F)

