#set terminal wxt enhanced
set terminal epslatex lw 2 standalone header "\\usepackage{graphicx}"  size 5in, 5*0.7 in
set output "pL_cor.tex"

set multiplot
set key left bottom

set pointsize 1.5

#set xlabel "L"
#set ylabel "g(L)"

set xlabel "$L$"
set ylabel "$\\sigma_{\\mathcal{T}}$" # offset 1,0
set key  at graph 0.08,0.1

set logscale xy

set xtics ("4" 4, "8" 8,"16" 16, "32" 32, "64" 64, "128" 128, "256" 256)
#set ytics ("1" 1, "3" 3, "5" 5, "7" 7, "9" 9)
set ytics ("$10^{0}$" 1, "$10^{-1}$" 1e-1, "$10^{-2}$" 1e-2, "$10^{-3}$" 1e-3, "$10^{-4}$" 1e-4, "$10^{-11}$" 1e-11,)

set xtics nomirror
set ytics nomirror

set xrange [7.9:264]
#set yrange [0.01:1.1]

set samples 500

#set label 1 "(2D, 0D, $g(L)$)" at graph 0.35,0.95

file1 = 'Obs_20'
file2 = 'Obs_2_20'
file3 = 'Obs_21'
file4 = 'L_14.dat'
file5 = 'L_16.dat'
file6 = 'expo2_128.dat'
file7 = 'expo2_256.dat'
file8 = 'expo2_512.dat'
#file9 = 'expo2_1024.dat'
#file10 = 'expo2_2048.dat'

f1(x) = x**(D1)*(a1+b11*x**(y1))+C0#+b12/x/x)
f2(x) = x**(-D2)*(a2+b21/x+b22/x/x)
f3(x) = x**(-D3)*(a3+b31/x+b32/x/x)
f4(x) = x**(-D4)*(a4+b41/x+b42/x/x)
D1 = -1
y1 = -3.0/3
C0 = 0.0
pc = 0.6602
#a1 = 2.6
#b11 = 0
#b12 = 1.3
rmin = 4
rmax = 1000
#fit [rmin:rmax] f1(x) file1 using 1:2:3 yerror via D1,a1,b11#,pc#,y1#,b12
# rmin = 10
# fit [rmin:rmax] f1(x) file1 using 1:2:3 yerror via D1,a1,b11,y1#,b12
# rmin = 12
# fit [rmin:rmax] f1(x) file1 using 1:2:3 yerror via D1,a1,b11,y1#,b12
# rmin = 14
# fit [rmin:rmax] f1(x) file1 using 1:2:3 yerror via D1,a1,b11,y1#,b12
# rmin = 16
# fit [rmin:rmax] f1(x) file1 using 1:2:3 yerror via D1,a1,b11,y1#,b12
#fit [rmin:16 ] f2(x) file2 using 1:2:3 via D2,a2,b21,b22
#fit [rmin:rmax] f3(x) file3 using 1:2:3 via D3,a3,b31,b32
#fit [rmin:rmax] f4(x) file4 using 1:2:3 via D4,a4,b41,b42
yh1 = -2.0
y1 = -0.5
plot file1 u 1:2:3 with err lc "red" pt 7  title "$\\sigma_{\\mathcal{T}}$"  ,\
     0.17*x**(-0.82) lw 2 lc "red" dt 42 title "$-0.82$" ,\
	 0.043*x**(-0.5) lw 2 lc "blue" dt 42 title "$-0.5$" 
	 #file2 u 1:2:3 with err lc "blue" pt 7  title "$\\Delta p$"  ,\
     #6.8*x**(-2.0) lw 2 lc "red" dt 42 title "$-2$"
	 #f1(x) lw 2 lc 9 dt 42 notit
	 #1.65*x**(1.27) lw 2 lc 8 dt 42 title "$-6/5$"
	 #2*x**(1.2) lw 2 lc 8 dt 42 title "$-6/5$"
	 #file1 u 1:2:3 with err lc "red" pt 7  title "$\\Delta p$"
#file1 u ($1**y1):($2/$1**yh1):($3/$1**yh1) with err lc 3 pt 3 notit

set xlabel " "
set ylabel "$L \\sigma_{\\mathcal{T}}^2$"

set pointsize 0.8
set key font ",10"
set key at graph 0.2,0.13

set origin 0.5, 0.5
set size 0.45, 0.45
plot file1 u 1:($1*$2**2) lc "red" pt 7 notit ,\
     0.0018 lw 2 lc "black" dt 42 title "$cons$"

#pause -1
