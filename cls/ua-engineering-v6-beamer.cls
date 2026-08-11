\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{ua-engineering-v6-beamer}[2026/08/02 UA Ingenieria v6.2 beamer]

\RequirePackage{kvoptions}
\SetupKeyvalOptions{family=UABEA,prefix=UABEA@}
\DeclareStringOption[institutional]{cover}
\DeclareStringOption[screen]{mode}
\DeclareStringOption[none]{notes}
\ProcessKeyvalOptions*

\LoadClass[aspectratio=169,professionalfonts]{beamer}

\IfFileExists{ua-engineering-v6-common.sty}
  {\RequirePackage{ua-engineering-v6-common}}
  {\IfFileExists{../cls/ua-engineering-v6-common.sty}
     {\RequirePackage{../cls/ua-engineering-v6-common}}
     {\IfFileExists{../../../02_Fuentes_y_herramientas/cls/ua-engineering-v6-common.sty}
        {\RequirePackage{../../../02_Fuentes_y_herramientas/cls/ua-engineering-v6-common}}
        {\ClassError{ua-engineering-v6-beamer}
          {No se encontro ua-engineering-v6-common.sty}
          {Copie la clase, el estilo y el logo junto al archivo .tex.}}}}
\RequirePackage{pgfpages}

\usetheme{default}
\setbeamertemplate{navigation symbols}{}
\setbeamersize{text margin left=0.66cm,text margin right=0.66cm}

\ifdefstring{\UABEA@notes}{show}{\setbeameroption{show notes}}{}
\ifdefstring{\UABEA@notes}{second}{\setbeameroption{show notes on second screen=right}}{}

\setbeamercolor{normal text}{fg=UAIngText,bg=white}
\setbeamercolor{structure}{fg=UAIngNavy}
\setbeamercolor{title}{fg=white}
\setbeamercolor{subtitle}{fg=white}
\setbeamercolor{frametitle}{fg=UAIngNavy,bg=white}
\setbeamercolor{block title}{fg=white,bg=UAIngNavy}
\setbeamercolor{block body}{fg=UAIngText,bg=UAIngPaper}
\setbeamercolor{alerted text}{fg=UAIngOrange}
\setbeamercolor{footline}{fg=UAIngMuted,bg=white}

\setbeamerfont{title}{series=\bfseries,size=\LARGE}
\setbeamerfont{subtitle}{size=\large}
\setbeamerfont{frametitle}{series=\bfseries,size=\Large}
\setbeamerfont{footline}{size=\scriptsize}

\setbeamertemplate{itemize item}{\color{UAIngOrange}\raisebox{0.15ex}{\small$\blacktriangleright$}}
\setbeamertemplate{itemize subitem}{\color{UAIngNavy}\raisebox{0.15ex}{\scriptsize$\blacktriangleright$}}
\setbeamertemplate{enumerate item}{\color{UAIngOrange}\insertenumlabel.}
\setbeamertemplate{caption label separator}{: }

\setbeamertemplate{title page}{
\begin{tikzpicture}[remember picture,overlay]
  \fill[UAIngOrange] (current page.south west) rectangle (current page.north east);
  \fill[UAIngNavy] (current page.south west) rectangle ([yshift=0.18cm]current page.south east);
  \node[anchor=north west,inner sep=0pt] at
    ([xshift=0.82cm,yshift=-0.45cm]current page.north west)
    {\UAPrintLogoWide[4.35cm]};
  \node[anchor=west,text width=0.83\paperwidth,align=left,inner sep=0pt] at
    ([xshift=0.88cm,yshift=0.05cm]current page.west) {%
      {\color{white}\bfseries\LARGE\inserttitle}\par\vspace{0.30cm}
      {\color{white}\Large\insertsubtitle}%
    };
  \node[anchor=south west,text width=0.83\paperwidth,align=left,inner sep=0pt] at
    ([xshift=0.88cm,yshift=0.62cm]current page.south west) {%
      {\color{white}\small\bfseries \UADepartment}\par\vspace{0.07cm}
      {\color{white}\small \UACareer\ -- \UACommission\ -- \UACampus}\par\vspace{0.05cm}
      {\color{white}\small \UAProfessor\ -- \UADate}%
    };
\end{tikzpicture}
}

\setbeamertemplate{frametitle}{%
  \nointerlineskip
  \begin{beamercolorbox}[wd=\paperwidth,leftskip=0.66cm,rightskip=0.66cm,sep=0.16cm]{frametitle}
    \usebeamerfont{frametitle}\insertframetitle
    \par\vspace{0.05cm}{\color{UAIngOrange}\rule{\dimexpr\paperwidth-1.66cm\relax}{0.9pt}}
  \end{beamercolorbox}
}

\setbeamertemplate{footline}{%
  \leavevmode
  \hbox{%
    \begin{beamercolorbox}[wd=.24\paperwidth,ht=3.5ex,dp=1.35ex,leftskip=0.24cm]{footline}
      \raisebox{0.04cm}{\UAPrintFooterLogoWide[2.55cm]}
    \end{beamercolorbox}%
    \begin{beamercolorbox}[wd=.62\paperwidth,ht=3.5ex,dp=1.35ex,center]{footline}
      \usebeamerfont{footline}\color{UAIngMuted}\UACourse%
      \ifstrempty{\UAClassNumber}{}{\ -- Clase \UAClassNumber}%
    \end{beamercolorbox}%
    \begin{beamercolorbox}[wd=.14\paperwidth,ht=3.5ex,dp=1.35ex,rightskip=0.34cm]{footline}
      \hfill\usebeamerfont{footline}\color{UAIngNavy}\bfseries
      \insertframenumber/\inserttotalframenumber
    \end{beamercolorbox}%
  }%
  \begin{tikzpicture}[remember picture,overlay]
    \draw[UAIngOrange,line width=0.75pt]
      ([yshift=0.72cm]current page.south west) --
      ([yshift=0.72cm]current page.south east);
  \end{tikzpicture}%
}

\newcommand{\UASectionSlide}[1]{%
\begin{frame}[plain]
\begin{tikzpicture}[remember picture,overlay]
  \fill[UAIngOrange] (current page.south west) rectangle (current page.north east);
  \fill[UAIngNavy] (current page.south west) rectangle ([yshift=0.18cm]current page.south east);
  \node[anchor=north east,inner sep=0pt] at
    ([xshift=-0.70cm,yshift=-0.45cm]current page.north east)
    {\UAPrintLogoWide[3.55cm]};
  \node[anchor=west,text width=0.80\paperwidth,align=left,inner sep=0pt] at
    ([xshift=0.90cm,yshift=-0.20cm]current page.west)
    {{\color{white}\bfseries\fontsize{28}{33}\selectfont #1}};
  \node[anchor=south west,inner sep=0pt] at
    ([xshift=0.90cm,yshift=0.50cm]current page.south west)
    {{\color{white}\small\bfseries \UACourse}};
\end{tikzpicture}
\end{frame}
}
