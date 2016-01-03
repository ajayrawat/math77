      subroutine DILUPMD (NDIM,X,Y,NTAB,XT,YT,NDEG,LUP,IOPT,EOPT)
c Copyright (c) 2006, Math a la Carte, Inc.
c>> 2006-05-03 DILUPMD Krogh Started this debug routine
c
c--D replaces "?": ?ILUPMD, ?ILUPM, ?MESS
c
c Provide debugging information for Multidimensional Polynomial
c Interpolation with Look Up, dilupm.
c Design/Code by Fred T. Krogh, Math a la Carte, Inc.
c
c *****************     Formal Arguments     ***************************
c
c These are exactly as for dilupm.  See dilupm.f for details.
c
c *****************     Variables Referenced     ***********************
c
c EOPT   Formal argument, see dilupm.f.
c FDAT   Place to store floating point for error messages.
c I      Temporary index.
c IOPT   Formal argument, see dilupm.f.
c IN     Array used to track current index in each dimension.
c INTCHK Array used for printing integers in error messages.
c IYT    Pointer to YT information for the current output.
c J      Index of a 0 in NTAB which is followed by user information
c        specifying the number of data points as a function of
c        previously used values from XT.
c K      Temporary index.
c KNT    Array used to keep count of number of values to output in
c        each dimension.
c LR     Arrray used to find ragged table information in each ragged
c        dimension.
c LTXTxx Parameter names of this form were generated by PMESS in making
c        up text for error messages and are used to locate various parts
c        of the message.
c LUP    Formal argument, see dilupm.f.
c LX     Array giving start of XT table for each dimension.
c MACT   Array giving actions for printing error messages, see MESS.
c MAXDEG Parameter -- Gives maximum degree of polynomial interpolation.
c MECONT Parameter telling MESS an error message is to be continued.
c MEEMES Parameter telling MESS to print an error message.
c MEIVEC Parameter telling MESS to print an integer vector.
c MEFVEC Parameter telling MESS to print an floating point vector.
c MEMDA1 Parameter telling MESS that next item is integer data to be
c        made available for output.
c MERET  Parameter telling MESS that this ends the error message.
c MESS   Subroutine for printing error messages.
c METDIG Parameter for DMESS to set temporily the digits printed.
c NDEG   Formal argument, see dilupm.f.
c NDIM   Formal argument, see dilupm.f.
c NDIMI  Internal value for NDIM = number of dimensions.
c NTAB   Formal argument, see dilupm.f.
c NTABM  = NTABXT + NDIMI -- NTAB(NTABM+I) is 1 + the index of the last
c        word in NTAB required for ragged table storage through dim. I.
c NTABXT = NDIMI+1 -- NTAB(NTABXT) = index of first ragged table, =1000
c        if there is no ragged table.  NTABN(NTABXT+I) = base address
c        accessing XT information.
c NUP    Array containing 0, unless an index change in this dimension
c        triggers a change in a ragged pointer.
c DMESS  Calls MESS and prints floating data in error messages.
c X      Formal argument, see dilupm.f.
c XT     Formal argument, see dilupm.f.
c Y      Formal argument, see dilupm.f.
c YT     Formal argument, see dilupm.f.
c
c *****************     Formal Variable Declarations     ***************
c
      integer          NDIM, NTAB(*), NDEG(*), LUP(*), IOPT(*)
      double precision X(NDIM), Y, XT(*), YT(*), EOPT(*)
c
c *****************    Parameters and Internal Varialbes ***************
c
c       MAXDEG and MAXDIM Should agree with values dilupm.f
      integer MAXDEG, MAXDIM
      parameter (MAXDEG=15, MAXDIM=10)
 
      integer I, IIFLG, IN(MAXDIM), INTCHK(4), IYT, J, K, KNT(MAXDIM),
     1  L, LR(MAXDIM-1), LT, LX(MAXDIM), NDIMI, NTABM, NTABXT,
     2  NUP(MAXDIM)
