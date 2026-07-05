\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{ua-engineering-v6-article}[2026/04/19 UA Ingeniería v6 article]

\RequirePackage{kvoptions}
\SetupKeyvalOptions{family=UAART,prefix=UAART@}
\DeclareStringOption[apuntes]{variant}
\DeclareStringOption[institutional]{cover}
\DeclareStringOption[screen]{mode}
\ProcessKeyvalOptions*

\LoadClass[11pt,a4paper]{article}
\RequirePackage{../cls/ua-engineering-v6-common}
\RequirePackage[a4paper,margin=2.4cm,headheight=34pt]{geometry}
\RequirePackage{fancyhdr}
\RequirePackage{titlesec}
\RequirePackage{parskip}
\RequirePackage{setspace}
\RequirePackage{enumitem}

\ifstrequal{\UAART@variant}{apuntes}{\UASetDocKind{Apuntes}}{}
\ifstrequal{\UAART@variant}{guia}{\UASetDocKind{Guía de ejercicios}}{}
\ifstrequal{\UAART@variant}{guiaresuelta}{\UASetDocKind{Guía resuelta}}{}
\ifstrequal{\UAART@variant}{docente}{\UASetDocKind{Guía docente}}{}

\pagestyle{fancy}
\fancyhf{}
\fancyhead[L]{\UAPrintLogo[1.05cm]}
\fancyhead[R]{\textbf{\color{UAIngPrimary}\UACourse\\Clase \UAClassNumber --- \UAClassTitle}}
\renewcommand{\headrulewidth}{0.6pt}
\fancyfoot[L]{\small\color{UAIngMuted}\UAUniversity}
\fancyfoot[C]{\small\color{UAIngMuted}\UAFaculty\ --- \UADepartment}
\fancyfoot[R]{\textbf{\thepage}}
\renewcommand{\footrulewidth}{0.3pt}

\titleformat{\section}{\Large\bfseries\color{UAIngPrimary}}{\thesection}{0.75em}{}
\titleformat{\subsection}{\large\bfseries\color{UAIngPrimary}}{\thesubsection}{0.75em}{}
\titleformat{\subsubsection}{\normalsize\bfseries\color{UAIngAccent}}{\thesubsubsection}{0.75em}{}

\renewcommand{\maketitle}{
\begin{titlepage}
\thispagestyle{empty}
\begin{tikzpicture}[remember picture,overlay]
\fill[UAIngPrimary] (current page.north west) rectangle ([yshift=-3.2cm]current page.north east);
\fill[UAIngAccent] ([yshift=-3.2cm]current page.north west) rectangle ([yshift=-2.95cm]current page.north east);
\node[anchor=north west, xshift=1.4cm, yshift=-1.0cm] at (current page.north west) {\UAPrintLogo[2.2cm]};
\end{tikzpicture}

\vspace*{4.1cm}
\begin{center}
{\Large \UAUniversity}\\[0.15cm]
{\large \UAFaculty}\\[0.15cm]
{\large \UADepartment}\\[0.9cm]
{\bfseries\LARGE \UACourse}\\[0.35cm]
{\Large Clase \UAClassNumber --- \UAClassTitle}\\[0.35cm]
{\large \UADocKind}\\[0.8cm]
{\large \UAProfessor}\\[0.2cm]
{\large \UADate}
\ifstrempty{\UABuildNumber}{}{\\[0.45cm]{\small\color{UAIngMuted}\UABuildInfo}}
\end{center}
\vfill
\end{titlepage}
}

\AtBeginDocument{
  \ifstrequal{\UAART@mode}{print}{\color{black}}{\color{UAIngText}}
  \setstretch{1.08}
}
