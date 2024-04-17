#!/bin/bash -e

rm -f output.tex 
rm -f output.pdf
../2pct.sh input.tex output.tex

# typesettingEngine="pdflatex"
typesettingEngine="xelatex"

# get arguments
file_tex="output.tex"
file_name="output"

# run program, add output to logfile
rm -f ${file_name}.toc
rm -f ${file_name}.apt
rm -f ${file_name}.aux
rm -f ${file_name}.lof
rm -f ${file_name}.lot
rm -f ${file_name}.log
rm -f ${file_name}.out
rm -f ${file_name}.bbl
rm -f ${file_name}.blg
rm -f ${file_name}.pdf
rm -f ${file_name}.nav
rm -f ${file_name}.snm
rm -f missfont.log

${typesettingEngine} -shell-escape ${file_tex} 
# bibtex ${file_name}.aux
sleep 1
${typesettingEngine} -shell-escape ${file_tex} 
${typesettingEngine} -shell-escape ${file_tex} 

# remove program artifacts
rm -f ${file_name}.toc
rm -f ${file_name}.apt
rm -f ${file_name}.aux
rm -f ${file_name}.lof
rm -f ${file_name}.lot
rm -f ${file_name}.log
rm -f ${file_name}.out
rm -f ${file_name}.bbl
rm -f ${file_name}.blg
rm -f ${file_name}.nav
rm -f ${file_name}.snm
rm -f texput.log
