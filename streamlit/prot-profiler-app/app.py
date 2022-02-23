#Packages required
import streamlit as st
from PIL import Image
import pandas as pd
import numpy as np
from collections import Counter
from Bio.Align import substitution_matrices
st.markdown("<h1 style='text-align: center; color: white;'>Prot-Profiler</h1>", unsafe_allow_html=True)
st.markdown("""<h5 style='text-align: center; color: white;'>A streamlit app to generate Hidden Markov Profiles from a list of proteins,
as well as the correspondent progressive MSA used (Multiple Sequence Alignment). The output are the transition and emission matrices (
dataframe objects) of the profile</h5>""", unsafe_allow_html=True)
st.markdown('---')

# Input data
st.text('''
Introduce all your input protein sequences and select the scoring system criteria 
(blosum matrix) as well as if you want to use Laplace in the construction of the MSA. 
As an example to test, we have used some sequences of the TAF protein family''')

with st.form(key='my_form'):
    seqs = st.text_input(label='► List of protein sequences separated by commas (blank spaces will be ignored)',
                         value='''FVEIPRESVRLMAESTGLELSDEVAALLAEDVCYRLREATQNSSQFMKHTKRRKLTVEDFNRALR\nMSIVPKETIEVIGQSVGIANLPADVSAALAPDVEYRLREIMQEAIKCMRHAKRTVLTADDVDSALSLR
                         MSIVPKETVEVIAQSIGITNLLPEAALMLAPDVEYRVREIMQEAIKCMRHSKRTTLTASDVDGALNLR\nLTVWNIESIKDVAEMLGIGNLADEPAAAIAMDLEYRIHQVVQEATKFMVHSKRTVLTSADISSALR
                         TIWSPQDTVKDVAESLGLENINDDVLKALAMDVEYRILEIIEQAVKFKRHSKRDVLTTDDVSKALR''')

    sub_mtx_name = st.selectbox('► Substitution matrix for the MSA', options=substitution_matrices.load(), index=3)
    PC = st.select_slider('► Pseudocount constant to elude unobserved cases to be impossible', options=[0, 1, 2, 3])
    submit_button = st.form_submit_button(label='Submit')

