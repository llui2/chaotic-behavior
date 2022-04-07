set term gif size 1024,1024 animate  delay 2
set output "dpendulum.gif"
datafile ="datos.dat"

set encoding utf8

set tmargin at screen 0.99
set bmargin at screen 0.01
set rmargin at screen 0.99
set lmargin at screen 0.01

set key  top right font ",15"
set key spacing 1.5

set title "" font "Helvetica Bold,15"

set xtics font ", 15"
set ytics font ", 15"

set xrange [-2.1:2.1]
set yrange [-2.2:2.2]


set style line 1 lc rgb 'green' pt 7 ps 3 lt 1 lw 2
set style line 2 lc rgb 'blue' pt 7 ps 3 lt 1 lw 2
set style line 3 lc rgb 'red' pt 7 ps 3 lt 1 lw 2
set style line 4 lc rgb 'orange' pt 7 ps 3 lt 1 lw 2
set style line 5 lc rgb 'purple' pt 7 ps 3 lt 1 lw 2

set style line 20 lt 1 lw 1 lc rgb 'green'
set style line 21 lt 1 lw 1 lc rgb 'blue'
set style line 22 lt 1 lw 1 lc rgb 'red'
set style line 23 lt 1 lw 1 lc rgb 'orange'
set style line 24 lt 1 lw 1 lc rgb 'purple'


set style line 10 lw 2 lc rgb 'green'
set style line 11 lw 2 lc rgb 'blue'
set style line 12 lw 2 lc rgb 'red'
set style line 13 lw 2 lc rgb 'orange'
set style line 14 lw 2 lc rgb 'purple'







set format x ""
set format y ""

set xlabel "" font ",15" offset 0
set ylabel "" font ",15" offset 0

R = 4


do for [i=1:750] {  
     
       plot   for[k=0:R] "dades.dat" every::i-800::i  index k u 4:5 t '' with line ls 20+k ,\
              for[k=0:R] "dades.dat" every::i::i     index k u 2:3 t '' with points ls 1+k,\
              for[k=0:R] "dades.dat" every::i::i     index k u 4:5 t '' with points ls 1+k,\
              for[k=0:R] "dades.dat" every::i::i     index k u 2:3:(0-$2):(0-$3) t '' with vectors nohead ls 10+k,\
              for[k=0:R] "dades.dat" every::i::i index k u 2:3:($4-$2):($5-$3) t '' with vectors nohead ls 10+k}
