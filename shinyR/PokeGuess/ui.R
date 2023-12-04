# Import libraries
library(shiny)
library(shinythemes)
library(shinydashboard)
library(RCurl)
library(shinyWidgets)


data = read.csv('data/pokemon.csv')

ui = dashboardPage(skin = 'red', 
                   
                   dashboardHeader(title = "PokeGuess", disable = F)
                   ,
                   dashboardSidebar( 
                  

                       # INPUT: CHOOSE POKEMON GUESS
                       pickerInput(width = 200,
                                   inputId = "pokemon_guess", label = "Your guess",
                                   choices = paste0(data$pokedex_number, '. ', data$name), 
                                   multiple=F, options = list(`live-search`=T)
                       ),
          
                             
                       
                       
                       # INPUT: SELECT GENERATIONS
                       checkboxGroupInput('generations', label='Pokemon Generations included',
                                          choiceValues = 1:7, selected = 1:7, choiceNames = paste0('G', 1:7), inline = T),
                       
                       # RETRIEVE POINTS (CORRECT GUESSES)
             
                       textOutput('points'), 
                       
                       # INPUT: NEXT & CHECK BUTTONS
                       HTML('&nbsp &nbsp'),
                       actionButton('next_button', 'Next', class='btn btn-primary', ),
                       HTML('&nbsp &nbsp'),
                       actionButton('check_button', 'Check', class='btn btn-primary')
                       ),
                       
                   dashboardBody(
                     tags$head(tags$link(rel='stylesheet', type='text/css', 
                                         href='./styles/css-pokemon-gameboy.css')),
                     
                     tags$b(textOutput('pokemon_solution')),
                     
                     box(title='', collapsible=T,
                         column(12, align="center", imageOutput('img')),
                         width = 50,height = 400, background = 'black'),
                
                     tags$ul(class='framed buttons compact', 
                             tags$li(class='button', 'Pokemon description'),
                             tags$li(class='button', 'Ability1'),
                             tags$li(class='button', 'Ability2'),
                             tags$li(class='button', 'Ability3')
                             
                             )
            
  
                   )
                   
)