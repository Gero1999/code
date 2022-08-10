# IMPORTED MODULES
import pandas as pd
import numpy as np
import os
import streamlit as st
import openpyxl
import pip
pip.main(["install", "openpyxl"])



# WEB INFO & INPUT DATA
st.set_page_config(page_title='Clone Trigger App', page_icon="🧬",layout='centered')
st.markdown("<h1 style='text-align: center; color: red;'> Clone-Trigger</h1>", unsafe_allow_html=True)
st.markdown('---')
st.markdown("""<h5 style='text-align: justify; color: red;'>Do you want to know what is the perfect enzyme to use
in your cloning? Give us the whole fragment of DNA and the precise insert you want to extract and we will make a 
profile study to give you the primers that you need (if you do)</h5>""", unsafe_allow_html=True)


with st.form(key='my_form'):
    seq = st.text_area(label='► Whole fragment of DNA',
                       value='''AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAGAGTCGAAGGAGTCGAAGGAGTCGAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA''')

    inter = st.text_area(label='► Desired cloning insert of the DNA',
                         value='''GAGTCGAAGGAGTCGAAGGAGTCGA''')
    submit_button = st.form_submit_button(label='Submit')

with st.sidebar:
    st.markdown("<h3 style='text-align: center; style:bold; color: red;'>Primers specifications</h3>", unsafe_allow_html=True)
    st.markdown('---')
    orf = st.radio('► Open Reading Frame (ORF)', options=['Exact-cut', 0, 1, 2], index=0)
    integrity_factor = st.select_slider('► Insert integrity factor: Prioritization ratio of mismatches inside/outside your cloning insert', options=list(range(1,11)))
    len_primer = st.select_slider('► Insert desired primer length: Number of nucleotides per primer (forward & reverse)', options=list(range(12,31)))
    st.markdown('---')

