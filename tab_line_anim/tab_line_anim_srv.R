### Server code for the line animation tab

output$line_anim <- renderImage({
  # Return a list containing the filename
  list(src = 'line_plot.gif',
       contentType = 'image/gif'
       # width = 400,
       # height = 300,
       # alt = "This is alternate text"
  )
}, deleteFile = F)

