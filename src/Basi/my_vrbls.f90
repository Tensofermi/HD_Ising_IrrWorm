
  !*******************************************************************
  ! Ising model on the square lattice
  ! within the flow representation on the dual lattice

  ! Error bars are calculated using the blocking technique. 
  ! Let ' \chi^2 = \sum_{t=1}^{T} <(O_t -<O>)^2> ' be the squared chi for
  ! 'T' blocks of observable 'O'. Assuming each block of data is independent
  ! of each other, the error bar of 'O' is given by 'Dev = \sqrt{\chi^2/T(T-1)}.

  ! Reliabity of the obtained errors is monitored by t=1 correlation,
  ! for which tolerance is set by variable 'tol' (default: tol=0.20d0).

  ! Composite quantities like Binder ratios are calculated in each block, and
  ! the associated error bars are obtained from their fluctuations.

  ! Results are written into a special file 'dat.***' if the number of
  ! blocks is less than 125 or correlation is too big. Data in each 
  ! block will be also printed out in this case.

  ! Default number of extensive simulation is 'NBlck=1024'.

  ! For test purpose, for which huge amount of information will be 
  ! printed out, 'NBlck' should be set smaller but >2.

  ! Dynamical behavior is not studied.

  ! 'my_vrbls.f90', 'carlo.f90', 'monte.f90', 'measure.f90', 
  ! 'write2file.f90' and etc need to be modified for new projects.

  !  Look for 'PROJECT-DEPENDENT'.

  !  Author: Youjin Deng
  !  Date  : November 19th, 2015.
  !*******************************************************************

  ! Look for 'PROJECT-DEPENDENT' for different projects
  !============== variable module ====================================
  ! This version works only for J=K
  MODULE my_vrbls
    IMPLICIT NONE

    !-----------------------------------------------------------------
    !-------------------------INDEPENDENT-----------------------------
    !-----------------------------------------------------------------

    !-- System parameters and variables ------------------------------
    ! THIS IS ALMOST PROJECT-INDEPENDENT 
    double precision, parameter :: pi     = 3.14159265358979323846d0
    double precision, parameter :: pi2    = pi*2.d0
    double precision, parameter :: tm32   = 1.d0/(2.d0**32)
    double precision, parameter :: eps    = 1.d-15         ! very small number
    double precision, parameter :: tol    = 0.20d0         ! tolerance for Cor
    logical                     :: prt                     ! flag for write2file
    integer(4),       parameter :: Mxint  = 2147483647     ! maximum integer
    integer(4),       parameter :: Mnint  =-2147483647     ! minimum integer

    integer,          parameter :: MxBlck = 2**10          ! maximum number of blocks for statistics
    integer,          parameter :: MnBlck = 2              ! minimum number of blocks

    integer            :: NBlck                            ! # blocks
    integer            :: Nsamp                            ! # samples in unit 'NBlck'
    integer            :: Totsamp
    integer            :: Ntoss                            ! # samples to be thrown away

    double precision   :: rmub,radb                        ! auxillary variables to draw a random edge
    double precision   :: rmuv,radv                        ! auxillary variables to draw a random vertex

    character( 9) :: ident     = 'IsingSqHD'               ! identifier
    character(13) :: datafile  = 'data_IsingSqHD.dat'      ! datafile
    character(11) :: datafile1 = 'dat.big_cor'             ! datafile for big correlation
    !-----------------------------------------------------------------

    !-- Random-number generator---------------------------------------
    ! THIS IS PROJECT-INDEPENDENT 
    integer, parameter           :: mult=32781
    integer, parameter           :: mod2=2796203, mul2=125
    integer, parameter           :: len1=9689,    ifd1=471
    integer, parameter           :: len2=127,     ifd2=30
    integer, dimension(1:len1)   :: inxt1
    integer, dimension(1:len2)   :: inxt2
    integer, dimension(1:len1)   :: ir1
    integer, dimension(1:len2)   :: ir2
    integer                      :: ipnt1, ipnf1
    integer                      :: ipnt2, ipnf2
    integer, parameter           :: mxrn = 10000
    integer, dimension(1:mxrn)   :: irn(mxrn)

    integer                      :: Seed                    ! random-number seed
    integer                      :: nrannr                  ! random-number counter

    integer                      :: nrannr_gauss
    double precision             :: random_gauss(2)
    !-----------------------------------------------------------------

    !-- time-checking variables --------------------------------------
    ! THIS IS PROJECT-INDEPENDENT 
    character( 8)         :: date
    character(10)         :: time
    character(5)          :: zone
    integer, dimension(8) :: tval
    double precision      :: t_prev, t_curr, t_elap
    integer               :: h_prev, h_curr
    double precision      :: t_init, t_simu, t_meas, t_toss
    !-----------------------------------------------------------------

    !-----------------------------------------------------------------
    !---------------------------DEPENDENT-----------------------------
    !-----------------------------------------------------------------

    !-- Lattice and Model parameters Ave, Dev, Cor
    !! THIS IS PROJECT-DEPENDENT 
    integer, parameter :: D    = 5                          ! dimensionality-----------------()
    integer(4), parameter :: nnb  = 2*D                     ! neighboring vertices 
    integer            :: L, Lm1, Lp1, Lx, Ly, Lh, Vol      ! (L, L-1, L+1, L, L, L/2, L^D)
    double precision   :: wv, we, Kcp                       ! 1/Vol, 1/E, coupling strength
    integer            :: nw                                ! cycle number in per sample
    double precision   :: Xcp                               ! Tanh(Kcp)

    integer(8), parameter :: MxL  = 32                      ! maximum linear size-------------()
    integer(8), parameter :: MxV  = MxL**D                  ! maximum volumn
    integer(8), parameter :: MxE  = MxV*D                   ! maximum edges 

    integer(1), dimension(MxE/8+1) :: Flow                  ! flow or FK bond on edge 
    integer(8) :: Ira, Masha                                ! location of Ira/Masha
    double precision :: Tworm                               ! Tworm


    !----- Algorithm parameters --------------------------------------- 
    integer(1) :: lambda                                    ! state of adding or deleting bond

    integer, parameter :: MxIJ = MxV/8
    integer(4), dimension(-MxIJ:MxIJ) :: ijst               ! cluster in Wolff/SW simulation
    integer(2), dimension(D,-MxIJ:MxIJ) :: Tx   
    integer(4)  :: rank
  	integer(4),dimension(D)  :: Ull1, Ull2
  	integer(4)	:: nul2 
  	integer(8)  :: Nb
  	double precision :: Ux1, Ux2,Uxw, en, en2 
  	double precision :: Nmeu
  	integer(4)	::measure_of_step 
  	logical 	::flag_of_measure
    !-----------------------------------------------------------------

  	integer(4),parameter	 				    :: IDF=8 
  	integer(4),dimension(D,nnb) 			:: Dx
  	integer(8)			  					      :: VID 
  	integer(1),dimension(-1:IDF-1)		:: IDD 
  	integer(4),dimension(0:D)			  	:: LD

    !-- Observables --------------------------------------------------
    integer, parameter  :: NObs_b = 20                      ! #basic     observables
    integer, parameter  :: NObs_c = 2                       ! #composite observables
    integer, parameter  :: NObs = NObs_b+NObs_c             ! #total     observables

    double precision    :: C1, C2, C1_2, C2_2, S2, S4, C_num, C1T,S2T,S4T,C1F,S2F,S4F, P_one
    double precision    :: P_C1, N1, N2, P_C1_to_1, P_C2_to_1, R1, R2, N_s_1, N_s_2, N_s_3
    double precision    :: P_C1_le_7_3, P_C1_le_2, P_C1_l_7_3, P_C1_l_2
    integer             :: R, RT, RF
    integer(4)          :: Nf0 ,Nf1 ,Nf2 ,Nb1, Nb2

    ! Quan.  1 -4  (elementary quantities)
    !   1.  M2      2. M4           3. e      4. e2   

    ! Quan.  5 -6  (composite quantities)
    !   5.  Qm      6. C 
    !-----------------------------------------------------------------

    !-- Statistics ---------------------------------------------------
    ! THIS IS PROJECT-DEPENDENT 
    double precision, dimension(NObs_b)      :: Quan            ! Measured quantities
    double precision, dimension(NObs,MxBlck) :: Obs             ! 1st--#quan.  2nd--#block
    double precision, dimension(NObs)        :: Ave, Dev, Cor   ! average, error bars, and correlation of observables
  

    !-----------------------------------------------------------------
    !-- Histogram ----------------------------------------------------
    !! THIS IS PROJECT-DEPENDENT 
    integer(4), parameter :: MxHis  = 1920
    integer(4), parameter :: unHis  = 64
    integer(8)            :: szHis(0:MxHis)
    double precision      :: nsHis_now(MxHis),nsHis_now_1(MxHis),nsHis_now1(MxHis),nsHis_now2(MxHis),nsHis_now3(MxHis)
    double precision      :: nsHis_now4(MxHis),nsHis_now5(MxHis),nsHis_tem(MxHis),nsHis_tem_1(MxHis)
    integer(4)     ::  MxHis_now, MiHis_now, MxHis_now1,MiHis_now1,MxHis_now2,MiHis_now2,MxHis_now3,MiHis_now3,MxHis_tem, MiHis_tem
    integer(4)     ::  MxHis_now_1, MiHis_now_1,MxHis_now4,MiHis_now4,MxHis_now5,MiHis_now5,MxHis_tem_1, MiHis_tem_1
    integer(4)		        :: nm1_tem,nm2_tem,nm_tem
    real(8),dimension(MxHis):: nsckt_ra, nsckt_rac, nsckt_ra2, nsck_ra, nsck_rac, nsck_ra2
     !  integer(4), parameter :: nmBin = 100 
     !  double precision      :: Mxm, szm
     !  double precision      :: mHis_now(nmBin), mHis_old(nmBin)
     !  double precision      :: nmHis_mo


!   !-- Histogram  ---------------------------------------------------
!   ! THIS IS PROJECT-DEPENDENT 
!   double precision, dimension(0:MxL-1) :: His_C
!   double precision, dimension(0:MxL-1) :: His_X, His_Y
!   double precision, dimension(0:MxL-1) :: His_F
!   double precision :: num_HisF


  END MODULE my_vrbls
  !===================================================================
