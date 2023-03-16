### Server code for the line animation tab

output$spiral_anim <- renderImage({
  # A temp file to save the output
  #outfile <- tempfile(fileext =' .gif')
  # Return a list containing the filename
  list(src = 'spiral_plot.gif',
       contentType = 'image/gif'
       # width = 400,
       # height = 300,
       # alt = "This is alternate text"
  )
}, deleteFile = T)

