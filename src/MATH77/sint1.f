      SUBROUTINE SINT1 (A,B,ANSWER,WORK,IOPT)
c Copyright (c) 1996 California Institute of Technology, Pasadena, CA.
c ALL RIGHTS RESERVED.
c Based on Government Sponsored Research NAS7-03001.
C>> 1996-03-31 SINT1  Krogh  Removed unused variable in common.
c>> 1995-11-20 SINT1  Krogh  Converted from SFTRAN to Fortran 77.
c>> 1994-10-19 SINT1  Krogh  Changes to use M77CON
c>> 1994-07-07 SINT1  Snyder set up for CHGTYP.
C>> 1993-05-18 SINT1  Krogh -- Changed "END" to "END PROGRAM"
C>> 1991-09-20 SINT1  Krogh converted '(1)' dimensioning to '(*)'.
C>> 1987-11-19 SINT1  Snyder  Initial code.
C
c--S replaces "?": ?INT1, ?INTA, ?intc, ?intec, ?INTF, ?INTOP, ?INTNC
C     ******************************************************************
C
C     THIS SUBROUTINE ATTEMPTS TO CALCULATE THE INTEGRAL OF A FUNCTION
C     OVER THE INTERVAL A TO B TO WITHIN A TOLERANCE LEVEL SPECIFIED
C     BY THE USER.  THE FUNCTION IS PROVIDED BY THE USER VIA A
C     SUBPROGRAM REFERENCED BY CALL SINTF (F,X,IFLAG), OR BY REVERSE
C     COMMUNICATION.  IN THE CASE OF ONE-DIMENSIONAL QUADRATURE, IFLAG
C     IS ALWAYS ZERO.  ALL ABSCISSAE ARE WITHIN THE INTERVAL OF
C     INTEGRATION.
C
C     THE RESULT IS OBTAINED USING QUADRATURE FORMULAE DUE TO
C     T. N. L. PATTERSON, MATHEMATICS OF COMPUTATION, VOLUME 22,
C     PAGES 847-856, 1968.
C
C     *****    WARNING   ***********************************************
C
C     THE RELIABILITY AND EFFICIENCY OF THIS PROGRAM ARE STRONGLY
C     INFLUENCED BY DISCONTINUITIES IN THE FUNCTION OR IT'S
C     DERIVATIVES, INTEGRABLE SINGULARITIES ON THE INTERVAL OF
C     INTEGRATION, AND NON-INTEGRABLE SINGULARITIES NEAR THIS INTERVAL
C     (INCLUDING COMPLEX VALUES).  THE EFFICIENCY AND RELIABILITY
C     OF INTEGRATING SUCH FUNCTIONS MAY BE GREATLY IMPROVED BY MANUALLY
C     SUBDIVIDING THE INTERVAL OF INTEGRATION AT THE DISCONTINUITY,
C     SINGULARITY OR CLOSEST POINT TO A POLE, AND SUMMING THE ANSWERS.
C     A CHANGE OF VARIABLE TO ELIMINATE OR REDUCE THE STRENGTH OF THE
C     SINGULARITY WILL SIGNIFICANTLY IMPROVE PERFORMANCE.
C
C     *****    FORMAL ARGUMENTS    *************************************
C
C A       LOWER LIMIT OF INTERVAL OF INTEGRATION.
      REAL             A
C B       UPPER LIMIT OF INTERVAL OF INTEGRATION.
      REAL             B
C ANSWER  IS THE ESTIMATE OF THE INTEGRAL.  WHEN REVERSE COMMUNICATION
C         IS SPECIFIED IT IS USED TO PASS FUNCTION VALUES FROM
C         THE USER PROGRAM TO SINTA.
      REAL             ANSWER
C WORK    IS A WORKING STORAGE VECTOR USED BY OPTIONS (SEE IOPT).
C         WHEN THE INTEGRATION IS COMPLETE, WORK(1) CONTAINS THE
C         ESTIMATED ABSOLUTE ERROR.  WHEN REVERSE COMMUNICATION
C         IS SPECIFIED, WORK(1) IS USED TO PASS ABSCISSAE FROM
C         SINTA TO THE USER PROGRAM.
      REAL             WORK(*)
C IOPT    IS A VECTOR OF INTEGERS USED TO RETURN THE STATUS AND TO
C         SPECIFY OPTIONS.
      INTEGER IOPT(*)
