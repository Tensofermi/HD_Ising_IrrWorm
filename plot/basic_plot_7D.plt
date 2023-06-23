set terminal pdfcairo lw 1 font "Times-Roman,12"

d = 7


set output "../FIG/Two_sectors.pdf"
set logscale xy
# set xrange [243:35831808]
# set yrange [0.15:1]
set format x "10^{%L}"
set xlabel "{/Times-Italic V}" font "Times-Roman,20"
set ylabel "{/Times-Italic P}" font "Times-Roman,20"
set key top
set xtics (1e3,1e4,1e5,1e6,1e7)
set ytics (0.2,0.4,0.6,0.8,1)
set xtics nomirror
set ytics nomirror
set pointsize 0.5

plot 0.88*x**(-1.0/12.0) dt 2 lc rgb  'black'  lw 0.4 t 'slope -1/12',\
1.60*x**(-3.0/28.0) dt 2 lc rgb  'red'  lw 0.4 t 'slope -3/28',\
"../data/basic/cmp_P_C1_l_2.txt" u (($1)**(7.0)):($2*1.79):3 with errorbars  pt 5 lc rgb "red"  t 'C1<2',\
"../data/basic/cmp_P_C1_l_7_3.txt" u (($1)**(7.0)):($2*0.93):3 with errorbars  pt 5 lc rgb "green"  t 'C1<7/3'


reset  #==============================#














# ##########################################################
# ###############========C1&C2&Tworm========################
# ##########################################################
# set output "../FIG/basic_C1_C2_".sprintf("%d",d)."D.pdf"

# set logscale xy
# unset tics
# set xtics (1e1)
# set ytics (1e0,1e1,1e2,1e3,1e4,1e5)
# set xlabel "{/Times-Italic L}" font "Times-Roman,13"
# set ylabel "{/Times-Italic C_1, C_2}" font "Times-Roman,13" offset -0.5
# set format x "10^{%L}"
# set format y "10^{%L}"
# set xrange [3:13]
# set pointsize 0.9
# set key bottom
# set key spacing 1.5

# plot "../data/basic/cmp_C1.txt" u ($1):($2*($1**d)):($3*($1**d)) with errorbars  pt 4 lc rgb "blue"  t '{/Times-Italic d}='.sprintf("%d",d).' C_1',\
# "../data/basic/cmp_C2.txt"  u ($1):($2*($1**d)):($3*($1**d)) with errorbars  pt 6  lc rgb "blue"  t '{/Times-Italic d}='.sprintf("%d",d).' C_2',\
# 0.52*x**(d/2.0)  dt 2 lc rgb 'blue'  lw 1 title 'slope '.sprintf("%d",d).'/2',\
# 0.11*x**(d/2.0)  dt 2 lc rgb 'blue'  lw 1 notit


# reset #==============================#

# set output "../FIG/basic_Tworm_".sprintf("%d",d)."D.pdf"

# set logscale xy
# unset tics
# set xtics (1e1)
# set ytics (1e1,1e2,1e3,1e4,1e5,1e6)
# set xlabel "{/Times-Italic L}" font "Times-Roman,13"
# set ylabel "τ_w" font "Times-Roman,13"  offset -0.6
# set format x "10^{%L}"
# set format y "10^{%L}"
# set xrange [3:13]
# set pointsize 0.9
# set key bottom
# set key spacing 1.5


# plot "../data/basic/cmp_Tworm.txt" u (($1)):($2*($1**d)):($3*($1**d)) with errorbars  pt 4 lc rgb "blue" t '{/Times-Italic d}='.sprintf("%d",d).' τ_w',\
# 1.47*x**(d/2.0)  dt 2 lc rgb 'blue'  lw 1 title 'slope '.sprintf("%d",d).'/2'

# set output

# reset #==============================#


# ##########################################################
# ################==========R1&R2==========#################
# ##########################################################

# set output "../FIG/basic_R1_R2_".sprintf("%d",d)."D.pdf"

# set logscale xy
# unset tics
# set xtics (1e1)
# set ytics (1e0,1e1,1e2,1e3)
# set xlabel "{/Times-Italic L}" font "Times-Roman,13"
# set ylabel "{/Times-Italic R_1, R_2}" font "Times-Roman,13" 
# set format x "10^{%L}"
# set format y "10^{%L}"
# set xrange [3:13]
# set pointsize 0.9
# set key bottom
# set key spacing 1.5

