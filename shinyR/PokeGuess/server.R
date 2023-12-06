#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(dplyr)
library(tidyr)
library(png)

data = read.csv('data/pokemon.csv')


function(input, output, session) {
  
  
  # Set initial values for all the changing variables
  values = reactiveValues(
    data = data,
    pokemon = data[1,],
    img_path = '',
    solution =  '',
    points = 0
  )
  
  # Initial instructions within user login 
  observeEvent(input$start==0, {
    
    showModal(modalDialog(
      
      tags$h4('Welcome to PokeGuess!', style='text-align: center;'),
      tags$hr(style = "border-top: 0.5px solid #000000;"),
      tags$h6('PokeGuess is an app imitating the classic game "Who is that Pokemon?" 
              You just need to guess the silhouette of the Pokemon (psttt, I also included other hints).
              Just select those Pokemon generations you want to play and try to guess them all!',
              style='text-align: justify;'),
      tags$ul(class='framed buttons compact', 
              tags$li(class='button', tags$a('Author', href='https://github.com/Gero1999', 
                                             target='_blank', style = 'color: black')),
              tags$li(class='button', tags$a('Data', href='https://github.com/Gero1999', 
                                             target='_blank', style = 'color: black')),
              tags$li(class='button', tags$a('Images', href='https://github.com/Gero1999', 
                                             target='_blank', style = 'color: black')),
              tags$li(class='button', tags$a('Sounds/BG', href='https://github.com/Gero1999', 
                                             target='_blank', style = 'color: black'))
    
      ),
              footer=tagList(modalButton('Start'))
    ))
  })
  
  
  observeEvent(input$start | input$next_button, {
    # Choose only data from the specified generations
    values$data = values$data %>% 
      dplyr::filter(generation %in% input$generations)
    
    updatePickerInput(session, 'pokemon_guess', 
                      choices = paste0(values$data$pokedex_number, '. ', values$data$name))
    
    # Select random pokemon
    values$pokemon = values$data[sample(nrow(values$data),1),]
    
    # Load image
    img = png::readPNG(paste0('images_pokemon/',tolower(values$pokemon$name),'.png'))
    
    # Make a black and white version
    mtx.bw = (rowSums(img, dims=2) == 0)+0
    img.bw = array(mtx.bw, dim=dim(img))
    img.bw[,,4] = img[,,4]  # Transparency layer
    
    # Save the image and keep the path
    temp_path = tempfile(fileext = 'silhouette.png')
    png::writePNG(img.bw, target = temp_path)
    values$img_path = temp_path
    
    # Don't display the answer yet
    values$solution = "Who's that Pokemon?"
    }
  )
  
  observeEvent(input$check_button,{
    # Show answer (name and image)
    values$solution = paste0(values$pokemon$pokedex_number, '. ', values$pokemon$name)
    values$img_path = paste0('images_pokemon/',tolower(values$pokemon$name),'.png')
    
    # Return if user's guess was right or not
    if ((values$solution == input$pokemon_guess) && (values$pokemon$name %in% values$data$name)){
      values$points <- values$points+1
      
      # Take off the Pokemon so it does not repeat
      values$data = values$data[!values$data$name==values$pokemon$name,]
    }
    
    # Play Pokemon cry audio
    if (input$enable_sound){
    insertUI(selector='#check_button', 
             ui=tags$audio(src=paste0('sounds/', tolower(values$pokemon$name), '.wav'),
                           type='audio/wav', 
                           autoplay=TRUE, 
                           style='display:none;')
             )
      }
   }
  )
  
  output$pokemon_solution = renderText( values$solution )
  
  output$img <- renderImage({
    
    list(src=values$img_path, alt=paste0(values$pokemon$name),
         width=350, height=350)
    }, deleteFile = F)
  
  output$points <- renderText(values$points)

  
  # HINTS
  
  observeEvent(input$check_button,{
    
  output$hint_box1 = renderText( values$pokemon$type1 )
  output$hint_box2 = renderText( values$pokemon$type2 )
  output$hint_box3 = renderText( values$pokemon$classfication )
  output$hint_box4 = renderText( values$pokemon$abilities )
  }) 
  
  # Server-rendered numeric outputs

  
  # Reactive output display

}
