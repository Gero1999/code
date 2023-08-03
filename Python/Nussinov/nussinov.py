# Define the Nussinov function with the main body code obtained from Absalon
def nussinov(seq, scores={'AU': 1, 'UA': 1, 'GU': 1, 'UG': 1, 'GC': 1, 'CG': 1}, h=3):
    ''' A function that implements the Nussinov algorithm to the input sequence (seq) by
    using the scoring system specified in a explicit dictionary (scores) and a restriction
    imposing a minimum loop size (h) for the output represented using dot-bracket notation.'''

    # Sequence length and initial matrix definition
    l = len(seq)
    m = [[0 for i in range(l)] for j in range(l)]

    # Fill scoring matrix
    for j0 in range(h + 1, l):  # the diagonal of the matrix to loop over
        for i in range(0, l - j0):  # the entry on the diagonal to fill
            j = i + j0
            # rule 1) i,j paired
            if seq[i] + seq[j] in scores:
                m[i][j] = m[i + 1][j - 1] + scores[seq[i] + seq[j]]
            # rule 2) i unpaired
            if m[i + 1][j] > m[i][j]:
                m[i][j] = m[i + 1][j]
            # rule 3) j unpaired
            if m[i][j - 1] > m[i][j]:
                m[i][j] = m[i][j - 1]
            # rule 4) bifurcation k
            for k in range(i + 1 + h, j - 1 - h):
                if m[i][k] + m[k + 1][j] > m[i][j]:
                    m[i][j] = m[i][k] + m[k + 1][j]

    # Backtracking to keep only base pairs that maximize the score
    structure = ['.' for i in range(l)]
    stack = []
    stack.append((0, l - 1))
    while len(stack) > 0:
        top = stack.pop(),
        i = top[0][0]
        j = top[0][1]
        if i >= j:
            continue
        elif m[i + 1][j] == m[i][j]:
            stack.append((i + 1, j))
        elif m[i][j - 1] == m[i][j]:
            stack.append((i, j - 1))
        elif seq[i] + seq[j] in scores and m[i + 1][j - 1] + scores[seq[i] + seq[j]] == m[i][j]:
            structure[i] = "("
            structure[j] = ")"
            stack.append((i + 1, j - 1))
        else:
            for k in range(i + 1 + h, j - 1 - h):
                if m[i][k] + m[k + 1][j] == m[i][j]:
                    stack.append((k + 1, j))
                    stack.append((i, k))
                    break
     # output
    return ''.join(structure)



## Example

# Sequence to compute
seq1 = 'UACUUAAGCCGACAUGAACGGUGACACCUAGCCAAUGUUGAGUCUGAAGAGAAGAACUUCAAGUACAGUAAAUGGUAGGUUAU'

# Do the Nussinov implementation to the sequences and find the loops using a regular expression
import re
loops_s1 = [m.span() for m in re.finditer('[\(\)]\.{3,}[\(\)]', nussinov(seq=seq1, h=3))]