# plot   "../data/basic/cmp_R1.txt" u 1:2:3 with errorbars  pt 21 lc rgb "red" t '{/Times-Italic d}='.sprintf("%d",d).' R_1',\
#  "../data/basic/cmp_R2.txt" u 1:2:3 with errorbars  pt 25 lc rgb "red" t '{/Times-Italic d}='.sprintf("%d",d).' R_2',\
# 0.25*x**(d/4.0) dt 2 lw 1 lc rgb 'red'  t 'slope '.sprintf("%d",d).'/4',\
# 0.115*x**(d/4.0) dt 2 lw 1 lc rgb 'red'  notit


# set output

# reset #==============================#

# ##########################################################
# ##############============N1&N2============###############
# ##########################################################

# set output "../FIG/basic_N1_".sprintf("%d",d)."D.pdf"

# set logscale x
# set xlabel "{/Times-Italic L}" font "Times-Roman,15"
# set ylabel "{/Times-Italic N_1 (s>L^2)}" font "Times-Roman,15"
# set xrange [3:20]
# set pointsize 0.6
# set key bottom

# plot "../data/basic/cmp_N1_r3.txt" u ($1):2:3 with errorbars  pt 6 lc rgb "red"  t 'N_{1}{/Times-Italic , d}=7',\
# 0.72*log(x)+0.07


# set output

# reset  #==============================#


# set output "../FIG/basic_N2_".sprintf("%d",d)."D.pdf"

# set logscale x
# set xlabel "{/Times-Italic L}" font "Times-Roman,15"
# set ylabel "{/Times-Italic N_2 (s>2L^2)}" font "Times-Roman,15"
# set xrange [3:20]
# set pointsize 0.6
# set key bottom

# plot "../data/basic/cmp_N2_r3.txt" u ($1):2:3 with errorbars  pt 6 lc rgb "red"  t 'N_{2}{/Times-Italic , d}=7',\
# 0.72*log(x)-0.33

# set output

# reset  #==============================#


# set output "../FIG/basic_N1_N2_".sprintf("%d",d)."D.pdf"

# set logscale x
# set xlabel "{/Times-Italic L}" font "Times-Roman,15"
# set ylabel "{/Times-Italic N_1, N_2}" font "Times-Roman,15"
# set xrange [3:13]
# set pointsize 0.6
# set key bottom

# plot "../data/basic/cmp_N2_r3.txt" u ($1):2:3 with errorbars  pt 4 lc rgb "red"  t 'N_{2}{/Times-Italic , d}=7',\
# "../data/basic/cmp_N1_r3.txt" u ($1):2:3 with errorbars  pt 6 lc rgb "red"  t 'N_{1}{/Times-Italic , d}=7',\
# 0.72*log(x)+0.07,\
# 0.72*log(x)-0.33

# set output

# reset  #==============================#

# ##########################################################
# ##############==============Ns=============###############
# ##########################################################

# set output "../FIG/basic_Ns1_".sprintf("%d",d)."D.pdf"

# set logscale xy
# set xlabel "{/Times-Italic L}" font "Times-Roman,15"
# set ylabel "{/Times-Italic N_s_1}" font "Times-Roman,15"
# set format x "10^{%L}"
# set format y "10^{%L}"
# set xrange [3:20]
# set pointsize 0.6
# set key bottom

# plot "../data/basic/cmp_N_s_1.txt" u ($1):2:3 with errorbars  pt 6 lc rgb "red"  t 'N_s_{1}{/Times-Italic , d}=7',\
# x**(6.0)

# set output

# reset  #==============================#

# set output "../FIG/basic_Ns2_".sprintf("%d",d)."D.pdf"

# set logscale xy
# set xlabel "{/Times-Italic L}" font "Times-Roman,15"
# set ylabel "{/Times-Italic N_s_2}" font "Times-Roman,15"
# set format x "10^{%L}"
# set format y "10^{%L}"
# set xrange [3:20]
# set pointsize 0.6
# set key bottom

# plot "../data/basic/cmp_N_s_2.txt" u ($1):2:3 with errorbars  pt 6 lc rgb "red"  t 'N_s_{2}{/Times-Italic , d}=7'

# set output

# reset  #==============================#

# set output "../FIG/basic_Ns3_".sprintf("%d",d)."D.pdf"

# set logscale xy
# set xlabel "{/Times-Italic L}" font "Times-Roman,15"
# set ylabel "{/Times-Italic N_s_3}" font "Times-Roman,15"
# set format x "10^{%L}"
# set format y "10^{%L}"
# set xrange [3:20]
# set pointsize 0.6
# set key bottom

# plot "../data/basic/cmp_N_s_3.txt" u ($1):2:3 with errorbars  pt 6 lc rgb "red"  t 'N_s_{3}{/Times-Italic , d}=7'

# set output

# reset  #==============================#