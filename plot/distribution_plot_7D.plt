set terminal pdfcairo lw 1 font "Times_New_Roman,12"

d = 7  # dim
################################################################
# f_{C1}(s)
out_file_1 = "../FIG/f_C1_".sprintf("%d",d)."D".".pdf"

# f_{X1}(x) = L^{d/2}*f_{C1}(s) (x = s/L^{d/2}) ---> CG 
out_file_2 = "../FIG/f_X1_".sprintf("%d",d)."D".".pdf"

# f_{Y1}(y) = V^{\theta}*L^2*f_{C1}(s) (y = s/L^2) ---> GFP
out_file_3 = "../FIG/f_Y1_".sprintf("%d",d)."D".".pdf"

# f_{C2}(s)
out_file_4 = "../FIG/f_C2_".sprintf("%d",d)."D".".pdf"

# f_{X2}(x) = L^{d/2}*f_{C2}(s) (x = s/L^{d/2}) ---> CG 
out_file_5 = "../FIG/f_X2_".sprintf("%d",d)."D".".pdf"

# f_{Y2}(y) = V^{\theta}*L^2*f_{C2}(s) (y = s/L^2) ---> GFP
out_file_6 = "../FIG/f_Y2_".sprintf("%d",d)."D".".pdf"

# n(s) && s^{1+d/2}*n(s) (x = s/L^2) ---> GFP
out_file_7 = "../FIG/n_GFP_".sprintf("%d",d)."D".".pdf"

# n(s) && s^{3}*n(s) (x = s/L^{d/2}) ---> ??
out_file_8 = "../FIG/n__".sprintf("%d",d)."D".".pdf"

# n(s)Vs (x = s/L^{d/2}) ---> CG
out_file_9 = "../FIG/n_CG_".sprintf("%d",d)."D".".pdf"

# R(s) 
out_file_10 = "../FIG/R_s_".sprintf("%d",d)."D".".pdf"

# s(R) 
out_file_11 = "../FIG/s_R_".sprintf("%d",d)."D".".pdf"
################################################################
L_4 = 4; L_6 = 6; L_8_ = 8; L_10 = 10; L_12 = 12; L_14 = 14;
L_16 = 16; L_18 = 18; L_20 = 20; L_24 = 24; L_32 = 32;
L_48 = 48; L_64 = 64; L_96 = 96; L_128 = 128; 

V_4 = 4**d; V_6 = 6**d; V_8 = 8**d; V_10 = 10**d; V_12 = 12**d; V_14 = 14**d;
V_16 = 16**d; V_18 = 18**d; V_20 = 20**d; V_24 = 24**d; V_32 = 32**d;
V_48 = 48**d; V_64 = 64**d; V_96 = 96**d; V_128 = 128**d; 
################################################################################################################################
################################################################################################################################
################################################################################################################################
address = "../data/distribution/ns.C1_V_"

# set output out_file_1

# set pointsize 0.1
# set logscale xy
# unset tics
# set xtics (1e1,1e2,1e3,1e4,1e5)
# set ytics (1e-9,1e-8,1e-7,1e-6,1e-5,1e-4,1e-3,1e-2,1e-1)
# set xlabel "{/Times-Italic s}" font "Times-Roman,15"
# set ylabel "{/Times-Italic f_{C_1}(s)}" font "Times-Roman,15" offset -0.5
# set format x "10^{%L}"
# set format y "10^{%L}"
# set key

# plot address.sprintf("%d",V_4)  u 2:4  lc "orange" pt 11 title '4',\
# address.sprintf("%d",V_6)  u 2:4  lc rgb "green" pt 9 title '6',\
# address.sprintf("%d",V_8)  u 2:4  lc "blue" pt 7 title '8',\
# address.sprintf("%d",V_10)  u 2:4  lc "red" pt 5 title '10'


# set output

# reset  #==============================#

# set output out_file_2

# set multiplot

# set pointsize 0.1

# set xlabel "{/Times-Italic x}" font "Times-Roman,15"
# set ylabel "{/Times-Italic f_{X_1}(x)}" font "Times-Roman,15"
# set key at graph 0.2,0.92
# set key font "Times-Roman,12"

# set yrange [0:2.2]

