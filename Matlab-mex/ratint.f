#include "fintrf.h"
      SUBROUTINE mexFunction(nlhs,plhs,nrhs,prhs)
      implicit none
      mwPointer plhs(*), prhs(*)
      INTEGER nlhs, nrhs
      mwPointer mxCreateDoubleMatrix
      mwPointer mxGetPr
      mwPointer mxGetN
      
      mwPointer xa_pr, ya_pr, x_pr, y_pr, dy_pr
      mwSize n

      integer*4 numel
      parameter(numel = 1000)
      real*8  xa(numel), ya(numel)
      real*8 x, y, dy
      
      plhs(1) = mxCreateDoubleMatrix(1,1,0)
      plhs(2) = mxCreateDoubleMatrix(1,1,0)
      
      xa_pr = mxGetPr(prhs(1))
      ya_pr = mxGetPr(prhs(2))
      n = mxGetN(prhs(1))
      x_pr = mxGetPr(prhs(3))
      y_pr = mxGetPr(plhs(1))
      dy_pr = mxGetPr(plhs(2))
      
      call mxCopyPtrToReal8(xa_pr,xa,n)
      call mxCopyPtrToReal8(ya_pr,ya,n)
      call mxCopyPtrToReal8(x_pr,x,1)

      call ratint(xa,ya,n,x,y,dy)

      call mxCopyReal8ToPtr(y,y_pr,1)
      call mxCopyReal8ToPtr(dy,dy_pr,1)

      return
      end

      SUBROUTINE ratint(xa,ya,n,x,y,dy)
!  this program is working for the rational function interpolation,
!  which algorithm is based on the recursive relationship that I presented on class.
!  input n pairs of (xa,ya) and x at which you want to know y. After calling ratint,
!  return a value of y and an error estimate as the output.
!  The value returned is that of the diagonal rational
!  function, evaluated at x, which passes through the n points (xa,ya).
      INTEGER n,NMAX
      REAL*8 dy,x,y,xa(n),ya(n),TINY
      PARAMETER (NMAX=10,TINY=1.e-25)
      INTEGER i,m,ns
      REAL*8 dd,h,hh,t,w,c(NMAX),d(NMAX)
      ns=1
      hh=abs(x-xa(1))
      do 11 i=1,n
        h=abs(x-xa(i))
        if (h.eq.0.)then
          y=ya(i)
          dy=0.0
          return
        else if (h.lt.hh) then
          ns=i
          hh=h
        endif
        c(i)=ya(i)
        d(i)=ya(i)+TINY
11    continue
      y=ya(ns)
      ns=ns-1
      do 13 m=1,n-1
        do 12 i=1,n-m
          w=c(i+1)-d(i)
          h=xa(i+m)-x
          t=(xa(i)-x)*d(i)/h
          dd=t-c(i+1)
          if(dd.eq.0.)stop 'failure in ratint'
          dd=w/dd
          d(i)=c(i+1)*dd
          c(i)=t*dd
12      continue
        if (2*ns.lt.n-m)then
          dy=c(ns+1)
        else
          dy=d(ns)
          ns=ns-1
        endif
        y=y+dy
13    continue
      return
      END