      SUBROUTINE    SNLAGU(N, P, X, SCALCR, SCALCJ, IV, LIV, LV, V)
c Copyright (c) 1996 California Institute of Technology, Pasadena, CA.
c ALL RIGHTS RESERVED.
c Based on Government Sponsored Research NAS7-03001.
c>> 1996-04-27 SNLAGU Krogh  Changes to get desired C prototypes.
c>> 1994-10-20 SNLAGU Krogh  Changes to use M77CON
c>> 1990-07-02 SNLAGU C. L. Lawson, JPL
c>> 1990-01-31 C. L. Lawson, JPL
C
C  ***  VERSION OF NL2SOL THAT CALLS   SRN2G  ***
C
C  ***  PARAMETERS  ***
C
      INTEGER N, P, LIV, LV
      INTEGER IV(LIV)
      REAL             X(P), V(LV)
C/
      EXTERNAL SCALCR, SCALCJ
C
C  ***  PARAMETER USAGE  ***
C
C N....... TOTAL NUMBER OF RESIDUALS.
C P....... NUMBER OF PARAMETERS (COMPONENTS OF X) BEING ESTIMATED.
C X....... PARAMETER VECTOR BEING ESTIMATED (INPUT = INITIAL GUESS,
C             OUTPUT = BEST VALUE FOUND).
C SCALCR... SUBROUTINE FOR COMPUTING RESIDUAL VECTOR.
C SCALCJ... SUBROUTINE FOR COMPUTING JACOBIAN MATRIX = MATRIX OF FIRST
C             PARTIALS OF THE RESIDUAL VECTOR.
C IV...... INTEGER VALUES ARRAY.
C LIV..... LENGTH OF IV (SEE DISCUSSION BELOW).
C LV...... LENGTH OF V (SEE DISCUSSION BELOW).
C V....... FLOATING-POINT VALUES ARRAY.
C
C
C  ***  DISCUSSION  ***
C
C        NOTE... NL2SOL (MENTIONED BELOW) IS A CODE FOR SOLVING
C     NONLINEAR LEAST-SQUARES PROBLEMS.  IT IS DESCRIBED IN
C     ACM TRANS. MATH. SOFTWARE, VOL. 9, PP. 369-383 (AN ADAPTIVE
C     NONLINEAR LEAST-SQUARES ALGORITHM, BY J.E. DENNIS, D.M. GAY,
C     AND R.E. WELSCH).
C
C        LIV GIVES THE LENGTH OF IV.  IT MUST BE AT LEAST 82+P.  IF NOT,
C     THEN SNLAGU RETURNS WITH IV(1) = 15.  WHEN SNLAGU RETURNS, THE
C     MINIMUM ACCEPTABLE VALUE OF LIV IS STORED IN IV(LASTIV) = IV(44),
C     (PROVIDED THAT LIV .GE. 44).
C
C        LV GIVES THE LENGTH OF V.  THE MINIMUM VALUE FOR LV IS
C     LV0 = 105 + P*(N + 2*P + 17) + 2*N.  IF LV IS SMALLER THAN THIS,
C     THEN SNLAGU RETURNS WITH IV(1) = 16.  WHEN SNLAGU RETURNS, THE
C     MINIMUM ACCEPTABLE VALUE OF LV IS STORED IN IV(LASTV) = IV(45)
C     (PROVIDED LIV .GE. 45).
C
C        RETURN CODES AND CONVERGENCE TOLERANCES ARE THE SAME AS FOR
C     NL2SOL, WITH SOME SMALL EXTENSIONS... IV(1) = 15 MEANS LIV WAS
C     TOO SMALL.   IV(1) = 16 MEANS LV WAS TOO SMALL.
C
C        THERE ARE TWO NEW V INPUT COMPONENTS...  V(LMAXS) = V(36) AND
C     V(SCTOL) = V(37) SERVE WHERE V(LMAX0) AND V(RFCTOL) FORMERLY DID
C     IN THE SINGULAR CONVERGENCE TEST -- SEE THE NL2SOL DOCUMENTATION.
C
C  ***  DEFAULT VALUES  ***
C
C        DEFAULT VALUES ARE PROVIDED BY SUBROUTINE SIVSET, RATHER THAN
C     DFAULT.  THE CALLING SEQUENCE IS...
C             CALL SIVSET(1, IV, LIV, LV, V)
C     THE FIRST PARAMETER IS AN INTEGER 1.  IF LIV AND LV ARE LARGE
C     ENOUGH FOR SIVSET, THEN SIVSET SETS IV(1) TO 12.  OTHERWISE IT
C     SETS IV(1) TO 15 OR 16.  CALLING SNLAGU WITH IV(1) = 0 CAUSES ALL
C     DEFAULT VALUES TO BE USED FOR THE INPUT COMPONENTS OF IV AND V.
C        IF YOU FIRST CALL SIVSET, THEN SET IV(1) TO 13 AND CALL SNLAGU,
C     THEN STORAGE ALLOCATION ONLY WILL BE PERFORMED.  IN PARTICULAR,
C     IV(D) = IV(27), IV(J) = IV(70), AND IV(R) = IV(61) WILL BE SET
C     TO THE FIRST SUBSCRIPT IN V OF THE SCALE VECTOR, THE JACOBIAN
C     MATRIX, AND THE RESIDUAL VECTOR RESPECTIVELY, PROVIDED LIV AND LV
C     ARE LARGE ENOUGH.  IF SO, THEN  SNLAGU RETURNS WITH IV(1) = 14.
C     WHEN CALLED WITH IV(1) = 14,  SNLAGU ASSUMES THAT STORAGE HAS
C     BEEN ALLOCATED, AND IT BEGINS THE MINIMIZATION ALGORITHM.
C
C  ***  SCALE VECTOR  ***
C
C        ONE DIFFERENCE WITH NL2SOL IS THAT THE SCALE VECTOR D IS
C     STORED IN V, STARTING AT A DIFFERENT SUBSCRIPT.  THE STARTING
C     SUBSCRIPT VALUE IS STILL STORED IN IV(D) = IV(27).  THE
C     DISCUSSION OF DEFAULT VALUES ABOVE TELLS HOW TO HAVE IV(D) SET
C     BEFORE THE ALGORITHM IS STARTED.
C
C  ***  REGRESSION DIAGNOSTICS  ***
C
C        IF IV(RDREQ) SO DICTATES, THEN ESTIMATES ARE COMPUTED OF THE
C     INFLUENCE EACH RESIDUAL COMPONENT HAS ON THE FINAL PARAMETER
C     ESTIMATE X.  THE GENERAL IDEA IS THAT ONE MAY WISH TO EXAMINE
C     RESIDUAL COMPONENTS (AND THE DATA BEHIND THEM) FOR WHICH THE
C     INFLUENCE ESTIMATE IS SIGNIFICANTLY LARGER THAN MOST OF THE OTHER
C     INFLUENCE ESTIMATES.  THESE ESTIMATES, HEREAFTER CALLED
C     REGRESSION DIAGNOSTICS, ARE ONLY COMPUTED IF IV(RDREQ) = 2 OR 3.
C     IN THIS CASE, FOR I = 1(1)N,
C                    SQRT( G(I)**T * H(I)**-1 * G(I) )
C     IS COMPUTED AND STORED IN V, STARTING AT V(IV(REGD)), WHERE
C     RDREQ = 57 AND REGD = 67.  HERE G(I) STANDS FOR THE GRADIENT
C     RESULTING WHEN THE I-TH OBSERVATION IS DELETED AND H(I) STANDS
C     FOR AN APPROXIMATION TO THE CORRESPONDING HESSIAN AT X, THE SOLU-
C     TION CORRESPONDING TO ALL OBSERVATIONS.  (THIS APPROXIMATION IS
C     OBTAINED BY SUBTRACTING THE FIRST-ORDER CONTRIBUTION OF THE I-TH
C     OBSERVATION TO THE HESSIAN FROM A FINITE-DIFFERENCE HESSIAN
C     APPROXIMATION.  IF H IS INDEFINITE, THEN IV(REGD) IS SET TO -1.
C     IF H(I) IS INDEFINITE, THEN -1 IS RETURNED AS THE DIAGNOSTIC FOR
C     OBSERVATION I.  IF NO DIAGNOSTICS ARE COMPUTED, PERHAPS BECAUSE
C     OF A FAILURE TO CONVERGE, THEN IV(REGD) = 0 IS RETURNED.)
C        PRINTING OF THE REGRESSION DIAGNOSTICS IS CONTROLLED BY
C     IV(COVPRT) = IV(14)...  IF IV(COVPRT) = 3, THEN BOTH THE
C     COVARIANCE MATRIX AND THE REGRESSION DIAGNOSTICS ARE PRINTED.
C     IV(COVPRT) = 2 CAUSES ONLY THE REGRESSION DIAGNOSTICS TO BE
C     PRINTED, IV(COVPRT) = 1 CAUSES ONLY THE COVARIANCE MATRIX TO BE
C     PRINTED, AND IV(COVPRT) = 0 CAUSES NEITHER TO BE PRINTED.
C
C        RDREQ = 57 AND REGD = 67.
C
C  ***  GENERAL  ***
C
C     CODED BY DAVID M. GAY.
C
C+++++++++++++++++++++++++++  DECLARATIONS  +++++++++++++++++++++++++++
C
C  ***  EXTERNAL SUBROUTINES  ***
C
      EXTERNAL SIVSET, SRN2G, SN2RDP
