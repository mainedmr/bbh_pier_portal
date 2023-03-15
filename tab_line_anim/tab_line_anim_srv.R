### Server code for the line animation tab

output$line_anim <- renderImage({
  # A temp file to save the output
  outfile <- tempfile(fileext =' .gif')
  
  anim_save('outfile.gif', line_anim_plot2)
  
  # Return a list containing the filename
  list(src = 'outfile.gif',
       contentType = 'image/gif'
       # width = 400,
       # height = 300,
       # alt = "This is alternate text"
  )
}, deleteFile = T)

