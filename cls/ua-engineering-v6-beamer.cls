\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{ua-engineering-v6-beamer}[2026/04/19 UA Ingeniería v6 beamer]

\RequirePackage{kvoptions}
\SetupKeyvalOptions{family=UABEA,prefix=UABEA@}
\DeclareStringOption[institutional]{cover}
\DeclareStringOption[screen]{mode}
\DeclareStringOption[none]{notes}
\ProcessKeyvalOptions*

\LoadClass[aspectratio=169,professionalfonts]{beamer}
\RequirePackage{../cls/ua-engineering-v6-common}
\RequirePackage{pgfpages}

\usetheme{default}
\setbeamertemplate{navigation symbols}{}
\ifstrequal{\UABEA@notes}{show}{\setbeameroption{show notes}}{}
\ifstrequal{\UABEA@notes}{second}{\setbeameroption{show notes on second screen=right}}{}

\setbeamercolor{normal text}{fg=UAIngText,bg=white}
\setbeamercolor{structure}{fg=UAIngPrimary}
\setbeamercolor{title}{fg=white}
\setbeamercolor{subtitle}{fg=white}
\setbeamercolor{frametitle}{fg=UAIngPrimary,bg=white}
\setbeamercolor{block title}{fg=white,bg=UAIngPrimary}
\setbeamercolor{block body}{fg=UAIngText,bg=UAIngPaper}
\setbeamercolor{footline}{fg=white,bg=UAIngPrimary}

\setbeamerfont{title}{series=\bfseries,size=\LARGE}
\setbeamerfont{subtitle}{size=\large}
\setbeamerfont{frametitle}{series=\bfseries,size=\Large}

\setbeamertemplate{title page}{
\begin{tikzpicture}[remember picture,overlay]
\fill[UAIngPrimary] (current page.south west) rectangle (current page.north east);
\node[anchor=north, yshift=-0.9cm] at (current page.north) {\UAPrintLogo[2.0cm]};
\node[anchor=center, text width=0.80\paperwidth, align=center] at ([yshift=-0.3cm]current page.center) {
{\color{white}\bfseries\LARGE \inserttitle}\\[0.45cm]
{\color{white}\Large \insertsubtitle}\\[0.55cm]
{\color{white}\normalsize \UAUniversity\ --- \UAFaculty}\\[0.12cm]
{\color{white}\normalsize \UADepartment}\\[0.12cm]
{\color{white}\normalsize \UACareer\ --- \UACommission\ --- \UACampus}\\[0.12cm]
{\color{white}\normalsize \UAProfessor\ --- \UADate}
\ifstrempty{\UABuildNumber}{}{\\[0.35cm]{\color{white}\scriptsize \UABuildInfo}}
};
\end{tikzpicture}
}

\setbeamertemplate{frametitle}{%
  \vspace{0.10cm}
  \begin{beamercolorbox}[wd=\paperwidth,leftskip=0.35cm,rightskip=0.35cm,sep=0.12cm]{frametitle}
  \usebeamerfont{frametitle}\insertframetitle
  \par\vspace{0.04cm}{\color{UAIngAccent}\rule{\paperwidth-0.7cm}{0.8pt}}
  \end{beamercolorbox}
}

\setbeamertemplate{footline}{
\leavevmode
\hbox{
  % Logo izquierda
  \begin{beamercolorbox}[wd=.15\paperwidth,ht=2.8ex,dp=1.2ex,leftskip=0.2cm]{footline}
    \UAPrintLogo[0.6cm]
  \end{beamercolorbox}

  % Curso centro
  \begin{beamercolorbox}[wd=.65\paperwidth,ht=2.8ex,dp=1.2ex,center]{footline}
    \small \UACourse\ — Clase \UAClassNumber
  \end{beamercolorbox}

  % Slide number derecha
  \begin{beamercolorbox}[wd=.20\paperwidth,ht=2.8ex,dp=1.2ex,rightskip=0.3cm]{footline}
    \small \insertframenumber/\inserttotalframenumber
  \end{beamercolorbox}
}
}

\newcommand{\UASectionSlide}[1]{%
\begin{frame}[plain]
\begin{tikzpicture}[remember picture,overlay]
\fill[UAIngPrimary] (current page.north west) rectangle (current page.south east);
\fill[UAIngAccent] (current page.south west) rectangle ([yshift=0.20cm]current page.south east);
\node[anchor=north east,inner sep=10pt] at (current page.north east) {\UAPrintLogo[2.35cm]};
\end{tikzpicture}
\vfill
{\color{white}\bfseries\fontsize{28}{32}\selectfont #1\par}
\vfill
\end{frame}
}
