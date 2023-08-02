## Pre-define your deck of cards and some functions for the server

# Function to determine the best hand a player can play
best_hand = function(cards){
    
    # Find how many jokers are in your hand 
    nJ = length(cards[cards=='J'])
    
    # Decompose the data/cards in 2D (suits and ranks). Aces might be considered to possess the highest value
    suit_vr = substr(cards, 1,1)
    nr_vr = as.numeric(substr(cards,2,3))
    # Aces possess the highest values (1's = 13's)
    nr_vr[nr_vr==1] = 13
    
    # Search for couples
    tb = table(nr_vr)
    best_couple = sort(tb[order(-as.numeric(names(tb)))], decreasing=T)[c(1,2)]
    best_hand = c(best_couple[1]+as.numeric(names(best_couple[1]))*0.01 + nJ,  
                  best_couple[2]+as.numeric(names(best_couple[2]))*0.01)
    
    # Search for straights: Aces can be located at the top (1) or bottom (13) of straights
    sort_nr_vr = unique(sort(nr_vr))
    if (1 %in% sort_nr_vr){c(sort_nr_vr, 13)}
    possible_stra = sapply(1:(13-4), function(x) c(x:(x+4)))
    list_coincidences = apply(possible_stra, MARGIN = 2, function(x) sort_nr_vr[sort_nr_vr %in% x])
    list_stra = list_coincidences[lengths(list_coincidences)>(4-nJ)]
    if (length(list_stra)>0) {
        best_hand = c(3.25 + 0.01 * list_stra[[length(list_stra)]][1],
                      sort_nr_vr[length(sort_nr_vr)])
        }
  
    # Search for a flush.
    if (T %in% table(suit_vr)>(4-nJ)){
        suit = names(table(suit_vr)[table(suit_vr)>(4-nJ)])
        best_hand = c(3.5 + 0.01 * sort(nr_vr[suit_vr==suit])[1],
                      sort_nr_vr[length(sort_nr_vr)])
        }
    
    # If a full house is our best couple it should be considered better than a flush
    if ((3==best_couple[1])&(2==best_couple[2])){
        best_hand = c(3.75, 
                      as.numeric(names(best_couple[1]))+as.numeric(names(best_couple[2]))*0.01)
        }
    
    # If our best couple is a poker (four of a kind) it is the second best combination we can obtain in a game 
    if (best_couple[1]==4){
        best_hand =  c(best_couple[1]+as.numeric(names(best_couple[1]))*0.01,
                       best_couple[2]+as.numeric(names(best_couple[2]))*0.01)
        }
    
    # Search for a straight flush among the straights. 
    for (x in list_stra){
        stra = suit_vr[order(nr_vr)][sort_nr_vr %in% x]
        if (length(unique(stra))==1){
            best_hand = c(5+0.01*x[1],
                          sort_nr_vr[length(sort_nr_vr)])
            }
    }
    
    # Output
    return(best_hand)
}

# Function to determine if the first player's hand beats the second player's hand
is_hand1_better = function(hand1, hand2){
    if (hand1[1]>hand2[1]){return(T)}
    if (hand1[1]==hand2[1]){
        if (hand1[1]>hand2[2]){return(T)}
        if (hand1[2]==hand2[2]){return(0)}
    }
    return(F)
}

lets_play = function(my_cards, table_cards, nr_players){
    
    # Build your deck and discard the cards already revealed
    deck = c(sapply(c('D', 'C', 'H', 'S'), paste0, c(1:12)), c('J', 'J'))
    deck = deck[!deck %in% c(my_cards,table_cards)]
    
    # Check if all the community cards have been revealed
    table_cards = c(table_cards, sample(deck, 5-length(table_cards)))
    deck = deck[!deck %in% c(my_cards, table_cards)]
    
    # Search for your best hand
    my_hand = best_hand(c(my_cards, table_cards))
    
    # Simulate opponents' hands
    other_players = sample(deck, 2*(nr_players-1))
    opponent_hands = lapply(1:(nr_players-1), function(x) best_hand(c(other_players[x], table_cards)))
    
    # Test if your hand beats your oponnents' hands
    sapply(opponent_hands, function(x) is_hand1_better(my_hand, x))
    if (FALSE %in% sapply(opponent_hands, function(x) is_hand1_better(my_hand, x))){
        return('Loose')}
    if (0 %in% sapply(opponent_hands, function(x) is_hand1_better(my_hand, x))){
        return('Draw')}
    return('Win')
}
# -------------------------------------------················································

# Implement the server and connect it to the UI
server <- function(input, output) {
    numericInput <- reactive({
      
        validate(
            need((length(intersect(input$my_cards, input$table_cards))==0),
                 message=paste('Please, elude repeated cards:', intersect(input$my_cards, input$table_cards))),
            need(length(input$my_cards)==2,
                 message='Please, include always 2 hole cards')
        )
      
        simulations_tb = table(
            replicate(input$n_sim, 
                      lets_play(input$my_cards, input$table_cards, input$nr_players)))/input$n_sim
    })
    
    output$simulations_tb <- renderTable({
        if (input$submitbutton>0){
            isolate(numericInput())
        }
    },width = 400, bordered = T, hover = T, colnames = F,spacing = 'l', align = 'c')
}