c
c--S replaces "?": ?NLAGU, ?RN2G, ?IVSET, ?N2RDP, ?CALCR, ?CALCJ
c
C  SIVSET.... PROVIDES DEFAULT IV AND V INPUT COMPONENTS.
C  SRN2G ...  CARRIES OUT OPTIMIZATION ITERATIONS.
C  SN2RDP...  PRINTS REGRESSION DIAGNOSTICS.
C
C  ***  NO INTRINSIC FUNCTIONS  ***
C
C  ***  LOCAL VARIABLES  ***
C
      INTEGER D1, DR1, IV1, N1, N2, NF, R1, RD1
C
C  ***  IV COMPONENTS  ***
C
      INTEGER D, J, NEXTV, NFCALL, NFGCAL, R, REGD, REGD0, TOOBIG, VNEED
      PARAMETER (D=27, J=70, NEXTV=47, NFCALL=6, NFGCAL=7, R=61,
     1           REGD=67, REGD0=82, TOOBIG=2, VNEED=4)
c --------------------------------  BODY  ------------------------------
C
      IF (IV(1) .EQ. 0) CALL SIVSET(1, IV, LIV, LV, V)
      IV1 = IV(1)
      IF (IV1 .EQ. 14) GO TO 10
      IF (IV1 .GT. 2 .AND. IV1 .LT. 12) GO TO 10
      IF (IV1 .EQ. 12) IV(1) = 13
      IF (IV(1) .EQ. 13) IV(VNEED) = IV(VNEED) + P + N*(P+2)
      CALL   SRN2G(X, V, IV, LIV, LV, N, N, N1, N2, P, V, V, V, X)
      IF (IV(1) .NE. 14) GO TO 999