if submit_button:
    sub_mtx = substitution_matrices.load(sub_mtx_name)

    # Elude potential mistakes and separate the sequences in a list using the commas
    seqs = seqs.replace(' ', '').upper().splitlines()

    # The emission letters of our HMM are protein aminoacids. Elude unknown aminoacids (X) to be considered as potential emissions.
    alphabet = list(sub_mtx.alphabet)
    if 'X' in alphabet:
        alphabet.remove('X')

    # PREDIFINED FUNCTIONS TO USE
    # Predifine the Pairwise Alignment (align), the multiple sequence alignemnt (MSA) and the simple Hidden Markov profiler (HMMp)

    def align(seq_obj1, seq_obj2):
        '''Smith Waterman algorithm to perform a global pairwise alignment using the matrix Blosum45 as its scoring system.
        The expected input are two strings (two protein sequences) of one-letter code and the output given is an list with:
        1 y 2) Each sequence aligned, 3 y 4) Each original sequence employeed, 5) Maximum value of the scoring matrix.'''
        # Declare the sequences and the scoring system
        seq1= list(' '+str(seq_obj1))
        seq2= list(' '+str(seq_obj2))

        # Fill the scoring matrix
        mtx = pd.DataFrame(0,columns=seq1, index=seq2)
        for i in range(1,len(seq2)):
            for j in range(1, len(seq1)):
                print('Scoring', i, j)
                # Score
                if (seq2[i], seq1[j]) in sub_mtx.keys():
                    score = sub_mtx[(seq2[i], seq1[j])]
                if (seq1[j], seq2[i]) in sub_mtx.keys():
                    score = sub_mtx[(seq1[j], seq2[i])]
                possible_scores = [mtx.values[i-1,j],
                                    mtx.values[i,j-1],
                                    mtx.values[i-1,j-1]+score]
                mtx.values[i,j] = max(possible_scores)

        # Traceback with preference for matching in bifurcations
        i=len(seq2)-1; j=len(seq1)-1
        s1 = str(seq_obj1); s2 = str(seq_obj2)
        while i>0 or j>0:
            print('TB', i, j)
            # Score
            if (seq2[i], seq1[j]) in sub_mtx.keys():
                score = sub_mtx[(seq2[i], seq1[j])]
            if ((seq1[j], seq2[i])) in sub_mtx.keys():
                score = sub_mtx[(seq1[j], seq2[i])]

            if mtx.values[i,j] == mtx.values[i-1,j-1]+score:
                i=i-1; j=j-1
                continue
            elif mtx.values[i,j] == mtx.values[i-1,j]:
                s1 = s1[0:j] + '·' + s1[j:]
                i = i-1
                continue
            elif mtx.values[i,j] == mtx.values[i,j-1]:
                s2 = s2[0:i] + '·' + s2[i:]
                j = j-1
                continue
        return [str(seq_obj1), str(seq_obj2), s1,s2, mtx.values[len(seq2)-1, len(seq1)-1]]


    def MSA(list_seq):
        '''A Multiple Sequence Alginment Function that takes an ordered list of one-letter code protein sequences as input and performs
        the progressive alignment to produce an output where all the implicated sequences are uniformly aligned together in an
        unique list (msa) using a letter-dot representation. Uses another previous function, to do the pairwise alignment ("align").'''
        msa=[]
        for i, seq in enumerate(list_seq[0:-1]):
            # Perform a pairwise alignment
            results = align(list_seq[i], list_seq[i+1])

            # Stores the first pairwise alignment
            if i == 0:
                msa.append(results[2])
                msa.append(results[3])

            # Compare the new alignments with the previous ones (msa) to readapt their lengths and superposition
            if i > 0:
                s1=0; s2=0; new_seq = ''; new_res = ''
                while msa[-1]!=results[2] and s1<len(msa[-1]) and s2<len(results[2]):

                    # To study their differences just check the shared sequence used in both alignments
                    if msa[-1][s1]==results[2][s2]:
                        new_seq = new_seq + msa[-1][s1]
                        new_res = new_res + results[3][s2]
                        s1 = s1 + 1; s2 = s2 + 1
                    elif msa[-1][s1]=='·':
                        new_seq = new_seq + '·'
                        new_res = new_res + '·'
                        s1 = s1 + 1
                    elif results[2][s2]=='·':
                        new_seq = new_seq + '·'
                        new_res = new_res + results[3][s2]
                        for r in range(0,len(msa)-1):
                            msa[r] = msa[r][0:s2+1]+ '·' + msa[r][s2+1:]
                        s2 = s2 + 1

                # Store the new designed sequences
                msa[-1] = new_seq
                msa.append(new_res)
        return msa


    def HMMp(msa, alphabet, PC=1):
        '''Given a multiple sequence alignemnt (list object with gaps represented as a string '·') and the letters' alphabet considered, it generates
           a Hidden Markov model profile defined by two dataframe elements returned for the two stochastic processes;
           a transition dataframe and an emission dataframe. Transitions can occur between match states and also deletion (gaps in match states)
           or insertion (non-gap in insertion states). Insertion states are designed by the general heuristic rule (>50% gaps columns). Emissions
           are equal for all the insertion states, while deletion states are silent (do not emit). Finally, the function can take into consideration
           a pseudocount constant (PC), by standard equal to 1 following Laplace method'''

        # Adapt the list format into a pandas dataframe, then determines the order of the different states appearing
        msa_np = np.array([list(seq) for seq in msa])

        all_states = {col:Counter(msa_np[:,col]) for col in range(np.shape(msa_np)[1])}
        match_st_indices = [state_col for state_col, state_letters in all_states.items() if state_letters['·'] < len(msa_np)/2]
        st_names = [match_st_indices.index(col)+1 if col in match_st_indices else 'I' for col in all_states.keys()]

        names_match_st = [name + str(n) for name, n in zip(['M']*len(match_st_indices), range(1,len(match_st_indices)+1))]
        names_delet_st = [name + str(n) for name, n in zip(['D']*len(match_st_indices), range(1,len(match_st_indices)+1))]

        # Create the emission and transition dataframes to store the counts
        msa_df = pd.DataFrame(msa_np, columns=st_names)
        emission_df = pd.DataFrame(data=PC, index=alphabet + ['·'], columns=names_match_st + names_delet_st + ['I'])
        transition_df = pd.DataFrame(data=0, index= ['B'] + names_match_st + names_delet_st + ['I'],
                                     columns=names_match_st + names_delet_st + ['I', 'E'])

        # A function to determine the type of state depending on the indexing system created
        def type_state(st,i):
            if st != 'I' and seq[i] != '·':
                st = 'M' + str(st)
            elif st != 'I' and seq[i] == '·':
                st = 'D' + str(st)
            return st

        # Employ this function over all the sequences and make the counts for both matrices
        for seq in msa_np:
            for i in range(len(st_names)-1):
                st1 = type_state(st_names[i],i); st2 = type_state(st_names[i+1],i+1)

                if st1 == 'I' and seq[i]=='·':
                    continue
                n=0
                while st2 == 'I' and seq[i+1+n]=='·':
                    n += 1; st2 = type_state(st_names[i+1+n],i+1+n)

                transition_df.loc[st1, st2] += 1
                emission_df.loc[seq[i], st1] += 1

        # Add the information to transition from the begin (or to the end) state
        for seq in msa_np:
            # Count transitions from the begin state to the first position/state
            st_postB = type_state(st_names[0], 0)
            n = 0
            while st_postB == 'I' and seq[0 + n] == '·':
                n += 1; st_postB = type_state(st_names[0 + n], 0 + n)
            transition_df.loc['B', st_postB] += 1

            # Count transitions from the end state to the last position/state
            st_preE = type_state(st_names[-1], -1)
            n = 0
            while st_preE == 'I' and seq[0 + n] == '·':
                n -= 1; st_preE = type_state(st_names[-1 + n], -1 + n)
            transition_df.loc[st_preE, 'E'] += 1

        # Add pseudocounts in all possible transitions
        for col in transition_df:
            if col=='M1' or col=='D1':
                transition_df.loc['B',col] += PC
                continue
            if col=='I':
                transition_df.loc[:,'I'] += PC
                break

            transition_df.loc['M' + str(int(col[1:]) - 1), col] += PC
            transition_df.loc['D'+str(int(col[1:])-1), col] += PC
            transition_df.loc['I', col] += PC

        # Transform into frequencies the counts stored in both dataframes and return them as outputs
        transition_df = transition_df.div(transition_df.sum(axis=1), axis=0)
        emission_df = emission_df.div(emission_df.sum(axis=0), axis=1)
        return transition_df, emission_df


    # Produce the Multiple Sequence Alignment on your sequences
    msa = MSA(seqs)

    # Use your MSA to obtain the transition and emission matrices that define your HMM profile
    transition_df, emission_df = HMMp(msa, alphabet)

    # Report the outputs
    st.markdown("---")
    st.markdown('''
    ## Multiple Sequence Alignment (MSA)
    #### Letters: Residues, Dots: Gaps''')
    st.text('\n'.join(msa))

    st.markdown('''
    ## Transition Daraframe of the Profile
    #### Index:Previous state, Column: Posterior state''')
    st.dataframe(transition_df)
    st.markdown('''
    ## Emission Daraframe of the Profile
    #### Index:Letter/Emission, Column: State/Sender''')
    st.dataframe(emission_df)
