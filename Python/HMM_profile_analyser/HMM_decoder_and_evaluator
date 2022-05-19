# Type of data to introduce to the function: The sequence that we want to test (as str) and the transition and emission matrices as pandas dataframe. The begin and end states migh always be refered as 'B' and 'E' respectively.

import pandas as pd

sequence = 'ACGTTTTTTTTT'

transition_df = pd.DataFrame({'B': [0, 0.5, 0, 0, 0.5, 0, 0, 0],
                              'M1': [0, 0, 0.8, 0, 0.2, 0, 0, 0], 'M2': [0, 0, 0, 0.8, 0, 0.2, 0, 0], 'M3': [0, 0, 0, 0, 0, 0, 0.2, 0],
                              'I1': [0, 0, 0.5, 0, 0.5, 0, 0, 0], 'I2': [0, 0, 0, 0.5, 0, 0.5, 0, 0], 'I3': [0, 0, 0, 0, 0, 0, 0.5, 0.5],
                              'E': [0, 0, 0, 0, 0, 0, 0, 0]}, index=['B', 'M1', 'M2', 'M3', 'I1', 'I2', 'I3', 'E'])

emission_df = pd.DataFrame({'B':[0,0,0,0],
                            'M1':[0.7,0.1,0.1,0.1], 'M2':[0.1,0.7,0.1,0.1], 'M3':[0.1,0.1,0.7,0.1],
                            'I1':[0.25,0.25,0.25,0.25], 'I2':[0.25,0.25,0.25,0.25], 'I3':[0.25,0.25,0.25,0.25],
                            'E':[0,0,0,0]}, index=['A', 'C', 'G', 'T'])
                            



# Function to use for decoding and/or evaluting a sequence with the particular HMM specified previously

def eval_decode(transition_df, emission_df, seq, action='eval'):

    # Check all the states capable of emitting each sequence letter
    state_emissions={}
    for letter in set(seq):
        bool_serie = emission_df.loc[letter]>0
        state_emissions[letter] = list(bool_serie.index[bool_serie])

    # Check all the states that can transitate one to another
    state_transitions = {}
    for state in list(transition_df.columns):
        bool_serie = transition_df[state] > 0
        state_transitions[state] = list(bool_serie.index[bool_serie])


    cs = 'B'  # The current state (cs) at the start of the process is the begining state
    potential_paths = {'B':1} # The potential paths are gonna be constructed in this list
    l = 0
    while l < len(seq):

          # Contemplate the potential states that can emit the letter and from the current state can be reached
        paths = list(potential_paths.keys())
        for path in paths:
            cs = path.split()[-1]
            potential_states = set(state_transitions[cs]) & set(state_emissions[seq[l]])

              # Recalculate the probability of the different paths in construction 
            path_prob = potential_paths[path]; del potential_paths[path]
            for state in potential_states:
                var_path = path + ' ' + state
                potential_paths[var_path] = path_prob * emission_df[state][seq[l]] * transition_df[cs][state]
        
          # Pass to the next letter and reestart the iteration (until the length of the sequence is reached)
        l = l + 1
    
      # Depending on the process asked return the proper output
    if action=='decode':
        return max(potential_paths, key=potential_paths.get)
    elif action=='eval':
        return sum(list(potential_paths.values()))
    else:
        print('Error: "action" argument can only take two possible values specified as str: "decode" or "eval"')


  ## Example of eval action result; With the HMM specified what is the probability of generating the next sequence
print(eval_decode(transition_df, emission_df, seq='ACGTTT', action='eval'))

  ## Example of decode action result; With the HMM specified what is the most probable path to generate the next sequence
print(eval_decode(transition_df, emission_df, seq='ACGTTT', action='decode'))