# plot address.sprintf("%d",V_4)  u ($2/(V_4**(1.0/2.0))):($4*(V_4**(1.0/2.0)))  lc rgb "orange" pt 11 title '4',\
# address.sprintf("%d",V_6)  u ($2/(V_6**(1.0/2.0))):($4*(V_6**(1.0/2.0)))  lc rgb "green" pt 9 title '6',\
# address.sprintf("%d",V_8)  u ($2/(V_8**(1.0/2.0))):($4*(V_8**(1.0/2.0)))  lc rgb "blue" pt 7 title '8',\
# address.sprintf("%d",V_10)  u ($2/(V_10**(1.0/2.0))):($4*(V_10**(1.0/2.0)))  lc rgb "red" pt 5 title '10'

# reset

# set pointsize 0.1
# set logscale xy
# unset tics
# set xtics (1e-1,1e0)
# set ytics (1e-6,1e-5,1e-4,1e-3,1e-2,1e-1,1e0,1e1)
# set format x "10^{%L}"
# set format y "10^{%L}"
# set origin 0.3,0.25
# set size 0.65,0.65
# set xlabel ""
# set ylabel ""
# unset key

# plot address.sprintf("%d",V_4)  u ($2/(V_4**(1.0/2.0))):($4*(V_4**(1.0/2.0)))  lc rgb "orange" pt 11 title '4',\
# address.sprintf("%d",V_6)  u ($2/(V_6**(1.0/2.0))):($4*(V_6**(1.0/2.0)))  lc rgb "green" pt 9 title '6',\
# address.sprintf("%d",V_8)  u ($2/(V_8**(1.0/2.0))):($4*(V_8**(1.0/2.0)))  lc rgb "blue" pt 7 title '8',\
# address.sprintf("%d",V_10)  u ($2/(V_10**(1.0/2.0))):($4*(V_10**(1.0/2.0)))  lc rgb "red" pt 5 title '10'
# reset

# unset multiplot
# reset  #==============================#

set output out_file_3

set multiplot

set pointsize 0.1

set xlabel "{/Times-Italic y}" font "Times-Roman,15"
set ylabel "{/Times-Italic f_{Y_1}(y)V}^{1/12}" font "Times-Roman,15"
set key at graph 0.2,0.92
set key font "Times-Roman,12"

set yrange [0:2.2]

plot address.sprintf("%d",V_6)  u ($2/(6**(7.0/3.0))):((V_6**(1.0/12.0))*$4*(6**(7.0/3.0)))  lc rgb "green" pt 9 title '6',\
address.sprintf("%d",V_8)  u ($2/(8**(7.0/3.0))):((V_8**(1.0/12.0))*$4*(8**(7.0/3.0)))  lc rgb "blue" pt 7 title '8',\
address.sprintf("%d",V_10)  u ($2/(10**(7.0/3.0))):((V_10**(1.0/12.0))*$4*(10**(7.0/3.0)))  lc rgb "pink" pt 5 title '10',\
address.sprintf("%d",V_12)  u ($2/(12**(7.0/3.0))):((V_12**(1.0/12.0))*$4*(12**(7.0/3.0)))  lc rgb "red" pt 5 title '12',\
address.sprintf("%d",V_14)  u ($2/(14**(7.0/3.0))):((V_12**(1.0/12.0))*$4*(14**(7.0/3.0)))  lc rgb "orange" pt 5 title '14'
reset

set pointsize 0.1
set logscale xy
unset tics
set xtics (1e-1,1e0)
set ytics (1e-7,1e-6,1e-5,1e-4,1e-3,1e-2,1e-1,1e0,1e1)
set format x "10^{%L}"
set format y "10^{%L}"
set origin 0.3,0.25
set size 0.65,0.65
set xlabel ""
set ylabel ""
unset key
qq = 6.0
plot address.sprintf("%d",V_6)  u ($2/(6**(qq/3.0))):((V_6**(3.0/28.0))*$4*(6**(qq/3.0)))  lc rgb "green" pt 9 title '6',\
address.sprintf("%d",V_8)  u ($2/(8**(qq/3.0))):((V_8**(3.0/28.0))*$4*(8**(qq/3.0)))  lc rgb "blue" pt 7 title '8',\
address.sprintf("%d",V_10)  u ($2/(10**(qq/3.0))):((V_10**(3.0/28.0))*$4*(10**(qq/3.0)))  lc rgb "pink" pt 5 title '10',\
address.sprintf("%d",V_12)  u ($2/(12**(qq/3.0))):((V_12**(3.0/28.0))*$4*(12**(qq/3.0)))  lc rgb "red" pt 5 title '12',\
address.sprintf("%d",V_14)  u ($2/(14**(qq/3.0))):((V_14**(3.0/28.0))*$4*(14**(qq/3.0)))  lc rgb "orange" pt 5 title '14'
reset