C         IOPT(1) IS USED TO RETURN A STATUS INDICATOR TO THE USER.
C         VALUES OF THE STATUS INDICATOR ARE
C         -1 - NORMAL TERMINATION, EITHER THE ABSOLUTE OR THE RELATIVE
C              ERROR CRITERIA ARE SATISFIED.
C         -2 - NORMAL TERMINATION, NEITHER THE ABSOLUTE NOR THE
C              RELATIVE ERROR CRITERIA ARE SATISFIED, BUT THE RELATIVE
C              TO THE OBTAINABLE ERROR CRITERION IS SATISFIED.
C         -3 - NORMAL TERMINATION, BUT NONE OF THE ERROR CRITERIA ARE
C              SATISFIED.
C         +4 - BAD IOPT VALUE.
C         +5 - TOO MANY FUNCTION VALUES NEEDED.
C         +6 - APPARENT NON-INTEGRABLE SINGULARITY NEAR ANSWER.
C         ENTRIES IN IOPT STARTING AT IOPT(2) ARE DESCRIBED BELOW.
C         IOPT(I)    ENTRY IN IOPT(I) MEANS
C           0        NO MORE OPTIONS, BEGIN INTEGRATION.
C           1        IOPT(I+1) CONTAINS THE UNIT NUMBER FOR OUTPUT.
C           2        IOPT(I+1) IS DIAGNOSTIC PRINT LEVEL
C                    0 - NO PRINTING
C                    1 - MINIMUM PRINTING - ERROR MESSAGES (DEFAULT)
C                    2 - PANEL BOUNDARIES AND ANSWERS
C                    3 - ERROR ESTIMATES FOR EACH QUADRATURE FORMULA
C                    4 - DETAILED OUTPUT (DIFFERENCE LINES, ETC).
C           3        WORK(IOPT(I+1)) CONTAINS THE ABSOLUTE TOLERANCE,
C                    WORK(IOPT(I+1)+1) CONTAINS TOLERANCE RELATIVE TO
C                    THE LOCALLY OBTAINABLE PRECISION, AND
C                    WORK(IOPT(I+1)+2) CONTAINS TOLERANCE RELATIVE TO
C                    THE VALUE OF THE INTEGRAL.  THE TOLERANCE RELATIVE
C                    TO THE LOCALLY OBTAINABLE PRECISION IS SPECIFIED AS
C                    THE FRACTION OF LOCALLY OBTAINABLE DIGITS THAT ARE
C                    PERMITTED TO BE WRONG, AND IS INTERNALLY BOUNDED
C                    BETWEEN 0.0 AND 1.0.  IF ANY OF THE ERROR CONTROL
C                    CRITERIA ARE SATISFIED, THE ANSWER IS ACCEPTED.  IF
C                    THIS OPTION IS NOT USED, THE ABSOLUTE AND RELATIVE
C                    TOLERANCES ARE SET TO ZERO, AND THE TOLERANCE
C                    RELATIVE TO THE LOCALLY OBTAINABLE PRECISION IS SET
C                    TO 0.25.
C           4        WORK(IOPT(I+1)) CONTAINS ABSOLUTE ERROR COMMITTED
C                    COMPUTING F.  WORK(IOPT(I+1)) MAY BE CHANGED DURING
C                    THE INTEGRATION.
C           5        WORK(IOPT(I+1)) CONTAINS RELATIVE ERROR EXPECTED TO
C                    BE COMMITTED COMPUTING F.  CHANGES TO THIS VALUE
C                    DURING INTEGRATION WILL NOT BE DETECTED.
C           6        USE REVERSE COMMUNICATION -
C                    CALL SINT1 (A,B,ANSWER,WORK,IOPT)
C                  1 CALL SINTA (ANSWER,WORK,IFLAG)
C                    IF (IFLAG.NE.0) GO TO 2
C                    ANSWER=F(WORK(1))
C                    GO TO 1
C                  2 CONTINUE
C                    IFLAG AT THIS POINT CONTAINS THE SAME VALUE AS
C                    THE STATUS FLAG WOULD (IF SELECTED) FOR THE
C                    FORWARD COMMUNICATION METHOD.
C           7        SET MINIMUM INDEX OF QUADRATURE FORMULA TO USE
C                    BEFORE SUBDIVISION TO IOPT(I+1).
C           8        NO EFFECT.  MAY BE USED TO PASS INFORMATION INTO
C                    SINTF.  INCREMENT I BY 2.
C           9        IOPT(I+1) IS THE MAXIMUM NUMBER OF FUNCTION VALUES
C                    TO USE TO INTEGRATE THE ENTIRE PROBLEM.  IF
C                    IOPT(I+1) .LE. 0, THE NUMBER OF FUNCTION VALUES
C                    IS NOT CONTROLLED.
C          10        IOPT(I+1) IS USED TO RETURN THE NUMBER OF FUNCTION
C                    VALUES USED TO INTEGRATE THE ENTIRE PROBLEM.
C          11        WORK(IABS(IOPT(I+1))) IS THE LOCATION OF A
C                    SINGULARITY OR DISCONTINUITY.  IF THE LOCATION IS
C                    INSIDE THE INTERVAL, THE INTERVAL WILL BE
C                    IMMEDIATELY SUBDIVIDED.  IF IOPT(I+1).GT.0, A
C                    T**2 SUBSTITUTION BASED AT WORK(...) WILL BE USED.
C                    IF IOPT(I+1) .LT. 0 A T**4 SUBSTITUTION WILL BE
C                    USED.  IF IOPT(I+1) .EQ. 0, NO SUBSTITUTION WILL BE
C                    USED.
C          12        WORK(IOPT(I+1)) CONTAINS THE ABSOLUTE ERROR IN THE
C                    LOWER LIMIT OF THE CURRENT DIMENSION.  THE ERROR IN
C                    THE UPPER LIMIT IS IN WORK(IOPT(I+1)+1).
C          13        IS USED ONLY FOR MULTIDIMENSIONAL PROBLEMS.
C
C     ALL OPTIONS ARE SET TO THEIR NOMINAL VALUES BEFORE THE OPTION
C     VECTOR IS PROCESSED.
C
C     *****    EXTERNAL REFERENCES     *********************************
C
C SINTA   TO PERFORM THE INTEGRATION.
C SINTOP  TO SET OPTIONS.
C
C     *****    COMMON STORAGE     **************************************
C
C                    Common blocks are: SINTNC, SINTC, and SINTEC
C     COMMON /SINTNC/ CONTAINS VARIABLES NOT SEPARATELY SAVED FOR
C     EACH DIMENSION OF A MULTIPLE QUADRATURE.  COMMON /SINTC/
C     CONTAINS VARIABLES THAT MUST BE SAVED FOR EACH DIMENSION OF THE
C     QUADRATURE.  THE VARIABLES IN EACH COMMON BLOCK ARE STORED IN THE
C     ORDER - ALWAYS DOUBLE, DOUBLE IF DOUBLE PRECISION PROGRAM, DOUBLE
C     IF DOUBLE PRECISION PROGRAM AND EXPONENT RANGE OF DOUBLE AND
C     SINGLE VERY DIFFERENT, SINGLE, INTEGER, LOGICAL.  A PAD OF LOGICAL
C     VARIABLES IS INCLUDED AT THE END OF /SINTC/.  THE DIMENSION OF
C     THE PAD MAY NEED TO BE VARIED SO THAT NO VARIABLES BEYOND THE END
C     OF THE COMMON BLOCK ARE ALTERED.
C
C     DECLARATIONS OF COMMON /SINTNC/ VARIABLES.
C
      REAL             AINIT, BINIT, FNCVAL, S, TP
      REAL             FER, FER1, RELOBT, TPS, XJ, XJP
      INTEGER     FEA,       FEA1,      INC,       INC2,      IPRINT,
     1 ISTOP(2,2),JPRINT,    KDIM,      KK,        KMAXF,     NDIM,
     2 NFINDX,    NFMAX,     NFMAXM,    RELTOL,    REVERM,    REVERS,
     3 WHEREM
      LOGICAL NEEDH
