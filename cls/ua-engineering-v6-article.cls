\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{ua-engineering-v6-article}[2026/08/02 UA Ingenieria v6.2 article]

\RequirePackage{kvoptions}
\SetupKeyvalOptions{family=UAART,prefix=UAART@}
\DeclareStringOption[apuntes]{variant}
\DeclareStringOption[institutional]{cover}
\DeclareStringOption[screen]{mode}
\ProcessKeyvalOptions*

\LoadClass[11pt,a4paper]{article}

% El estilo puede estar junto a la clase o en la carpeta maestra del curso.
\IfFileExists{ua-engineering-v6-common.sty}
  {\RequirePackage{ua-engineering-v6-common}}
  {\IfFileExists{../cls/ua-engineering-v6-common.sty}
     {\RequirePackage{../cls/ua-engineering-v6-common}}
     {\IfFileExists{../../../02_Fuentes_y_herramientas/cls/ua-engineering-v6-common.sty}
        {\RequirePackage{../../../02_Fuentes_y_herramientas/cls/ua-engineering-v6-common}}
        {\ClassError{ua-engineering-v6-article}
          {No se encontro ua-engineering-v6-common.sty}
          {Copie la clase, el estilo y el logo junto al archivo .tex.}}}}

\RequirePackage[a4paper,margin=2.35cm,headheight=45pt,headsep=16pt,footskip=30pt]{geometry}
\RequirePackage{fancyhdr}
\RequirePackage{titlesec}
\RequirePackage{parskip}
\RequirePackage{setspace}
\RequirePackage{enumitem}

\ifdefstring{\UAART@variant}{apuntes}{\UASetDocKind{Apuntes extendidos}}{}
\ifdefstring{\UAART@variant}{guia}{\UASetDocKind{Guía de ejercicios}}{}
\ifdefstring{\UAART@variant}{guiaresuelta}{\UASetDocKind{Guía resuelta}}{}
\ifdefstring{\UAART@variant}{docente}{\UASetDocKind{Guía docente}}{}

\pagestyle{fancy}
\fancyhf{}
\fancyhead[L]{\UAPrintLogo[1.05cm]}
\fancyhead[R]{%
  \begin{minipage}[b]{0.50\textwidth}
    \raggedleft\small
    \textbf{\color{UAIngNavy}\UACourse}\\[-0.05cm]
    \color{UAIngMuted}Clase \UAClassNumber\ -- \UAClassTitle
  \end{minipage}}
\renewcommand{\headrulewidth}{0pt}
\renewcommand{\footrulewidth}{0pt}
\fancyfoot[L]{\small\color{UAIngMuted}\UAFaculty}
\fancyfoot[C]{\small\color{UAIngMuted}\UADepartment}
\fancyfoot[R]{\textbf{\color{UAIngNavy}\thepage}}

\titleformat{\section}
  {\Large\bfseries\color{UAIngNavy}}{\thesection}{0.75em}{}
  [\vspace{0.12em}{\color{UAIngOrange}\titlerule[0.8pt]}]
\titleformat{\subsection}
  {\large\bfseries\color{UAIngNavy}}{\thesubsection}{0.75em}{}
\titleformat{\subsubsection}
  {\normalsize\bfseries\color{UAIngOrange}}{\thesubsubsection}{0.75em}{}

\setlist[itemize]{label=\textcolor{UAIngOrange}{\small$\blacktriangleright$},leftmargin=1.5em}
\setlist[enumerate]{leftmargin=1.7em}

\newcommand{\UAInstitutionalTitlePage}{%
\hypersetup{pageanchor=false}%
\begin{titlepage}
\thispagestyle{empty}
\begin{tikzpicture}[remember picture,overlay]
  \fill[UAIngOrange] (current page.north west) rectangle ([yshift=-4.45cm]current page.north east);
  \fill[UAIngNavy] ([yshift=-4.45cm]current page.north west) rectangle ([yshift=-4.27cm]current page.north east);
  \node[anchor=north west,inner sep=0pt] at
    ([xshift=1.35cm,yshift=-0.55cm]current page.north west)
    {\UAPrintLogoWide[5.35cm]};
\end{tikzpicture}

\vspace*{5.10cm}
{\color{UAIngOrange}\bfseries\large\MakeUppercase{\UADocKind}}\par
\vspace{0.30cm}
{\color{UAIngNavy}\bfseries\LARGE \UACourse}\par
\vspace{0.36cm}
{\color{UAIngText}\Large Clase \UAClassNumber\ -- \UAClassTitle}\par
\vspace{0.62cm}
{\color{UAIngOrange}\rule{0.22\textwidth}{1.2pt}}\par
\vspace{0.55cm}
{\large\bfseries\color{UAIngNavy}\UADepartment}\par
\vspace{0.12cm}
{\large\color{UAIngText}\UACareer\ -- \UACommission}\par
\vspace{0.10cm}
{\normalsize\color{UAIngMuted}\UACampus\ -- \UASemester}\par
\vfill
{\normalsize\bfseries\color{UAIngNavy}\UAProfessor}\par
\vspace{0.10cm}
{\normalsize\color{UAIngMuted}\UADate}\par
\end{titlepage}
\hypersetup{pageanchor=true}%
}

\newcommand{\UACompactTitle}{%
  \thispagestyle{fancy}
  {\color{UAIngOrange}\bfseries\large\MakeUppercase{\UADocKind}}\par
  {\color{UAIngNavy}\bfseries\LARGE \UACourse}\par
  {\color{UAIngText}\Large Clase \UAClassNumber\ -- \UAClassTitle}\par
  \vspace{0.25cm}{\color{UAIngOrange}\rule{\textwidth}{0.9pt}}\par\vspace{0.55cm}
}

\renewcommand{\maketitle}{%
  \ifdefstring{\UAART@cover}{none}{\UACompactTitle}{\UAInstitutionalTitlePage}%
}

\AtBeginDocument{%
  \ifdefstring{\UAART@mode}{print}{\color{black}}{\color{UAIngText}}
  \setstretch{1.08}
}