unset multiplot
reset  #==============================#

# ################################################################################################################################
# ################################################################################################################################
# ################################################################################################################################
# address = "../data/distribution/ns.C2_V_"

# set output out_file_4

# set pointsize 0.1
# set logscale xy
# unset tics
# set xtics (1e1,1e2,1e3,1e4,1e5)
# set ytics (1e-9,1e-8,1e-7,1e-6,1e-5,1e-4,1e-3,1e-2,1e-1)
# set xlabel "{/Times-Italic s}" font "Times-Roman,15"
# set ylabel "{/Times-Italic f_{C_2}(s)}" font "Times-Roman,15" offset -0.5
# set format x "10^{%L}"
# set format y "10^{%L}"
# set key

# plot address.sprintf("%d",V_4)  u 2:4  lc "orange" pt 11 title '4',\
# address.sprintf("%d",V_6)  u 2:4  lc rgb "green" pt 9 title '6',\
# address.sprintf("%d",V_8)  u 2:4  lc "blue" pt 7 title '8',\
# address.sprintf("%d",V_10)  u 2:4  lc "red" pt 5 title '10'
# set output

# reset  #==============================#

# set output out_file_5

# set multiplot

# set pointsize 0.1

# set xlabel "{/Times-Italic x}" font "Times-Roman,15"
# set ylabel "{/Times-Italic f_{X_2}(x)}" font "Times-Roman,15"
# set key at graph 0.2,0.92
# set key font "Times-Roman,12"

# set yrange [0:6.3]

# plot address.sprintf("%d",V_4)  u ($2/(V_4**(1.0/2.0))):($4*(V_4**(1.0/2.0)))  lc rgb "orange" pt 11 title '4',\
# address.sprintf("%d",V_6)  u ($2/(V_6**(1.0/2.0))):($4*(V_6**(1.0/2.0)))  lc rgb "green" pt 9 title '6',\
# address.sprintf("%d",V_8)  u ($2/(V_8**(1.0/2.0))):($4*(V_8**(1.0/2.0)))  lc rgb "blue" pt 7 title '8',\
# address.sprintf("%d",V_10)  u ($2/(V_10**(1.0/2.0))):($4*(V_10**(1.0/2.0)))  lc rgb "red" pt 5 title '10'
# reset

# set pointsize 0.1
# set logscale xy
# unset tics
# set xtics (1e-1,1e0)
# set ytics (1e-7,1e-6,1e-5,1e-4,1e-3,1e-2,1e-1,1e0,1e1)
# set format x "10^{%L}"
# set format y "10^{%L}"
# set origin 0.3,0.25
# set size 0.65,0.65
# set xlabel ""
# set ylabel ""
# unset key

# plot address.sprintf("%d",V_4)  u ($2/(V_4**(1.0/2.0))):($4*(V_4**(1.0/2.0)))  lc rgb "orange" pt 11 title '4',\
# address.sprintf("%d",V_6)  u ($2/(V_6**(1.0/2.0))):($4*(V_6**(1.0/2.0)))  lc rgb "green" pt 9 title '6',\
# address.sprintf("%d",V_8)  u ($2/(V_8**(1.0/2.0))):($4*(V_8**(1.0/2.0)))  lc rgb "blue" pt 7 title '8',\
# address.sprintf("%d",V_10)  u ($2/(V_10**(1.0/2.0))):($4*(V_10**(1.0/2.0)))  lc rgb "red" pt 5 title '10'
# reset

# unset multiplot
# reset  #==============================#

# set output out_file_6

# set multiplot

# set pointsize 0.1

# set xlabel "{/Times-Italic y}" font "Times-Roman,15"
# set ylabel "{/Times-Italic f_{Y_2}(y)V}^{1/12}" font "Times-Roman,15"
# set key at graph 0.2,0.92
# set key font "Times-Roman,12"

# set yrange [0:6.3]

# plot address.sprintf("%d",V_4)  u ($2/(4**(2.0))):((V_4**(1.0/12.0))*$4*(4**(2.0)))  lc rgb "orange" pt 11 title '4',\
# address.sprintf("%d",V_6)  u ($2/(6**(2.0))):((V_6**(1.0/12.0))*$4*(6**(2.0)))  lc rgb "green" pt 9 title '6',\
# address.sprintf("%d",V_8)  u ($2/(8**(2.0))):((V_8**(1.0/12.0))*$4*(8**(2.0)))  lc rgb "blue" pt 7 title '8',\
# address.sprintf("%d",V_10)  u ($2/(10**(2.0))):((V_10**(1.0/12.0))*$4*(10**(2.0)))  lc rgb "red" pt 5 title '10'
# reset

