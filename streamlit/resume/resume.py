import streamlit as st
from PIL import Image

with open("streamlit/resume/style.css") as f:
    st.markdown('<style>{}</style>'.format(f.read()), unsafe_allow_html=True)

# Title/Header
st.write('''
# **Gerardo José Rodríguez Alarcón**
#### *Resume & Qualifications as a bioinformatician* 
''')

image = Image.open('streamlit/resume/profile.jpg')
st.image(image, width=700)

st.markdown('## Summary', unsafe_allow_html=True)
def header(url):
    st.markdown(f'<p style="background-color:#008085;color:#F5F5F5;font-size:16px;border-radius:1%;">{url}</p>', unsafe_allow_html=True)
header('''
  <br /> 
 &nbsp; &nbsp;  ► &nbsp  Master student in Bioinformatics (Copenhagen University) with a passion for data analysis. <br />                        
 &nbsp; &nbsp;  ► &nbsp  Strong communication skills for science and a solid background in biochemistry. <br />
 &nbsp; &nbsp;  ► &nbsp  Confident user of Python, Linux, Bash, SQL & R-programming. <br />
 &nbsp; &nbsp;  ► &nbsp  App developer in Rshiny & Streamlit. <br />
 <br />
''')



# Navigation Bar

st.markdown(
    '<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">',
    unsafe_allow_html=True)

st.markdown("""
<nav class="navbar fixed-top navbar-expand-lg navbar-dark" style="background-color: #008080;">
  <a class="navbar-brand" href="https://www.linkedin.com/in/gerardo-ra/?locale=en_US" target="_blank">Gerardo José Rodríguez</a>
  <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
    <span class="navbar-toggler-icon"></span>
  </button>
  <div class="collapse navbar-collapse" id="navbarNav">
    <ul class="navbar-nav">
      <li class="nav-item active">
        <a class="nav-link disabled" href="/">Home <span class="sr-only">(current)</span></a>
      </li>
      <li class="nav-item">
        <a class="nav-link" href="#education">Education</a>
      </li>
      <li class="nav-item">
        <a class="nav-link" href="#experience">Experience</a>
      </li>
      <li class="nav-item">
        <a class="nav-link" href="#bioinformatic-tools-pipelines">Bioinformatic Tools & Pipelines</a>
      </li>
      <li class="nav-item">
        <a class="nav-link" href="#social-media">Social Media</a>
      </li>
      <li class="nav-item">
        <a class="nav-link" href="#availability">Availability</a>
      </li>
      <li class="nav-item">
        <a class="nav-link" href="#contact-me">Contact me</a>
      </li>
    </ul>
  </div>
</nav>
""", unsafe_allow_html=True)



# Function to custom text (in columns)
def txt(a, b):
    col1, col2 = st.columns([4, 1])
    with col1:
        st.markdown(a)
    with col2:
        st.markdown(b)


def txt2(a, b):
    col1, col2 = st.columns([1, 4])
    with col1:
        st.markdown(f'`{a}`')
    with col2:
        st.markdown(b)


def txt3(a, b):
    col1, col2 = st.columns([1, 2])
    with col1:
        st.markdown(a)
    with col2:
        st.markdown(b)

#####################
st.markdown('''
## Education
---
''')

txt('**MSc Bioinformatics**, *Copenhagen University*, Denmark', '2002-2006')
st.markdown('''
- GPA until now: `11` in 7-point grading scale 
- Relevant courses taken: Population genetics, Data Science, Statistics, Structural Bioinformatics
''')
st.markdown(''' ''')
txt('**BSc Biochemistry**, *Complutense University of Madrid*, Spain', '1998-2002')
st.markdown('''
- GPA: `10` in 7-point grading scale 
- Thesis: "Meta-analysis of RNA-seq and microarray raw data of cytarabine's action"
''')

#####################
st.markdown(''' '''); st.markdown(''' ''')
st.markdown('''
## Experience 
---
''')

