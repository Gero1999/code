def extract_fasta(path_to_fasta_file):
    '''Opens and read the fasta file introduced (path_to_fasta_file) and returns a dictionary that stores
    from the fasta file each protein name (key) with its corresponding sequence (value). The strategy used was to
    substitute new lines (\n) with ">" so then by split every part of information can be orderly extracted'''
    fasta = '>' + open(path_to_fasta_file).read().replace("\n", '>')
    fasta = fasta.split('>>'); dicc = dict()
    for n in range(1, len(fasta)):
        sep_info = fasta[n].split('>')
        dicc[sep_info[0]] = ''.join(sep_info[1:])
    return(dicc)


def find_protein(dicc, prot_name):
    '''Looks in a dictionary (dictio) defined by protein names (keys) and its sequences (values) and a query
    (prot_name) returning the sequence associated. If the query prot_name is not in dict, returns None and prints an error message'''
    if prot_name in dicc.keys():
        return(dicc[prot_name])
    else:
        print('Error: protein name', prot_name, 'not found'); return(None)


def guess_protein(dicc, reg_exp):
    '''Looks for a regular expression among the keys (protein names) of a dictionary in a loop, looking for match'''
    list = []
    for key in dicc.keys():
        if re.match(reg_exp, key) != None:
            list.append(key)
    return(list)