# set pointsize 0.1
# set logscale xy
# unset tics
# set xtics (1e-1,1e0)
# set ytics (1e-7,1e-6,1e-5,1e-4,1e-3,1e-2,1e-1,1e0,1e1)
# set format x "10^{%L}"
# set format y "10^{%L}"
# set origin 0.3,0.25
# set size 0.65,0.65
# set xlabel ""
# set ylabel ""
# unset key

# plot address.sprintf("%d",V_4)  u ($2/(4**(2.0))):((V_4**(1.0/12.0))*$4*(4**(2.0)))  lc rgb "orange" pt 11 title '4',\
# address.sprintf("%d",V_6)  u ($2/(6**(2.0))):((V_6**(1.0/12.0))*$4*(6**(2.0)))  lc rgb "green" pt 9 title '6',\
# address.sprintf("%d",V_8)  u ($2/(8**(2.0))):((V_8**(1.0/12.0))*$4*(8**(2.0)))  lc rgb "blue" pt 7 title '8',\
# address.sprintf("%d",V_10)  u ($2/(10**(2.0))):((V_10**(1.0/12.0))*$4*(10**(2.0)))  lc rgb "red" pt 5 title '10'
# reset

# unset multiplot
# reset  #==============================#

# ################################################################################################################################
# ################################################################################################################################
# ################################################################################################################################
# address = "../data/distribution/ns_V_"

# set output out_file_7

# set multiplot

# set pointsize 0.1
# unset tics
# set xtics (1e1,1e2,1e3,1e4,1e5)
# set ytics (1e-14,1e-12,1e-10,1e-8,1e-6,1e-4,1e-2,1e0)
# set logscale xy
# set xlabel "{/Times-Italic s}"  font "Times-Roman,20"
# set ylabel "{/Times-Italic n(s,L)}"  font "Times-Roman,20"
# set format x "10^{%L}"
# set format y "10^{%L}"
# set key left bottom
# set key font "Times-Roman,12"
# set xtics nomirror
# set ytics nomirror
# set label 1 "slope -4.5" at graph 0.15,0.43 font "Times-Roman,12"
# set label 2 "slope -1" at graph 0.80,0.35 font "Times-Roman,12"

# slf(x) = x>101.249? 0.0000000383*x**(-1.0) : 0.4*x**(-4.5)

# plot address.sprintf("%d",V_4)  u 2:4  lc "orange" pt 11 title '4',\
# address.sprintf("%d",V_6)  u 2:4  lc "green" pt 9 title '6',\
# address.sprintf("%d",V_8)  u 2:4  lc "blue" pt 7 title '8',\
# address.sprintf("%d",V_10)  u 2:4  lc "red" pt 5 title '10',\
# slf(x) lw 0.6 lc -1 notitle


# reset  #==============================#


# set pointsize 0.1
# unset tics
# set logscale xy
# set xlabel "{/Times-Italic s/L^{2}}" font "Times-Roman,11"
# set ylabel "{/Times-Italic s^{4.5}n}" font "Times-Roman,11"
# set format x "10^{%L}"
# set format y "10^{%L}"
# set origin 0.57,0.57
# set size 0.4,0.4


# plot address.sprintf("%d",V_4)  u ($2/(4**(2.0))):($4*($2)**(1.0+d/2.0))  lc "orange" pt 11 notitle,\
# address.sprintf("%d",V_6)  u ($2/(6**(2.0))):($4*($2)**(1.0+d/2.0))  lc "green" pt 9 notitle,\
# address.sprintf("%d",V_8)  u ($2/(8**(2.0))):($4*($2)**(1.0+d/2.0))  lc "blue" pt 7 notitle,\
# address.sprintf("%d",V_10)  u ($2/(10**(2.0))):($4*($2)**(1.0+d/2.0))  lc "red" pt 5 notitle
# unset multiplot

# set output

# reset  #==============================#


# set output out_file_8

# set pointsize 0.1
# unset tics
# set xtics (1e-3,1e-2,1e-1,1e0)
# set ytics (1e-4,1e-3,1e-2,1e-1,1e-0,1e1,1e2)
# set logscale xy
# set xlabel "{/Times-Italic s/V^{1/2}}" font "Times-Roman,11"
# set ylabel "{/Times-Italic s^3n}" font "Times-Roman,11"
# set format x "10^{%L}"
# set format y "10^{%L}"


