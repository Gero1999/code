# Import libraries
library(shiny)
library(shinythemes)
library(shinydashboard)
library(RCurl)
library(shinyWidgets)
library(shinyglide)

data = read.csv('data/pokemon.csv')


ui = fluidPage(
  # Set aesthetic elements (background and css)
  tags$head(tags$link(rel='stylesheet', type='text/css', 
                      href='./styles/css-pokemon-gameboy.css')),
  setBackgroundImage(src='images/design/background.png', shinydashboard = F),
  useShinydashboard(),

  
  

  fluidRow(width=6,
    column(width=1),
    column(width=6, align='center',
           tags$br(), tags$br(),  tags$br(),
           div( style='height: 100px; overflow-y:auto;',
                tags$h2(textOutput('pokemon_solution'),
                        style = "color: black;")),

           imageOutput('img'),
           box(collapsible=F, closable=F, background='black', align='center', width=50, solidHeader = F,
               pickerInput(width = 225,
                           inputId = "pokemon_guess", label = "Your guess",
                           choices = paste0(data$pokedex_number, '. ', data$name), 
                           multiple=F, options = list(`live-search`=T)
               ),
               actionButton('next_button', 'Next', class='btn btn-primary'),
               actionButton('check_button', 'Check', class='btn btn-primary'),
               tags$br(), tags$br(),
               checkboxGroupInput('generations', label='Pokemon Generations',
                                  choiceValues = 1:7, selected = 1:7, choiceNames = paste0('G', 1:7), inline = T),
           )
           ),
           
 
    column(width=3, align='center',
           div(
             style = "
                   margin-left:10%;
                    display: inline-block;
                    position: absolute;
                ",
             img(
               src = "images/design/pokeball.svg",
               height = 300,
               width = 300,
               style = "  position: relative;
                          top: -70px; 
                          right: 270px;"
             ),
             span(textOutput("points"),
                  style = "
              color: white;
                 position: relative;
                     top: -255px;
                    right: 100px;
                  text-align:left;
                  font-size: 35px;"
             ),
             span(materialSwitch(inputId = "enable_sound", right=F, value = T, status='primary',
                                 label = "Sound", inline = T, width = '20%'),
                  style = "color: white;
                                          position: relative;
                                          top: -310px;
                                          right: 85px;
                                          font-size: 20px;"
             ),
      
             actionButton(inputId='pokedex_hint',label='Hint', 
             style="width: 80px; height: 120px; background: url('images/design/pokedex.jpg');
             position: relative; top: -310px; right: 30px;
             background-size: 100% 100%; background-position: center;")
           ),

    
    
           
           
           )
    

  )
  


)