c
c ************************ Error Message Stuff and Data ****************
c
c Parameter defined below are all defined in the error message program
c MESS and DMESS.
c
      integer MEMDA1,MECONT,MERET,MENTXT,METEXT,MEIVEC,MEFVEC,METDIG
      parameter (MEMDA1=27, MECONT =50, MERET=51, MENTXT=23,
     1  METEXT=53, MEIVEC=57, MEFVEC=61, METDIG=22)
c
      integer MLOC(12)
      integer MACT(4), MACTDG(3), MACTIV(4), MACTIV1(6),  MACTFV(4)
      double precision FDAT(MAXDIM)
c
c ********* Error message text ***************
c ********* Error message text ***************
c[Last 2 letters of Param. name]  [Text generating message.]
cAA Inputs to DILUPM, with NDIM = $I, EOPT dim. of $I.$E
cAB IOPT($I) = $I, is not a valid option.$E
cAC IOPT($I) = $I, requests an error estimate.$E
cAD IOPT($I) = $I, specifies$E
cAE IOPT($I) = $I, Store derivatives at $I, Max. total derivative $C
c   of $I,$E
cAF IOPT($I) = $I, requests Abs. & Rel. errors of: $F $F$E
cAG IOPT($I) = $I, request accuracy of $F$E
cAH IOPT($I) = $I, skips data points with YT(?) = $F$E
cAI LUP($I) = $I; it should be < 4.$E
cAJ Ragged table badly specified in dimension $I.$E
cAK Start of ragged table, NTAB($I) = $I; it must be 0.$E
cAL Middle of ragged table, NTAB($I) = $I; it must be >0.$E
cAM End of ragged table, NTAB($I) = $I; it must be -1.$E
c   $
cAN Extrpolation polynomial degrees:$B
c   $
cAO max derivatives per X(I):$B
c   $
cAP NDEG():$B
c   $
cAQ LUP():$B
c   $
cAR NTAB():$B
c   $
cAS X(): $B
c   $
cAT Dim. 1 XT's = $B
c   $
cAU Dim. 1 to $I XT's = $B
c   $
cAV Dim. $I XT's = $F + k * %F$E
c   $
cAW Dim. $I XT's = $B
c   $
cAX YT's = $B
c   $
cAY Original ragged size specifications for dimenaion $M:$N$B
c   $
cAZ Start of XT specifications for each dimension:$B
c   $
cBA Start of specifications for each ragged dimension:$B
c   $
cBB Final Ragged Specifications:$B
c   $
cBC Dim. 1 to $M Indexes:$B
c   $
      integer LTXTAA,LTXTAB,LTXTAC,LTXTAD,LTXTAE,LTXTAF,LTXTAG,LTXTAH,
     * LTXTAI,LTXTAJ,LTXTAK,LTXTAL,LTXTAM,LTXTAN,LTXTAO,LTXTAP,LTXTAQ,
     * LTXTAR,LTXTAS,LTXTAT,LTXTAU,LTXTAV,LTXTAW,LTXTAX,LTXTAY,LTXTAZ,
     * LTXTBA,LTXTBB,LTXTBC
      parameter (LTXTAA=  1,LTXTAB= 53,LTXTAC= 92,LTXTAD=136,LTXTAE=162,
     * LTXTAF=232,LTXTAG=286,LTXTAH=325,LTXTAI=375,LTXTAJ=408,
     * LTXTAK=455,LTXTAL=508,LTXTAM=563,LTXTAN=  1,LTXTAO=  1,
     * LTXTAP=  1,LTXTAQ=  1,LTXTAR=  1,LTXTAS=  1,LTXTAT=  1,
     * LTXTAU=  1,LTXTAV=  1,LTXTAW=  1,LTXTAX=  1,LTXTAY=  1,
     * LTXTAZ=  1,LTXTBA=  1,LTXTBB=  1,LTXTBC=  1)
      character MTXTAA(3) * (205)
      character MTXTAB(1) * (34)
      character MTXTAC(1) * (27)
      character MTXTAD(1) * (9)
      character MTXTAE(1) * (8)
      character MTXTAF(1) * (9)
      character MTXTAG(1) * (7)
      character MTXTAH(1) * (16)
      character MTXTAI(1) * (22)
      character MTXTAJ(1) * (28)
      character MTXTAK(1) * (17)
      character MTXTAL(1) * (9)
      character MTXTAM(1) * (57)
      character MTXTAN(1) * (48)
      character MTXTAO(1) * (52)
      character MTXTAP(1) * (30)
      character MTXTAQ(1) * (23)
      data MTXTAA/'Inputs to DILUPM, with NDIM = $I, EOPT dim. of $I.$EI
     *OPT($I) = $I, is not a valid option.$EIOPT($I) = $I, requests an e
     *rror estimate.$EIOPT($I) = $I, specifies$EIOPT($I) = $I, Store der
     *ivatives at $I, Max.',' total derivative of $I,$EIOPT($I) = $I, re
     *quests Abs. & Rel. errors of: $F $F$EIOPT($I) = $I, request accura
     *cy of $F$EIOPT($I) = $I, skips data points with YT(?) = $F$ELUP($I
     *) = $I; it should be < 4.$ERag','ged table badly specified in dime
     *nsion $I.$EStart of ragged table, NTAB($I) = $I; it must be 0.$EMi
     *ddle of ragged table, NTAB($I) = $I; it must be >0.$EEnd of ragged
     * table, NTAB($I) = $I; it must be -1.$E '/
      data MTXTAB/'Extrpolation polynomial degrees:$B'/
      data MTXTAC/'max derivatives per X(I):$B'/
      data MTXTAD/'NDEG():$B'/
      data MTXTAE/'LUP():$B'/
      data MTXTAF/'NTAB():$B'/
      data MTXTAG/'X(): $B'/
      data MTXTAH/'Dim. 1 XT''s = $B'/
      data MTXTAI/'Dim. 1 to $I XT''s = $B'/
      data MTXTAJ/'Dim. $I XT''s = $F + k * %F$E'/
      data MTXTAK/'Dim. $I XT''s = $B'/
      data MTXTAL/'YT''s = $B'/
      data MTXTAM/'Original ragged size specifications for dimenaion $M:
     *$N$B'/
      data MTXTAN/'Start of XT specifications for each dimension:$B'/
      data MTXTAO/'Start of specifications for each ragged dimension:$B'
     */
      data MTXTAP/'Final Ragged Specifications:$B'/
      data MTXTAQ/'Dim. 1 to $M Indexes:$B'/
