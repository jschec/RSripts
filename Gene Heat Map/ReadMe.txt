Written by Joshua Scheck on Nov. 29th, 2018


This script leverages the complex heat map R package to draw several different heat maps separated by color strips. Data used for this script is provided in the "Gene Panel Coverage Data" directory in the form of two excel spreadsheets labeled as "final_pg1.xlsx" and "final_pg2.xlsx". These are two halves of the NCHIP gene panel with nonzero coverage data. As it's currently written, the R script clusters the genes into 3 groups of 32 genes per spreadsheet using the "group" column. However, gene ontologies could be placed into this column to get the script to cluster genes in accordance to their ontologies.