if submit_button:
    # Define from the sequence the different parts 
    lseq, insert, rseq = seq.rpartition(inter)

    # Disconsider those enzymes with inexact cuts or which restriction site surpasses the length of the primers
    enzs = pd.read_excel('https://github.com/Gero1999/data/blob/main/enzymes/re_enzymes.xlsx')
    enzs = enzs.loc[enzs['Restriction Site'].str.contains('\(.*\)', regex=True)==False]
    enzs = enzs.loc[enzs['Restriction Site'].str.contains('\/', regex=True) == True]
    enzs = enzs.loc[np.array([True if len(enz)<=len_primer else False for enz in enzs['Restriction Site']])]


    # Dictionary translating all nucleotide symbols
    dicc = {'N':'CGAT', 'A':'A', 'C':'C', 'G':'G', 'T':'T',
            'R':'GC', 'Y':'CT', 'K':'GT', 'M':'AT', 'S':'GC',
            'W':'AT', 'B':'GTC', 'D':'GAT', 'H':'CTA', 'V':'GCA', '/':'/'}

    # Functions of interest
    def comp_dna(dna_seq):
        '''Determine the complementary DNA strand given a sequence (str)'''
        return ''.join({'A':'T', 'C':'G', 'G':'C', 'T':'A'}[bp] for bp in dna_seq[::-1])
    
    def eval(s1, s2):
        '''Count number of mismatches between two strings; the site (s1) and the enzyme's recognition site (s2)'''
        return np.array([bp1 not in dicc[bp2] for bp1,bp2 in zip(s1,s2)])
    
    def create_restriction(dna_site, enz_site):
        '''Generate the correspondant primer considering the site (s1) and the enzyme's recognition site (s2)'''
        return ''.join([bp1 if bp1 in dicc[bp2] else dicc[bp2][0] for bp1,bp2 in zip(dna_site,enz_site)])
    
    def priming(enz_name, enz_site, lseq, seq, len_primer, ORS=0, integrity_factor=1, insert_in_right=True):
        '''Produces a forward primer based on a sequence (seq) whose left part (lseq) is used to produce a restriction site into
        a forward primer whose fitness is evaluated based on a scoring vector dependent on the alteration of the insert/rest of sequence'''
        # Based on what can the enzyme recognise and our DNA design a restriction site
        lenz, renz = enz_site.split('/')
        st, end = (len(lseq) - len(lenz) - ORS, len(lseq) + len(renz) - ORS)
        res_site = create_restriction(seq[st:end], lenz + renz)

        # Evaluate how good is the restriction site (mutagenesis) and how much it changes the cloning insert and the whole sequence
        if insert_in_right:
            seq_eval = np.repeat([1, integrity_factor], [len(lseq), len(seq)-len(lseq)])
        else:
            seq_eval = np.repeat([integrity_factor, 1], [len(lseq), len(seq)-len(lseq)])

        eval_vr = seq_eval[st:end][eval(seq[st:end], res_site)]
    
        # The primer should have a specific lenght (superior than the restriction site)
        # If distribution is asymetrical, take 1 base more from the side with a G/C (benefits stronger binding)
        extra_pb = len_primer - len(res_site)
        if extra_pb % 2 == 1:
            if seq[st-int(len_primer/2)-1 : st-int(len_primer/2)] in 'GC':
                primer = seq[st - int(extra_pb / 2) - 1:st] + res_site + seq[end + 1:end + int(extra_pb / 2)]
            else:
                primer = seq[st - int(extra_pb / 2):st] + res_site + seq[end + 1:end + int(extra_pb / 2) + 1]
        else:
            primer = seq[st - int(extra_pb / 2):st] + res_site + seq[end + 1:end + int(extra_pb / 2)]
    
        return {'Primer': primer,
                'Enzyme': enz_name,
                'Recognition site': lenz + '/' + renz,
                'Nr. mismatch outside': np.count_nonzero(eval_vr == 1),
                'Nr. mismatch inside': np.count_nonzero(eval_vr == integrity_factor),
                'Mismatch score': np.sum(eval_vr),
                'ORS':ORS}


    # Server processing: Calculate the forward and reverse primers
    forw_df = pd.DataFrame({}, columns=('Primer', 'Enzyme', 'Recognition site', 'Nr. mismatch outside',  'Nr. mismatch inside', 'Mismatch score', 'ORS'))
    revr_df = pd.DataFrame({}, columns=('Primer', 'Enzyme', 'Recognition site', 'Nr. mismatch outside',  'Nr. mismatch inside', 'Mismatch score', 'ORS'))

    for name, enz in zip(enzs['Enzyme'],enzs['Restriction Site']):
        # Determine the opening read starts (ors) of the primers based on selected ORF
        if type(orf)==int:
            ors_to_iterate = np.array(range(0,len(lseq)-orf-len(enz.split('/')[0]),3))
        else:
            ors_to_iterate = np.array([0])

        # Forward primer is calculated for each enzyme in each specific start
        for ors in ors_to_iterate:
            forw_df = pd.concat([forw_df, pd.DataFrame.from_records([priming(name, enz, lseq, lseq+insert,len_primer,ors,integrity_factor)])])

        # Reverse primer is calculated for each enzyme in the specific selected cut
        revr_df = pd.concat([revr_df, pd.DataFrame.from_records([priming(name, enz, insert, insert+rseq,len_primer,0,integrity_factor, insert_in_right=False)])])
    
    # The reverse primers have to be in the complementary strand
    revr_df['Primer'] = [comp_dna(reverse) for reverse in revr_df['Primer'] if type(reverse)!=float]

    # Results: Represent the top data with the lowest number of mismatches
    st.markdown('''## Best forward primers''')
    st.dataframe(forw_df.sort_values(['Mismatch score', 'ORS']).head(20))
    st.markdown('''## Best reverse primers''')
    st.dataframe(revr_df.sort_values(['Mismatch score']).head(20))