c ********* End of code generated by PMESS **************
 
c
      data MLOC /LTXTAA, LTXTAB, LTXTAC, LTXTAD, LTXTAE, LTXTAF, LTXTAG,
     1  LTXTAH, LTXTAI, LTXTAJ, LTXTAK, LTXTAL /
      data MACTDG / METDIG, 6, MERET /
c                      1  2       3      4
      data MACT / MENTXT, 0, METEXT, MERET /
c                        1       2  3      4
      data MACTIV / METEXT, MEIVEC, 0, MERET /
c                         1  2       3       4  5      5
      data MACTIV1 / MEMDA1, 0, METEXT, MEIVEC, 0, MERET/
      data MACTFV / METEXT, MEFVEC, 0, MERET /
c
c *****************     Start of executable code     *******************
c
      NDIMI = NDIM
      NTABXT = NDIMI+1
      NTABM = NTABXT + NDIMI
      I = 0
      INTCHK(1) = NDIMI
      INTCHK(2) = IOPT(2)
      MACT(2) = MLOC(1)
      call DMESS(MACTDG, MTXTAA, INTCHK, FDAT)
 10   continue
      call DMESS(MACT, MTXTAA, INTCHK, FDAT)
      if (I .eq. 0) then
        if ((NDIMI .gt. MAXDIM) .or. (NDIMI .le. 0)) stop
     1    'Code requires 0 < NDIM < 11.'
        if (NTAB(NTABXT) .le. 0) then
c This block of code copied indented, else unchanged from dilupm.f,
c except for code between lines starting with c###
          NTAB(NTABXT) = 1000
          NTAB(NTABXT+1) = 1
          do 40 I = 1, NDIMI
            if (LUP(I) .ge. 4) then
c                       LUP(I) is out of range -- fatal error.
              INTCHK(1) = I
              INTCHK(2) = LUP(I)
              IIFLG = -3
            end if
            L = NTAB(I)
            if (L .gt. 0) then