# plot address.sprintf("%d",V_4)  u ($2/(V_4**(1.0/2.0))):($4*($2)**(3.0))  lc 18 pt 14 notitle ,\
# address.sprintf("%d",V_6)  u ($2/(V_6**(1.0/2.0))):($4*($2)**(3.0))  lc 19 pt 14 notitle ,\
# address.sprintf("%d",V_8)  u ($2/(V_8**(1.0/2.0))):($4*($2)**(3.0))  lc 14 pt 13 notitle,\
# address.sprintf("%d",V_10)  u ($2/(V_10**(1.0/2.0))):($4*($2)**(3.0))  lc 15 pt 15 notitle

# set output

# reset  #==============================#

# set output out_file_9

# set pointsize 0.1
# unset tics
# set xtics (1e-2,1e-1,1e0)
# set ytics (1e-4,1e-2,1e-0,1e2,1e4,1e6)
# set logscale xy
# set xlabel "{/Times-Italic s/V^{1/2}}" font "Times-Roman,15"
# set ylabel "{/Times-Italic nsV}" font "Times-Roman,15"
# set format x "10^{%L}"
# set format y "10^{%L}"


# plot address.sprintf("%d",V_4)  u ($2/(V_4**(1.0/2.0))):($4*($2)*V_4)  lc "orange" pt 11 t '4' ,\
# address.sprintf("%d",V_6)  u ($2/(V_6**(1.0/2.0))):($4*($2)*V_6)  lc "green" pt 9 t '6' ,\
# address.sprintf("%d",V_8)  u ($2/(V_8**(1.0/2.0))):($4*($2)*V_8)  lc "blue" pt 7 t '8',\
# address.sprintf("%d",V_10)  u ($2/(V_10**(1.0/2.0))):($4*($2)*V_10)  lc "red" pt 5 t '10',\
# 0.5*x**(0) dt 2 lc -1 lw 0.2 notitle

# set output

# reset  #==============================#

# ################################################################################################################################
# ################################################################################################################################
# ################################################################################################################################
# address = "../data/distribution/R_s_V_"

# set output out_file_10

# set logscale xy
# set xlabel "{/Times-Italic s}"  font "Times-Roman,15"
# set ylabel "{/Times-Italic R}({/Times-Italic s})"  font "Times-Roman,15"
# set format x "10^{%L}"
# set format y "10^{%L}"
# set xrange [3:10880]
# set xtics (1e2,1e3,1e4)
# set ytics (1e0,1e1,1e2)
# set key bottom
# set pointsize 0.1


# plot address.sprintf("%d",V_4) u 2:3  pt 7 lc rgb 'pink'  t '4',\
# address.sprintf("%d",V_6) u 2:3  pt 7 lc rgb 'red'  t '6',\
# address.sprintf("%d",V_8) u 2:3  pt 7 lc 11  t '8',\
# address.sprintf("%d",V_10) u 2:3  pt 7 lc 13  t '10',\
# 0.53*x**(0.5) dt 1 lw 0.4 lc -1 t 'slope 1/2',\
# 0.36*x**(0.5) dt 1 lw 0.4 lc -1 notitle


# set output

# reset  #==============================#

# set output out_file_11

# set logscale xy
# unset tics
# set xtics (1e0,1e1,1e2)
# set ytics (1e0,1e1,1e2,1e3,1e4,1e5,1e6)
# set xlabel "{/Times-Italic R}"  font "Times-Roman,15"
# set ylabel "{/Times-Italic s}({/Times-Italic R})"  font "Times-Roman,15"
# set format x "10^{%L}"
# set format y "10^{%L}"
# set xrange [0.9:50]
# # set xtics (1e2,1e3,1e4)
# # set ytics (1e0,1e1,1e2)
# set key bottom
# set pointsize 0.35


# plot address.sprintf("%d",V_4) u 3:2  pt 7 lc 'orange'  t '4',\
# address.sprintf("%d",V_6) u 3:2  pt 7 lc 'green'  t '6',\
# address.sprintf("%d",V_8) u 3:2  pt 7 lc rgb 'blue'  t '8',\
# address.sprintf("%d",V_10) u 3:2  pt 7 lc 'red'  t '10',\
# 5.25*x**(2) dt 1 lw 0.4 lc -1 t 'slope 2',\
# 10.2*x**(2) dt 1 lw 0.4 lc -1 notitle


# set output

# reset  #==============================#