txt('**Student**, [dEPIMAL](http://www.depimal.es/team.html), Madrid', '2020-2021')
st.markdown('''
- Projects regarding data analysis of biological data using R programming
- Search of data in public repositories, QC, Exploration (PCA, heatmap)
- Disease characterization, Factor analysis, Pathway enrichment
- Weekly group meeting expositions to present our advances
''')


txt('**Content Creator**, Youtube Channel: []()', '2022-Present')
st.markdown('''
- Biotechnology and bioinformatic fields explained from 0
- Science communication in english to a non-specialized audience
''')

txt('**Participation in short-films and development of theatre plays**','2022-Present')
st.markdown('''
- Improvisation and presentation skills
- Organization and teamwork experience
''')

#####################
st.markdown(''' '''); st.markdown(''' ''')
st.markdown('''
## Bioinformatic Tools & Pipelines
---
''')
st.markdown('''► [HMM-profiler](https://share.streamlit.io/gero1999/code/main/streamlit/prot-profiler-app/app.py). Generates the 
            multiple sequence alignment (MSA) of a list of input sequences, as well as the transition and emission matrices 
            defining its Hidden Markov Model profile capturing amino acid conservation and protein family features''')

st.markdown('''► [PairAlign](https://gero1999.shinyapps.io/Pair-Aligner/). Global pair-sequence aligner tool implementing
 the Needleman algorithm (Dynamic programming) by using the scoring system and the linear gap penalty specified by the user for the 2 DNA sequences given as input''')

st.markdown('''► [Texas-Cheater](https://gero1999.shinyapps.io/Texas-Cheater/). A Poker simulator that given the user cards and the number of players computes a customizable 
number of games to predict the chances to possess the winning hand.''')

st.markdown('''► [This resume](https://share.streamlit.io/gero1999/code/main/streamlit/resume/resume.py). This web page was also designed using Streamlit''')


#####################
st.markdown(''' '''); st.markdown(''' ''')
st.markdown('''
## Skills
---''')
txt3('Programming', '`Python`, `R`, `Linux`')
txt3('Data processing/wrangling', '`SQL`, `Pandas`, `Numpy`')
txt3('Statistics', '`MC simulations`, `Bayes`, `General Linear Models`')
txt3('Transcriptomics', '`Limma`, `DESeq2`, `Salmon`')
txt3('Pathway analysis', '`clusterProfiler`, `GSEA`, `iGraph`')
txt3('Data visualization', '`matplotlib`, `seaborn`, `PCA`, `pheatmap`, `ggplot2`')
txt3('Model deployment', '`Streamlit`, `R Shiny`')

#####################
st.markdown(''' '''); st.markdown(''' ''')
st.markdown('''
## Social Media
---
''')
txt2('LinkedIn', 'https://www.linkedin.com/in/gerardo-ra/?locale=en_US')
txt2('GitHub', 'https://github.com/Gero1999')
txt2('ORCID', 'https://orcid.org/my-orcid?orcid=0000-0003-1413-0060')
txt2('Email', 'gerardo.jrac@gmail.com')

#####################
## Availability
st.markdown('<iframe src="https://calendar.google.com/calendar/embed?height=600&wkst=2&bgcolor=%23A79B8E&ctz=Europe%2FCopenhagen&mode=WEEK&showDate=0&showPrint=0&showTabs=1&showCalendars=1&hl=en_GB&showNav=1&showTitle=1&title&src=Z2VyYXJkby5qcmFjQGdtYWlsLmNvbQ&color=%23039BE5" style="border:solid 1px #777" width="800" height="600" frameborder="0" scrolling="no"></iframe>')


####################
st.markdown(''' '''); st.markdown(''' ''')
st.markdown('''
## Contact me  
---
''')
contact = '''
<form action="https://formsubmit.co/gerardo.jrac@gmail.com" method="POST">
     <input type="hidden" name"_captcha" value="false">
     <input type="text" name="name" placeholder="Your name" required>
     <input type="email" name="email" placeholder="Your mail" required>     
     <textarea name='message' placeholder='Message' required></textarea>
     <button type="submit">Send</button>
</form>
'''
left_col, right_col = st.columns([3,1])
with left_col:
    st.markdown(contact, unsafe_allow_html=True)
with right_col:
    st.empty()