C
C     DECLARATIONS OF COMMON /SINTC/ VARIABLES.
C
c--D Next line special: S => D, X => Q, D => D, P => D
      DOUBLE PRECISION ACUM, PACUM, RESULT(2)
C     139 $.TYPE.$ VARIABLES
      REAL
     1 AACUM,     ABSCIS,    DELMIN,    DELTA,     DIFF,      DISCX(2),
     2 END(2),    ERRINA,    ERRINB,    FAT(2),    FSAVE,
     3 FUNCT(24), F1,        F2,        LOCAL(4),  PAACUM,    PF1,
     4 PF2,       PHISUM,    PHTSUM,    PX,        SPACE(6),
     5 STEP(2),   START(2),  SUM,       T,         TA,        TASAVE,
     6 TB,        TEND,      WORRY(2),  X,         X1,
     7 X2,        XT(17),    FT(17),    PHI(34)
c Note XT, FT, and PHI above are last, because they must be in adjacent
c locations in SINTC.
C     30 $DSTYP$ VARIABLES
      REAL
     1 ABSDIF,    COUNT,     EDUE2A,    EDUE2B,    EP,        EPNOIZ,
     2 EPS,       EPSMAX,    EPSMIN,    EPSO,      EPSR,      EPSS,
     3 ERR,       ERRAT(2),  ERRC,      ERRF,      ERRI,      ERRT(2),
     4 ESOLD,     EXTRA,     PEPSMN,    RE,        RELEPS,    REP,
     5 REPROD,    RNDC,      TLEN,      XJUMP
C     29 INTEGER VARIABLES
      INTEGER     DISCF,     DISCHK,    ENDPTS,    I,         INEW,
     1 IOLD,      IP,        IXKDIM,    J,         J1,        J1OLD,
     2 J2,        J2OLD,     K,         KAIMT,     KMAX,      KMIN,
     3 L,         LENDT,     NFEVAL,    NFJUMP,    NSUB,      NSUBSV,
     4 NXKDIM,    PART,      SEARCH,    TALOC,     WHERE,     WHERE2