c                             Table is not ragged up to this point.
              if (I .eq. NDIMI) go to 50
c                       If table is ragged save pointer to ragged info.
              if (NTAB(NDIMI) .lt. 0)  NTAB(NTABM+I) = NTABM+NDIMI
c       Get pointer to start of XT data for next dimension
              if (LUP(I) .eq. 3) then
                NTAB(NTABXT+I+1) = NTAB(NTABXT+I) + 2
              else
                NTAB(NTABXT+I+1) = NTAB(NTABXT+I) + L
              end if
            else if ((L .eq. 0) .or. ((L .ne. 1-I) .and.
     1          ((I .ne. NDIMI) .or. (L .le. -I)))) then
c                                 Problem in specifying raggedness.
              LT = NDIMI
              INTCHK(1) = I
              IIFLG = -4
              go to 400
            else
              J = NTAB(NTABM+I-1)
              if (NTAB(I-1) .gt. 0) then
                NTAB(NTABXT) = -NTAB(I)
c       Get K = number of NTAB entries of extra data
                K = NTAB(1)
                do 20 L = 2, -L
                  K = K * NTAB(L)
 20             continue
              else
                K = NTAB(J-1)
              end if
              if (NTAB(J) .ne. 0) then
                LT = J
                INTCHK(1) = J
                INTCHK(2) = NTAB(J)
                IIFLG = -5
                go to 400
              end if
c       Change data to be the partial sum of the original data.
              LT = J + K
 
 
c### This block of code added to that from dilupm
              MACTIV1(2) = I
              MACTIV1(5) = LT - J + 1
              call MESS(MACTIV1, MTXTAM, NTAB(J))
c### End of added block
 
 
              do 30 L = J + 1, LT
                if (NTAB(L) .le. 0) then
c                     Error, bad value inside ragged table info.
                  INTCHK(1) = L
                  INTCHK(2) = NTAB(L)
                  IIFLG = -6
                  go to 400
                end if
                NTAB(L) = NTAB(L) + NTAB(L-1)
 30           continue
              if (I .eq. NDIMI) then
                LT = LT + 1
                if (NTAB(LT) .eq. -1) go to 50
c                    Error -- No end tag where needed.
                INTCHK(1) = LT
                INTCHK(2) = NTAB(LT)
                IIFLG = -7
                go to 400
              end if
c       Save index of 0th NTAB entry for extra data for next dim.
              NTAB(NTABM+I) = J + K + 1
c       Get pointer to start of XT data for next dimension
              if (LUP(I) .eq. 3) then
                NTAB(NTABXT+I+1) = NTAB(NTABXT+I) + 2*K
              else
                NTAB(NTABXT+I+1) = NTAB(NTABXT+I)+NTAB(J+K)
              end if
            end if
 40       continue
        end if
 50     continue
c End of code included from DILUPM
        I = 2
 
      else if ((INTCHK(2) .le. 0) .or. (INTCHK(2) .gt. 6)) then
c               A bad option value
        stop
      else if (INTCHK(2) .eq. 2) then
c               Print out desired polynomial degrees for extrpolation.
        MACTIV(3) = NDIMI
        call MESS(MACTIV, MTXTAB, IOPT(I+1))
        I = I + NDIMI
      else if (INTCHK(2) .eq. 3) then
c                Print out the derivative information
        MACTIV(3) = NDIMI
        call MESS(MACTIV, MTXTAC, IOPT(I+3))
        I = I + NDIMI + 2
      end if
 100  continue
      I = I + 1
      INTCHK(1) = I
      INTCHK(2) = IOPT(I)
      MACT(2) = MLOC(INTCHK(2) + 2)
      if (INTCHK(2) .eq. 0) go to 200
