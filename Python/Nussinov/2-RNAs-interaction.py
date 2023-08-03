

## Additional use: Predict the interaction between two RNA based on their left base pairs 

# Sequences to compute
seq1 = 'UACUUAAGCCGACAUGAACGGUGACACCUAGCCAAUGUUGAGUCUGAAGAGAAGAACUUCAAGUACAGUAAAUGGUAGGUUAU'
seq2 = 'UUCCUUUGGGCCCUGUUGGGGCCCAAAGGGGUUCUUCAAAACGCGCUGCCCUUCUUCUGGGCAGCGCGUUUU'

import Nussinov
# Do the Nussinov implementation to the sequences and find the loops using a regular expression
import re
loops_s1 = [m.span() for m in re.finditer('[\(\)]\.{3,}[\(\)]', nussinov(seq=seq1, h=3))]
loops_s2 = [m.span() for m in re.finditer('[\(\)]\.{3,}[\(\)]', nussinov(seq=seq2, h=3))]

# All possible combinations between loops is performed
combinations = [(x, y) for x in loops_s1 for y in loops_s2]

# Represent the combinations in two dataframes, one storing the dot-bracket representation and the other one the max points
import pandas as pd
df_str = pd.DataFrame(columns=loops_s1, index=loops_s2)
df_pts = pd.DataFrame(columns=loops_s1, index=loops_s2)
for comb in combinations:
    # String sequences to compare
    loop1 = seq1[comb[0][0]+1:comb[0][1]-1]
    loop2 = seq2[comb[1][0]+1:comb[1][1]-1]

    # String structures predicted and nr of base pairs (points)
    max_l = max(len(loop1), len(loop2))
    structure = nussinov(loop1 + 'X'*max_l + loop2, h=max_l)
    structure = structure[0:len(loop1)]+'  '+structure[len(loop1)+max_l:len(loop1)+max_l+len(loop2)]
    points_str = len(structure.split('('))-1

    # Dataframe summaries of the representations and the points
    df_str[comb[0]][comb[1]] = structure
    df_pts[comb[0]][comb[1]] = points_str

# Print results
print(df_str)   # Represent (one of) the potential interaction between loops (columns: seq1 loop indices, index: seq2 loop indices)
print(df_pts)   # Represent the maximum base pair number that can occur for each loop interaction
