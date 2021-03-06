      SUBROUTINE DDASIN (X, XOUT, YOUT, YPOUT, NEQ, KOLD, PHI, PSI)
c Copyright (c) 2006, Math a la Carte, Inc.
c>> 2001-11-23 ddasin Krogh  Changed many names per library conventions.
c>> 2001-11-04 ddasin Krogh  Fixes for F77 and conversion to single
c>> 2001-11-01 ddasin Hanson Provide code to Math a la Carte.
c--D replaces "?": ?dasin, ?daslx, ?dastp
c      IMPLICIT NONE
C***BEGIN PROLOGUE  DDASIN
C***SUBSIDIARY
C***PURPOSE  Interpolation routine for DDASLX.
C***LIBRARY   SLATEC (DDASLX)
C***TYPE      DOUBLE PRECISION (SDASIN-S, DDASIN-D)
C***AUTHOR  Petzold, Linda R., (LLNL)
C***DESCRIPTION
c ----------------------------------------------------------------------
C     THE METHODS IN SUBROUTINE DDASTP USE POLYNOMIALS
C     TO APPROXIMATE THE SOLUTION. DDASIN APPROXIMATES THE
C     SOLUTION AND ITS DERIVATIVE AT TIME XOUT BY EVALUATING
C     ONE OF THESE POLYNOMIALS, AND ITS DERIVATIVE,THERE.
C     INFORMATION DEFINING THIS POLYNOMIAL IS PASSED FROM
C     DDASTP, SO DDASIN CANNOT BE USED ALONE.
C
C     THE PARAMETERS ARE:
C     X     THE CURRENT TIME IN THE INTEGRATION.
C     XOUT  THE TIME AT WHICH THE SOLUTION IS DESIRED
C     YOUT  THE INTERPOLATED APPROXIMATION TO Y AT XOUT
C           (THIS IS OUTPUT)
C     YPOUT THE INTERPOLATED APPROXIMATION TO YPRIME AT XOUT
C           (THIS IS OUTPUT)
C     NEQ   NUMBER OF EQUATIONS
C     KOLD  ORDER USED ON LAST SUCCESSFUL STEP
C     PHI   ARRAY OF SCALED DIVIDED DIFFERENCES OF Y
C     PSI   ARRAY OF PAST STEPSIZE HISTORY
c ----------------------------------------------------------------------
C***ROUTINES CALLED  (NONE)
C***REVISION HISTORY  (YYMMDD)
C   830315  DATE WRITTEN
C   901009  Finished conversion to SLATEC 4.0 format (F.N.Fritsch)
C   901019  Merged changes made by C. Ulrich with SLATEC 4.0 format.
C   901026  Added explicit declarations for all variables and minor
C           cosmetic changes to prologue.  (FNF)
C***END PROLOGUE  DDASIN
C
      INTEGER  NEQ, KOLD
      DOUBLE PRECISION  X, XOUT, YOUT(*), YPOUT(*), PHI(NEQ,*), PSI(*)
C
      INTEGER  I, J, KOLDP1
      DOUBLE PRECISION  C, D, GAMMA, TEMP1
C
C***FIRST EXECUTABLE STATEMENT  DDASIN
      KOLDP1=KOLD+1
      TEMP1=XOUT-X
      DO 10 I=1,NEQ
         YOUT(I)=PHI(I,1)
10       YPOUT(I)=0.0D0
      C=1.0D0
      D=0.0D0
      GAMMA=TEMP1/PSI(1)
      DO 30 J=2,KOLDP1
         D=D*GAMMA+C/PSI(J-1)
         C=C*GAMMA
         GAMMA=(TEMP1+PSI(J-1))/PSI(J)
         DO 20 I=1,NEQ
            YOUT(I)=YOUT(I)+C*PHI(I,J)
20          YPOUT(I)=YPOUT(I)+D*PHI(I,J)
30       CONTINUE
      RETURN
C
c -----END OF SUBROUTINE DDASIN------
      END
