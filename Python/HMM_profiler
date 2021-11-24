# Example of the type of data expected for the function: A multiple sequence alignment (DataFrame) with gaps defined as "_" & alphabet of letters to emit

import pandas as pd
msa = pd.DataFrame({'s1':['_','A','C','_','T','_'], 's2': ['_','A','T','T','T', '_'], 's3':['A','A','T','T','T','A']}).transpose()
alphabet = ['A', 'C', 'G', 'T']

# Function to develop a HMM profile with match states and insertion states. There would not been deletion states, instead match states can emit gaps ("_").

def HMM_profiler_of_msa(msa, alphabet, Laplace=True):
    '''Given a multiple sequence alignemnt (pandas dataframe object with gaps represented as a string '_') and the letter alphabet considered, it generates
       a Hidden Markov model profile defined by two dataframe elements returned for the two stochastic processes;
       a transition matrix and an emission matrix. This profile, in opossition with most of the typical profiles consider
       deletion as a potential residue for the match states. Emmission rates for the insertion states are considered with
       the content of those columns mostly ungapped. Finally, the function can takes into consideration the Laplace rule
       (pseudocounts constant of 1) if specified the constant as True'''

    import pandas as pd
    # Heuristic rule: Match states are those positions mostly ungapped
    match_cols = msa.loc[:, (msa=='_').mean()<0.5]
    insert_cols = msa.loc[:, (msa=='_').mean()>0.5]

    # Rename in the MSA the column names distinguishing match and insert columns
    n=0
    for colname in match_cols.columns:
        n = n + 1
        msa = msa.rename(columns={colname:('M'+str(n))})

    n=0
    for colname in insert_cols.columns:
        msa = msa.rename(columns={colname:('I'+str(int(colname)-n))})
        n = n + 1

    # Apply or not the pseudocounts option (Laplace only)
    PC = 0
    if Laplace==True:
        PC = 1


    ## Create the transition and emission matrix
    # Consider the names given by the user for the alphabet (emission letters)
    alphabet = alphabet + ['_']; freq_dicc = {}
    for letter in alphabet:
        freq_dicc[letter]=PC

    # Generate names of the states of the profile
    state_names = ['B']+['M' + str(state_pos) for state_pos in range(1,match_cols.shape[1]+1)]+['I' + str(state_pos) for state_pos in range(0,match_cols.shape[1]+1)]+['E']

    # Generate model emission matrix. Include pseudocounts for not observed emissions
    emission_df = pd.DataFrame(index=alphabet, columns=state_names)
    emission_df = emission_df.fillna(PC)

    #Generate model transition matrix. Include pseudocounts for not observed transitions
    transition_df = pd.DataFrame(index=state_names, columns=state_names)



    # Emission calculus process
    for col in msa:
        # Calculate emissions, considering only in match states "_" as a residue
        if 'I' in col:
            msa_col= msa[col].loc[msa[col]!='_']
            letter_counts = msa_col.value_counts().to_dict()
            for key in letter_counts.keys():
                emission_df.loc[key, 'I0'] = emission_df.loc[key, 'I0'] + letter_counts[key]
        else:
            letter_counts = msa[col].value_counts().to_dict()
            for key in letter_counts.keys():
                emission_df.loc[key, col]= emission_df.loc[key,col] + letter_counts[key]

    emission_df.loc['_','I0']=0
    for col in emission_df:
        # Imitate in the rest of the insertion states the same emission matrix
        if 'I' in col:
            emission_df[col] = emission_df['I0']
        # Transform counts in frequencies
        emission_df[col] = emission_df[col]/sum(emission_df[col])

    # Begin and end might be silent states (no emission)
    emission_df['B'] = 0; emission_df['E']=0


    for tr_state in transition_df.columns:
        if tr_state=='B':
            transition_df['B']=0
            transition_df.loc['M1', 'B']=PC
            transition_df.loc['I0', 'B']=PC

        elif tr_state=='E':
            transition_df['E']=0

        elif 'I' in tr_state:
            n = int(tr_state[1:])
            transition_df[tr_state]=0
            if n<match_cols.shape[1]:
                transition_df.loc['M'+str(n+1), tr_state]=PC
                transition_df.loc['I'+str(n+1), tr_state]=PC
                transition_df.loc['I' + str(n), tr_state] = PC
            else:
                transition_df.loc['E', tr_state] = PC

        elif 'M' in tr_state:
            n = int(tr_state[1:])
            transition_df[tr_state]=0
            if n<match_cols.shape[1]:
                transition_df.loc['M'+str(n+1), tr_state]=PC
                transition_df.loc['I'+str(n), tr_state]=PC
            else:
                transition_df.loc['E', tr_state] = PC
                transition_df.loc['I'+str(n), tr_state] = PC

    for n in range(0,match_cols.shape[1]+1):
        if 'I'+str(n) in msa.columns:
            tr_state = 'I'+str(n)
            if n==0:
                prev_state = 'B'
                alt_state = 'M1'

            else:
                prev_state = msa.columns[n-1]
                if prev_state == 'M'+str(n):
                    alt_state = 'I'+str(n)
                elif prev_state == 'I'+str(n-1):
                    alt_state = 'M'+str(n)
        transition_df.loc[tr_state, prev_state] = sum(msa[tr_state].loc[msa[tr_state]=='_'].value_counts())+transition_df.loc[tr_state, prev_state]
        transition_df.loc[alt_state, prev_state] = sum(msa[tr_state].loc[msa[tr_state] != '_'].value_counts())+transition_df.loc[alt_state, prev_state]

    for col in transition_df:
        transition_df[col] = transition_df[col]/sum(transition_df[col])

    return(transition_df, emission_df)


# Try the function with our previuos defined example

transition_mtx_profile, emission_mtx_profile = HMM_profiler_of_msa(msa, alphabet, Laplace=True)


# Now we've got both objects that define the two stochastic processes of our HMM profile
print(transition_mtx_profile)
print(emission_mtx_profile)

