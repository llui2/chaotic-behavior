       program double_pendulum_chaos

       implicit none
       integer i,j, npassos, npendols
       double precision xlongi1, xmass1, xlongi2, xmass2
       double precision xg, tmax, temps, dt, pi
       double precision theta0(4), theta1(4)
       double precision xx1, xx2, yy1, yy2

       common /variables/ xlongi1, xmass1, xlongi2, xmass2, xg

       pi = acos(-1.d0)
c      mass 1 [kg]       
       xmass1         = 1.d0
c      mass 2 [kg]       
       xmass2         = 1.d0
c      length 1 [m]
       xlongi1        = 1.d0
c      length 2 [m]
       xlongi2        = 1.d0
c      gravity [m/sˆ2]
       xg            = 9.8d0
c      max time evolution [s]
       tmax          = 15.d0

       open(1,file='dades.dat')

       npendols = 5
       npassos = 750
       dt = tmax/npassos

       do j=1,npendols
       theta0 =   (/ 3.d0*pi/4 ,0.d0 , 
     .               2.d0*pi/3 - j*0.001d0 ,0.d0/)
       do i=1,npassos
              temps = dt*i
              call miRungeKutta4(temps,dt,theta0,4,theta1)
              theta0 = theta1
              xx1 = xlongi1*sin(theta0(1))
              yy1 = -xlongi1*cos(theta0(1))
              xx2 = xlongi1*sin(theta0(1))+xlongi2*sin(theta0(3))
              yy2 = -xlongi1*cos(theta0(1))-xlongi2*cos(theta0(3))
              write(1,*) temps, xx1, yy1, xx2, yy2
       enddo
       write(1,*)
       write(1,*)
       enddo

       close(1)

       call system ("gnuplot animation.gnu")

       end

c----------------------------------------------------------------------
c      ONE STEP RUNGE-KUTTA ORDER 4 SUBROUTINE
c----------------------------------------------------------------------
       subroutine miRungeKutta4(t,dt,yyin,nequs,yyout)
       implicit none
       integer nequs
       double precision yyin(nequs), yyout(nequs)
       double precision t, dt
c      INPUT;
c             nequs         ->     number of equations in the problem
c             yyin          ->     initial values
c             t, dt         ->     current step time, step time
c      OUTPUT;
c             yyout         ->     final values
       integer i
       double precision k1(nequs), k2(nequs), k3(nequs), k4(nequs)
       double precision yytemp(nequs)
       external derivad
c      K1
       call derivad(t,yyin,k1,nequs)
       do i=1,nequs
              yytemp(i) = yyin(i)+dt*k1(i)/2
       enddo
c      K2
       call derivad(t+dt/2,yytemp,k2,nequs)
       do i=1,nequs
              yytemp(i) = yyin(i)+dt*k2(i)/2
       enddo
c      K3
       call derivad(t+dt/2,yytemp,k3,nequs)
       do i=1,nequs
              yytemp(i) = yyin(i)+dt*k3(i)
       enddo
c      K4
       call derivad(t+dt,yytemp,k4,nequs)
       do i=1,nequs
              yyout(i) = yyin(i)+(dt/6)*(k1(i)+2*k2(i)+2*k3(i)+k4(i))
       enddo
       end

c----------------------------------------------------------------------
c      DERIVATIVE OF THE DIFERENTIAL EQUATIONS OF THE PROBLEM
c----------------------------------------------------------------------
       subroutine derivad(t,yin,dyout,nequ)
       implicit none
       integer nequ
       double precision t, yin(nequ), dyout(nequ)
c      INPUT;
c             nequ          ->     number of equations to solve
c             t             ->     numeric value of the independent variable
c             yin           ->     numeric value of the dependent variable
c      OUTPUT;
c             dyout         ->     numeric values of the derivative of the dependent variable
       double precision L1, M1, L2, M2, G, delta, den1, den2
       common /variables/ L1, M1, L2, M2, G

       if (nequ.gt.4) then 
              print*, 'error derivades' 
       endif
c      movement equations
c      theta1
       dyout(1) = yin(2)
c      omega1
       delta = yin(3) - yin(1)
       den1 = (M1+M2)*L1 - M2*L1*cos(delta)*cos(delta)
       dyout(2)=     (M2*L1*yin(2)*yin(2)*sin(delta)*cos(delta)
     .               + M2*G*sin(yin(3))*cos(delta)  
     .               + M2*L2*yin(4)*yin(4)*sin(delta)
     .               - (M1+M2)*G*sin(yin(1)))/den1
c      theta2
       dyout(3) = yin(4)
c      omega2
       den2 = (L2/L1)*den1
       dyout(4) =   (-M2*L2*yin(4)*yin(4)*sin(delta)*cos(delta)
     .               + (M1+M2)*G*sin(yin(1))*cos(delta)
     .               - (M1+M2)*L1*yin(2)*yin(2)*sin(delta)
     .               - (M1+M2)*G*sin(yin(3)))/den2

       end
