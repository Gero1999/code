# Import libraries
library(shiny)
library(shinythemes)
library(shinydashboard)
library(RCurl)
library(shinyWidgets)

# Build a deck considering suits and ranks (as well as the jokers)
suits <- c("D", "C", "H", "S")  
ranks = c(1:12) 
deck_list = c(lapply(suits, paste0, ranks), list(J=c('J', 'J')))
names(deck_list) = c('Diamonds', 'Clubs', 'Hearts', 'Spades', 'Jokers')

ui = dashboardPage(skin = 'red', 
                   
                   dashboardHeader(title = "Texas-Cheater"),
                   dashboardSidebar(
                       # Custom CSS to hide the default logout panel
                       tags$head(tags$style(HTML('.shiny-server-account { display: none; }', '.shiny-output-error-validation{color:green;}'))),
                       
                       pickerInput(width = 200,
                                   inputId = "my_cards", label = "Hole cards",
                                   choices = deck_list, selected = list('S7', 'S10'),multiple=T,
                                   options=list()
                       ),
                       column(width = 11,
                              markdown('Select the cards the player has in his hands after the flop <br />')),
                       markdown('<br /> <br />'), 
                       
                       pickerInput(width = 200,
                                   inputId = "table_cards", label = "Comunity cards",
                                   choices = deck_list, selected = list('C1', 'D7'), multiple=T
                       ),
                       column(width = 11,
                              markdown('Select the cards on the table that were already revealed <br />')),
                       markdown('<br /> <br />'), 
                       
                       
                       sliderInput("nr_players", "Total number of players:",
                                   min = 2, max = 14, value = 4, width=250),
                       column(width = 11,
                              markdown('Include yourself. The winner may always be considered! <br />')),
                       markdown('<br /> <br />'), 
                       
                       sliderInput("n_sim", "Number of simulations:",
                                   min = 1, max = 10000, value = 1000, width=250),
                       column(width = 11,
                              markdown('More games increase the prediction\'s accuracy <br />')),
                       markdown('<br /> <br /> <br />'), 
                       
                       actionButton('submitbutton', 'Simulate', class='btn btn-primary')),
                   
                   dashboardBody(
                       HTML('<div align="center"><font size="+1">&nbsp&nbsp <b>A poker simulator to 
         predict your chances of beating your opponents</b></font></div>'),
                       
                       HTML('<br /> <br /> '),
                       HTML('This R-shiny app is inspired by the popular Poker game "Texas Hold\'em". With the
         input information considers which one is your best hand and performs a variable number
         of simulations in order to estimate a success\' frequency.
         In this game each player possess 2 cards (Hole cards) and 5 common-cards shared
         with the rest of the players (Community cards). The game has a duration of five
         rounds, and in each round community cards are revealed. However, in order to stay 
         in the game, the player may decide in each round if he folds or continue betting. 
         Just in case you do not remember the rules here are the hand ranges:
         '),
                       HTML('<br /> <br /> <br />'),
                       box(title='1) Straight flush',background = 'navy', width = 6,
                           HTML('&nbsp &nbsp &#127163 &#127164 &#127165 &#127166 &#127153 &nbsp &nbsp 
             Five cards of sequential rank sharing the same suit')),
                       box(title='2) Poker',background = 'navy', width = 6,
                           HTML('&nbsp &nbsp &#127169 &#127185 &#127137 &#127153 &#127141 &nbsp &nbsp 
             Four cards of a kind, also commonly known as quads')),
                       box(title='3) Full house',background = 'navy', width = 6,
                           HTML('&nbsp &nbsp &#127166 &#127182 &#127150 &#127181 &#127149 &nbsp &nbsp 
             3 cards of one rank and 2 cards of another')),
                       box(title='4) Flush',background = 'navy', width = 6,
                           HTML('&nbsp &nbsp &#127139 &#127141 &#127143 &#127145 &#127147 &nbsp &nbsp 
             Five cards of the same suit')),
                       box(title='5) Straight',background = 'navy', width = 6,
                           HTML('&nbsp &nbsp &#127137 &#127170 &#127187 &#127156 &#127141 &nbsp &nbsp 
             Five cards of sequential rank')),
                       box(title='6) Set, two/single pair...',background = 'navy', width = 6,
                           HTML('&nbsp &nbsp &#127196 &#127180 &#127164 &#127174 &#127141 &nbsp &nbsp 
             The one shown is a set (three of a kind)')),
                       
                       box(title='Results from the simulations (Frequencies)', collapsible=T,
                           column(12, align="center", tableOutput('simulations_tb')),
                           width = 12,height = 150, background = 'red')
                   )
                   
)