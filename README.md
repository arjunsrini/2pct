# 2pct

$\LaTeX$ automation with shell functions

This tool processes a `.tex` file by running every line that starts with `%%` as a shell command. This allows for the automation of common $\LaTeX$ tasks (including templates, formatting tables, and inserting figures).

This tool is meant to be extensible (e.g. use your own templates, write your own shell functions). Feel free to share what you come up with!

## Installation

Clone the repo where you'd like to keep it, make the script `2pct.sh` executable (`chmod +x 2pct.sh`) and (assuming `usr/local/bin` is in your path) symlink the script to `/usr/local/bin/2pct` (`ln -s /path/to/2pct.sh /usr/local/bin/2pct`).

## Example Usage

From the `example` directory, the command `2pct input.tex output.tex` will turn

```latex 
% input.tex

%% 2pct_template fancypreamble.tex

\newcommand{\TwoPctTitle}{\texttt{2pct} Example}
\newcommand{\TwoPctDate}{\today}
\newcommand{\TwoPctAuthor}{arjun}
\newcommand*{\plogo}{\fbox{$\mathcal{SEL}$} \smiley{}}
\newcommand{\TwoPctPublisher}{Some Economics Lab~~\plogo}

\begin{document}

%% 2pct_template fancytitlepage.tex
%% 2pct_template toctf.tex

\section{Introduction}

This is a test file for the \texttt{2pct} command.

\section{Results}

%% format_table "tbl/table_reg.tex" "Engine Displacement and Fuel Economy" "tab:reg" 

%% 2pct_ls "fig" "*.jpg" "exhibit_metadata.csv" "./fig"

\end{document}
```

into

```latex
% input.tex

% start of fancypreamble.tex 

\documentclass{article}
\usepackage[left=3.75cm, right=3.75cm, top=2cm, bottom=2cm]{geometry}
\usepackage[section]{placeins}
\usepackage{amsmath}
\usepackage{bookmark}
\usepackage{tikz}
\usepackage{hyperref}
\usepackage{xstring}
\usepackage{comment}
\usepackage{listings}
\usepackage{soul}
\usepackage{makecell}
\usepackage{fancyhdr} % For headers with link to table of contents for example

\providecommand{\tabularnewline}{\\}

\usepackage{wasysym}

\hypersetup{
    colorlinks=true,
    linkcolor={rgb:red,4;green,119;blue,204}, % Light Blue
    filecolor={rgb:red,4;green,119;blue,204}, % Light Blue
    urlcolor={rgb:red,4;green,119;blue,204}, % Light Blue
}

\lstset{ % Setup listings
  basicstyle=\ttfamily\footnotesize, % Set your preferences
  frame=single, % Adds a frame around the code
  breaklines=true, % Wrap long lines
  numbers=left, % Line numbers on left
  numberstyle=\tiny, % Size of the numbers
  tabsize=2 % Size of tabs
}

% end of fancypreamble.tex

\newcommand{\TwoPctTitle}{\texttt{2pct} Example}
\newcommand{\TwoPctDate}{\today}
\newcommand{\TwoPctAuthor}{arjun}
\newcommand*{\plogo}{\fbox{$\mathcal{SEL}$} \smiley{}}
\newcommand{\TwoPctPublisher}{Some Economics Lab~~\plogo}

\begin{document}

% start of fancytitlepage.tex 

% based off of a title page by Peter Wilson (see https://ctan.org/pkg/titlepages)
% with modifications by Vel (vel@latextemplates.com)
% from LaTeX templates https://www.latextemplates.com/template/vertical-line-title-page

% defaults
\providecommand{\TwoPctTitle}{Untitled}
\providecommand{\TwoPctDate}{\today}
\providecommand{\TwoPctAuthor}{anonymous}
\providecommand*{\plogo}{\fbox{$\mathcal{ACME}$} \smiley{}} % Generic dummy publisher logo
\providecommand{\TwoPctPublisher}{Acme Lab~~\plogo}

\begin{titlepage} % Suppresses displaying the page number on the title page and the subsequent page counts as page 1
	
	\raggedleft % Right align the title page
	
	\rule{1pt}{\textheight} % Vertical line
	\hspace{0.05\textwidth} % Whitespace between the vertical line and title page text
	\parbox[b]{0.75\textwidth}{ % Paragraph box for holding the title page text, adjust the width to move the title page left or right on the page
		
		{\Huge\bfseries \TwoPctTitle} \\[0.5\baselineskip] % Title
		{\large\textit{\TwoPctDate}}\\[4\baselineskip] % Subtitle or further description
		{\Large\textsc{\TwoPctAuthor}} % Author name, lower case for consistent small caps
		
		\vspace{0.5\textheight} % Whitespace between the title block and the publisher
		
        {\noindent \TwoPctPublisher}\\[\baselineskip] % Publisher and logo
		
	}

\end{titlepage}

\clearpage

% end of fancytitlepage.tex
% start of toctf.tex 

% table of contents, tables, and figures

\tableofcontents
\listoftables
\listoffigures

\clearpage

% end of toctf.tex

\section{Introduction}

This is a test file for the \texttt{2pct} command.

\section{Results}

\begin{table}[h]
    \caption{\textbf{ Engine Displacement and Fuel Economy  \label{ tab:reg }  }}
    \vspace{1em}
    \begin{centering}
    \input{ tbl/table_reg.tex }
    \par
    \medskip{}
    % {\small{}  }{\small\par}
    \end{centering}
\end{table}

\begin{figure}[!htb]
    \centering
    \includegraphics[width=0.8\textwidth]{ ./fig/figure_city.jpg }
    \caption{\textbf{ City Fuel Economy by Engine Displacement  \label{ fig:city } }}
    \medskip{}
    {\small{}  }{\small\par}
\end{figure}


\begin{figure}[!htb]
    \centering
    \includegraphics[width=0.8\textwidth]{ ./fig/figure_hwy.jpg }
    \caption{\textbf{ Highway Fuel Economy by Engine Displacement  \label{ fig:hwy } }}
    \medskip{}
    {\small{}  }{\small\par}
\end{figure}

\end{document}
```

which, when compiled, will produce [this pdf](./example/output.pdf).

## More Info

[Wiki](#) tk.

## Acknowledgements

* [Peter Wilson](https://ctan.org/pkg/titlepages) and [LaTeX templates](https://www.latextemplates.com/template/vertical-line-title-page) for the title page template
* [Freek](https://github.com/freek-van-sambeek) for the fancy header 

## License (CC0 1.0 Universal License)

This is just a few shell functions. Anyone can use this for any purpose without any conditions. It is dedicated to the public domain. 🌲