C     11 TO 18 LOGICALS (7 ARE PADDING).
      LOGICAL     DID1,      FAIL,      FATS(2),   FSAVED,    HAVDIF,
     1 IEND,      INIT,      ROUNDF,    XCDOBT(2), PAD(7)
C
C     THE COMMON BLOCKS.
C
      COMMON /SINTNC/
c        1       2       3     4        5       6       7        8
     W AINIT,  BINIT,  FNCVAL, S,      TP,     FER,    FER1,   RELOBT,
c       9      10       11      12      13       1       2        3
     X TPS,    XJ,     XJP,    FEA,    FEA1,   KDIM,    INC,    INC2,
c     4 (2,2)    8       9     10       11      12       13      14
     Y ISTOP,  JPRINT, IPRINT, KK,     KMAXF,  NDIM,   NFINDX, NFMAX,
c        15     16       17      18      19      20
     Z NFMAXM, RELTOL, REVERM, REVERS, WHEREM, NEEDH
      COMMON /SINTC/
     1 ACUM,   PACUM,  RESULT
      COMMON /SINTC/
c        1     2 (4)     6      7        8       9      10     11 (2)
     1 AACUM,  LOCAL,  ABSCIS, TA,     DELTA,  DELMIN, DIFF,   DISCX,
c     13 (2)     15      16    17 (2)   19     20 (24) 44
     2 END,    ERRINA, ERRINB, FAT,    FSAVE,  FUNCT,  F2,
c       45      46     47       48      49     50      51 (6)
     3 PAACUM, PF1,    PF2,    PHISUM, PHTSUM, PX,     SPACE,
c      57 (2)  59 (2)   61     62        63    64       65
     4 STEP,   START,  SUM,    T,      TASAVE, TB,     TEND,
c      66 (2)  68      69      70      71       72
     5 WORRY,  X1,     X2,     X,      F1,     COUNT,
c      73 (17) 90 (17) 107 (34)
     6 XT,     FT,     PHI
      COMMON /SINTC/
c       141     142    143     144      145     146
     1 ABSDIF, EDUE2A, EDUE2B, EP,     EPNOIZ, EPSMAX,
c       147     148     149    150 (2)  152     153
     2 EPSO,   EPSR,   EPSS,   ERRAT,  ERRC,   ERRF,
c     154 (2)   156     157     158     159    160
     3 ERRT,   ESOLD,  EXTRA,  PEPSMN, RELEPS, REP,
c       161     162     163
     4 RNDC,   TLEN,   XJUMP,
c       164    165      166    167    168       169
     5 ERRI,   ERR,    EPSMIN, EPS,    RE,     REPROD
      COMMON /SINTC/
c       170     171     172
     1 DISCF,  DISCHK, ENDPTS, INEW,   IOLD,   IP,     IXKDIM,
     2 J,      J1,     J1OLD,  J2,     J2OLD,  KMAX,   KMIN,
     3 L,      LENDT,  NFJUMP, NSUBSV, NXKDIM, TALOC,  WHERE2,
c      1       2          3      4       5         6      7       8
     4 I,      K,      KAIMT,  NSUB,   PART,   SEARCH, WHERE, NFEVAL
      COMMON /SINTC/
     1 DID1,   FAIL,   FATS,   FSAVED, HAVDIF, IEND,   INIT,   ROUNDF,
     2 XCDOBT, PAD
      SAVE /SINTNC/, /SINTC/
C
C     THE VARIABLES HERE DEFINE THE MACHINE ENVIRONMENT.  ALL ARE SET
C     IN SINTOP.  THE MEANING ATTACHED TO THESE VARIABLES CAN BE
C     FOUND BY LOOKING AT THE DEFINITIONS IN SINTOP.
      REAL
     1  EMEPS,  EEPSM8, EDELM2, EDELM3, ESQEPS, ERSQEP, ERSQE6, EMINF,
     2  ESMALL, ENZER,  EDELM1, ENINF
      COMMON /SINTEC/
     1  EMEPS,  EEPSM8, EDELM2, EDELM3, ESQEPS, ERSQEP, ERSQE6, EMINF,
     2  ESMALL, ENZER,  EDELM1, ENINF
      SAVE /SINTEC/
C
C     *****    PROCEDURES     ******************************************
C
      WHERE=0
      NDIM=1
      KDIM=1
      NFEVAL=0
      CALL SINTOP (IOPT,WORK)
      IF (IOPT(1).EQ.0) THEN
C
C        CALL SINTA TO DO THE INTEGRATION.
C
         AINIT=A
         BINIT=B
         IF (REVERS.EQ.0) CALL SINTA (ANSWER,WORK,IOPT)
      END IF
      RETURN
C
      END
