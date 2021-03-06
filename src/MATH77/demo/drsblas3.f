c     program DRSBLAS3
c>> 2001-05-22 DRSBLAS3 Krogh Minor change for making .f90 version.
c>> 1996-05-28 DRSBLAS3 Krogh Added external statement.
c>> 1994-10-19 DRSBLAS3 Krogh  Changes to use M77CON
c>> 1992-03-16 DRSBLAS3 CLL
c>> 1991-07-25 DRSBLAS3 CLL
c
c     Demonstrate usage of
c     SASUM, SNRM2, SSCAL, SSWAP, and ISAMAX
c     from the BLAS.
c     Also uses SAXPY.
c     ------------------------------------------------------------------
c--S replaces "?": DR?BLAS3, ?AXPY, ?ASUM, ?NRM2
c--&                 ?SCAL, ?SWAP, I?AMAX
c     ------------------------------------------------------------------
      external SASUM, SNRM2, ISAMAX
      real             SASUM, SNRM2
      integer ISAMAX
      integer M3, M4, N3, N4
      parameter ( M3=10, M4=12 )
      parameter ( N3=3, N4=4 )
      integer IT1, J
      real             E(M3,M4)
      real             B(M3), C(5), C2(5), C3(5), D(5), D2(5), D3(5)
      real             T1
c
      data (B(J),J=1,N3)   /  7.0e0, -3.0e0, 5.0e0 /
      data (C(J),J=1,5)   /  7.0e0, -3.0e0,  5.0e0, -4.0e0, 1.0e0 /
      data (C2(J),J=1,5)   /  7.0e0, -3.0e0,  5.0e0, -4.0e0, 1.0e0 /
      data (C3(J),J=1,5)   /  7.0e0, -3.0e0,  5.0e0, -4.0e0, 1.0e0 /
      data (D(J),J=1,5)   / 14.0e0, -6.0e0, 10.0e0, -8.0e0, 2.0e0 /
      data (D2(J),J=1,5)   / 14.0e0, -6.0e0, 10.0e0, -8.0e0, 2.0e0 /
      data (D3(J),J=1,5)   / 14.0e0, -6.0e0, 10.0e0, -8.0e0, 2.0e0 /
 
      data (E(1,J),J=1,N4) / -4.0e0, 2.0e0,  3.0e0, -6.0e0 /
      data (E(2,J),J=1,N4) /  7.0e0, 5.0e0, -6.0e0, -3.0e0 /
      data (E(3,J),J=1,N4) /  3.0e0, 4.0e0, -2.0e0,  5.0e0 /
 
c     ---------------------------------------------------------------
c
      T1 = SASUM(N3, B, 1) - 15.0e0
      print*,'Test of SASUM(): ',T1
c
      T1 = SNRM2(5, C, 1) - 10.0e0
      print*,'Test of SNRM2(): ',T1
c
      call SSCAL(5, 2.0e0, C2, 1)
      call SAXPY(5, -1.0e0, C2, 1, D2, 1)
      T1 = SASUM(5, D2, 1)
      print*,'Test of SSCAL(): ',T1
c
      call SSWAP(5, C3, 1, D3, 1)
      call SAXPY(5, -1.0e0, C, 1, D3, 1)
      call SAXPY(5, -1.0e0, D, 1, C3, 1)
      T1 = SASUM(5, C3, 1) + SASUM(5, D3, 1)
      print*,'Test of SSWAP(): ',T1
c
      IT1 = ISAMAX(N4, E(1,1), M3) - 4
      print*,'Test of ISAMAX(): ',IT1
      stop
      end