C
C  ***  STORAGE ALLOCATION  ***
C
      IV(D) = IV(NEXTV)
      IV(R) = IV(D) + P
      IV(REGD0) = IV(R) + N
      IV(J) = IV(REGD0) + N
      IV(NEXTV) = IV(J) + N*P
      IF (IV1 .EQ. 13) GO TO 999
C
 10   D1 = IV(D)
      DR1 = IV(J)
      R1 = IV(R)
      RD1 = IV(REGD0)
C
 20   CALL   SRN2G(V(D1), V(DR1), IV, LIV, LV, N, N, N1, N2, P, V(R1),
     1            V(RD1), V, X)
      IF (IV(1)-2) 30, 50, 60
C
C  ***  NEW FUNCTION VALUE (R VALUE) NEEDED  ***
C
 30   NF = IV(NFCALL)
C%%    (*scalcr)( n, p, x, &nf, &V[r1] );
      CALL SCALCR(N, P, X, NF, V(R1))
      IF (NF .GT. 0) GO TO 40
         IV(TOOBIG) = 1
         GO TO 20
 40   IF (IV(1) .GT. 0) GO TO 20
C
C  ***  COMPUTE DR = GRADIENT OF R COMPONENTS  ***
C
 50   CONTINUE
C%%    (*scalcj)( n, p, x, &Iv[NFGCAL], &V[dr1] );
      CALL SCALCJ(N, P, X, IV(NFGCAL), V(DR1))
      IF (IV(NFGCAL) .EQ. 0) IV(TOOBIG) = 1
      GO TO 20
C
C  ***  INDICATE WHETHER THE REGRESSION DIAGNOSTIC ARRAY WAS COMPUTED
C  ***  AND PRINT IT IF SO REQUESTED...
C
 60   IF (IV(REGD) .GT. 0) IV(REGD) = RD1
      CALL  SN2RDP(IV, LIV, N, V(RD1))
C
 999  RETURN
C
C  ***  LAST CARD OF    SNLAGU FOLLOWS  ***
      END