c             1   2    3    4    5    6
      go to (10, 10, 130, 140, 140, 140), INTCHK(2)
      MACT(2) = MLOC(2)
      go to 10
 130  INTCHK(3) = IOPT(I+1)
      INTCHK(4) = IOPT(I+2)
      go to 10
 140  FDAT(1) = EOPT(IOPT(I+1))
      if (INTCHK(2) .eq. 4) FDAT(2) = EOPT(IOPT(I+1)+1)
      I = I + 1
      go to 10
 
 200  continue
      MACTIV(3) = NDIMI
      call MESS(MACTIV, MTXTAD, NDEG)
      call MESS(MACTIV, MTXTAE, LUP)
      MACTIV(3) = NDIMI + 1
      call MESS(MACTIV, MTXTAF, NTAB)
      MACTIV(3) = NDIMI
      if (NTAB(NTABXT) .eq. 0) go to 300
      call MESS(MACTIV, MTXTAN, NTAB(NTABXT+1))
      if (NTAB(NTABXT) .lt. 100) then
        call MESS(MACTIV, MTXTAO, NTAB(NTABXT+NDIMI+1))
        MACTIV(3) = LT - NTABXT - 2*NDIMI
        call MESS(MACTIV, MTXTAP, NTAB(NTABXT+2*NDIMI+1))
      end if
      MACTFV(3) = NDIMI
      call DMESS(MACTFV, MTXTAG, INTCHK, X)
      MACTFV(3) = NTAB(1)
      call DMESS(MACTFV, MTXTAH, INTCHK, XT)
c
c Set up for output of XT and YT
      do 220 I = 1, NDIMI
        NUP(I) = 0
        IN(I) = 1
        LX(I) = NTAB(NTABXT+I)
        if (NTAB(I) .lt. 0) then
          LR(I) = NTAB(2*NDIMI+I)
          KNT(I) = NTAB(LR(I)+1) - NTAB(LR(I))
        else
          KNT(I) = NTAB(I)
        end if
        FDAT(I) = XT(LX(I))
 220  continue
      IYT = 1
 240  continue
c  Print XT, YT data for the current selection.
      I = NDIMI
      MACTIV1(2) = I - 1
      MACTIV1(5) = I - 1
      call MESS(MACTIV1, MTXTAQ, IN)
      MACTFV(3) = I - 1
      INTCHK(1) = I - 1
      call DMESS(MACTFV, MTXTAI, INTCHK, FDAT)
      MACTFV(3) = KNT(I)
      INTCHK(1) = I
      if (LUP(I) .eq. 3) then
        call DMESS(MACT(3), MTXTAJ, INTCHK, XT(LX(I)))
      else
        call DMESS(MACTFV, MTXTAK, INTCHK, XT(LX(I)))
      end if
      call DMESS (MACTFV, MTXTAL, INTCHK, YT(IYT))
      IYT = IYT + MACTFV(3)
 250  continue
      if (NTAB(I) .lt. 0) NUP(-NTAB(I)) = I
      FDAT(I) = XT(LX(I))
      I = I - 1
c               Test if we are done.
      if (I .eq. 0) go to 300
      if (NUP(I) .ne. 0) then
        K = NUP(I)
        if (LUP(K) .eq. 3) then
          LX(K) = LX(K) + 2
        else
          LX(K) = LX(K) + KNT(K)
        end if
        FDAT(K) = XT(LX(K))
        LR(K) = LR(K) + 1
        KNT(K) = NTAB(LR(K)+1) - NTAB(LR(K))
      end if
      if (IN(I) .lt. KNT(I)) then
        if (LUP(I) .eq. 3) then
          FDAT(I) = XT(LX(I)) + IN(I) * XT(LX(I)+1)
        else
          FDAT(I) = XT(LX(I) + IN(I))
        end if
        IN(I) = IN(I) + 1
        go to 240
      end if
      IN(I) = 1
      go to 250
c
c Restore default for number of digits before exit
 300  continue
      call DMESS(MACTDG, MTXTAA, INTCHK, FDAT)
      print '(''End of output'')'
      return
 
 
 
c More error message processing for errors that would show in dilupm.f
 400  continue
c  Restore state in NTAB.
      if (NTAB(NTABXT) .lt. 0) then
        do 410 I = 3*NDIMI+2, LT - 2
          NTAB(I) = NTAB(I+1) - NTAB(I)
 410    continue
      end if
      NTAB(NTABXT) = 0
      MACT(2) = MLOC(7-IIFLG)
      call MESS (MACT, MTXTAA, INTCHK(1))
      I = 2
      go to 100
      end
