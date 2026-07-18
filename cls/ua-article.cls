\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{ua-article}[2026/04/19 UA article]

\LoadClass[11pt,a4paper]{article}
\RequirePackage{../cls/ua-common}
\RequirePackage[a4paper,margin=2.5cm,headheight=38pt]{geometry}
\RequirePackage{fancyhdr}
\RequirePackage{titlesec}
\RequirePackage{enumitem}
\RequirePackage{parskip}
\RequirePackage{setspace}

\pagestyle{fancy}
\fancyhf{}
\fancyhead[L]{\UAPrintLogo[1.0cm]}
\fancyhead[R]{\textbf{\color{UAIngPrimary}\UACourse\\Clase \UAClassNumber --- \UAClassTitle}}
\renewcommand{\headrulewidth}{0.6pt}
\fancyfoot[L]{\small\color{UAIngMuted}\UAUniversity}
\fancyfoot[C]{\small\color{UAIngMuted}\UAFaculty\ --- \UADepartment}
\fancyfoot[R]{\textbf{\thepage}}
\renewcommand{\footrulewidth}{0.3pt}

\titleformat{\section}{\Large\bfseries\color{UAIngPrimary}}{\thesection}{0.8em}{}
\titleformat{\subsection}{\large\bfseries\color{UAIngPrimary}}{\thesubsection}{0.8em}{}
\titleformat{\subsubsection}{\normalsize\bfseries\color{UAIngAccent}}{\thesubsubsection}{0.8em}{}

\renewcommand{\maketitle}{
\begin{titlepage}
\thispagestyle{empty}
\begin{tikzpicture}[remember picture,overlay]
\fill[UAIngPrimary] (current page.north west) rectangle ([yshift=-3.4cm]current page.north east);
\fill[UAIngAccent] ([yshift=-3.4cm]current page.north west) rectangle ([yshift=-3.1cm]current page.north east);
\node[anchor=north west, xshift=1.4cm, yshift=-0.9cm] at (current page.north west) {\UAPrintLogo[2.25cm]};
\end{tikzpicture}

\vspace*{4.3cm}
\begin{center}
{\Large \UAUniversity}\\[0.1cm]
{\large \UAFaculty}\\[0.1cm]
{\large \UADepartment}\\[0.8cm]
{\bfseries\LARGE \UACourse}\\[0.3cm]
{\Large Clase \UAClassNumber --- \UAClassTitle}\\[0.3cm]
{\large \UADocKind}\\[0.8cm]
{\large \UAProfessor}\\[0.2cm]
{\large \UADate}
\end{center}
\vfill
\end{titlepage}
}
\AtBeginDocument{\setstretch{1.08}}
