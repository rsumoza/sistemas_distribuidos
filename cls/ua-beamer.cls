\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{ua-beamer}[2026/04/21 UA beamer polished]

\LoadClass[aspectratio=169,professionalfonts]{beamer}
\RequirePackage{../cls/ua-common}

\usetheme{default}
\setbeamertemplate{navigation symbols}{}

\setbeamercolor{normal text}{fg=black,bg=white}
\setbeamercolor{frametitle}{fg=UAIngPrimary,bg=white}
\setbeamercolor{footline}{fg=white,bg=UAIngPrimary}
\setbeamercolor{block title}{fg=white,bg=UAIngPrimary}
\setbeamercolor{block body}{fg=black,bg=UAIngPaper}

\setbeamerfont{title}{series=\bfseries,size=\LARGE}
\setbeamerfont{subtitle}{size=\large}
\setbeamerfont{frametitle}{series=\bfseries,size=\Large}

% -------------------------------------------------
% FOOTLINE NORMAL (para slides comunes)
% -------------------------------------------------
\setbeamertemplate{footline}{%
\leavevmode
\hbox{
\begin{beamercolorbox}[wd=.16\paperwidth,ht=3.1ex,dp=1.25ex,leftskip=0.18cm]{footline}
\UAPrintLogo[0.82cm]
\end{beamercolorbox}
\begin{beamercolorbox}[wd=.64\paperwidth,ht=3.1ex,dp=1.25ex,center]{footline}
\small \UACourse\ --- Clase \UAClassNumber
\end{beamercolorbox}
\begin{beamercolorbox}[wd=.20\paperwidth,ht=3.1ex,dp=1.25ex,rightskip=0.30cm plus 1fil]{footline}
\small \insertframenumber/\inserttotalframenumber
\end{beamercolorbox}
}
}

% -------------------------------------------------
% FRAMETITLE
% -------------------------------------------------
\setbeamertemplate{frametitle}{%
\vspace{0.08cm}
\begin{beamercolorbox}[wd=\paperwidth,leftskip=0.35cm,rightskip=0.35cm,sep=0.10cm]{frametitle}
\usebeamerfont{frametitle}\insertframetitle
\par\vspace{0.04cm}
{\color{UAIngAccent}\rule{\dimexpr\paperwidth-0.7cm\relax}{0.8pt}}
\end{beamercolorbox}
}

% -------------------------------------------------
% PORTADA
% -------------------------------------------------
\setbeamertemplate{title page}{
\begin{tikzpicture}[remember picture,overlay]

% Fondo principal
\fill[UAIngPrimary] (current page.south west) rectangle (current page.north east);

% Franja naranja superior más visible
\fill[UAIngAccent] (current page.north west) rectangle ([yshift=-1.45cm]current page.north east);

% Logo principal: más grande y mejor ubicado
\node[anchor=north, yshift=-0.78cm] at (current page.north) {
    \UAPrintLogo[3.25cm]
};

% Bloque central
\node[
    anchor=center,
    text width=0.82\paperwidth,
    align=center
] at ([yshift=-1.65cm]current page.center) {

{\color{white}\bfseries\LARGE \inserttitle}\\[0.35cm]

{\color{white}\Large \insertsubtitle}\\[0.55cm]

{\color{white}\normalsize \UAUniversity}\\
{\color{white}\normalsize \UAFaculty}\\
{\color{white}\normalsize \UADepartment}\\[0.18cm]

{\color{white}\normalsize \UACareer\ --- \UACommission\ --- \UACampus}\\
{\color{white}\normalsize \UAProfessor\ --- \UADate}
};

\end{tikzpicture}
}

% -------------------------------------------------
% SLIDE DE SECCIÓN
% -------------------------------------------------
\newcommand{\UASectionSlide}[1]{%
\begin{frame}[plain]
\begin{tikzpicture}[remember picture,overlay]
\fill[UAIngPrimary] (current page.north west) rectangle (current page.south east);
\fill[UAIngAccent] (current page.south west) rectangle ([yshift=0.20cm]current page.south east);
\node[anchor=north east,inner sep=10pt] at (current page.north east) {\UAPrintLogo[1.45cm]};
\end{tikzpicture}
\vfill
{\color{white}\bfseries\fontsize{28}{32}\selectfont #1\par}
\vfill
\end{frame}
}
