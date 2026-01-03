
  INCLUDE "Basi/my_vrbls.f90"
  !=====Main routine =================================================
  PROGRAM IsingSqHD
    use my_vrbls   
    implicit none
    integer :: itoss, isamp, iblck, iconf, L_c, i
    character(8)  :: str1, str2, str3
    character(80) :: filename
    double precision :: t_tot, f0, f2, err_temp
    character(len=80)::str0,fname1

!==============================================================
!  Ising model Kc
!  2D：0.44068679350977...
!  3D: 0.221654631(8)
!  4D：0.149693785(10) 
!  5D：0.11391498(2)  
!  6D：0.0922982(3)  
!  7D：0.0777086(8) -> 0.0777089(2)
!==============================================================

    print *, 'L, Ntoss,  Nsamp,  nw, Kcp, Seed, NBlck'
    read  *,  L, Ntoss,  Nsamp,  nw, Kcp, Seed, NBlck

    Totsamp = Nsamp*NBlck/1000
    Lx = L;         Ly = Lx;        Lm1 = L-1;              Lh   = L/2
    Vol = L**D;     wv = 1.d0/Vol;  we = wv/(nnb*0.5d0);    Lp1  = L+1

    !--- Initialization ----------------------------------------------
    call set_time_elapse
    call set_RNG
    call initialize
    call time_elapse;         t_init = t_elap;

    write(6,50) t_init;          50 format(/'        set up time:',f16.7,2x,'s')
	  flag_of_measure =.false. 

    !--- Thermialization ---------------------------------------------
    t_toss = 0.d0;   f0 = 0.d0
    DO iblck = 1, NBlck
     do isamp = 1, Ntoss
      call markov;   f0 = f0+Tworm*wv    
      enddo
    ENDDO
    f0 = f0/(Ntoss*1.d0*NBlck); 
    if(f0>1.d-4) nw = 2+Floor(0.25d0/f0)   ! set the volume step (nw)

    call time_elapse;            t_toss = t_toss+t_elap
    t_toss = t_toss/60.d0
    write(6,51) t_toss;          51 format(/'    throw-away time:',f16.7,2x,'m')
    write(6,52) nw    ;          52 format(/'          worm step:',i8) 

    !--- Simulation --------------------------------------------------
  t_simu   = 0.d0;   t_meas = 0.d0
	flag_of_measure =.true. 

   call init_His     ! initialize distribution prog 
    DO iblck = 1, NBlck
      do isamp = 1, Nsamp
        call markov;                call time_elapse;     t_simu = t_simu+t_elap
        call measure
        call coll_data(iblck);      call time_elapse;     t_meas = t_meas+t_elap
      enddo
        call norm_Nsamp(iblck);     call time_elapse;     t_simu = t_simu+t_elap
    ENDDO
    call time_elapse;              t_simu = t_simu+t_elap

    !--- Statistics --------------------------------------------------
    call stat_analy
    call write2file
    call writ_his    ! print info about distribution

    !--- print distribution of R(s,L)   

        write(str0,'(I12)') Vol
        fname1 = "R_s_V_"//trim(adjustl(str0))
        open(81,file=fname1)

        do i=1, MxHis
        	if(nsck_rac(i)==0) cycle
	        err_temp=(nsck_ra2(i)*1.d0/nsck_rac(i)-(nsck_ra(i)*1.d0/nsck_rac(i))**2.d0)/nsck_rac(i)	
	        if(err_temp<0) err_temp=0
          write(81,72) i,szHis(i),nsck_rac(i)*1.d0,nsck_ra(i)*1.d0,nsck_ra2(i)*1.d0,nsck_ra(i)*1.d0/nsck_rac(i),dsqrt(err_temp)
        enddo

        close(81)

        72 format(2x,i8,2x,i12,2x,6e20.10)


  CONTAINS

  INCLUDE "Init/initialize.f90"
  INCLUDE "Simu/markov.f90"
  INCLUDE "Meas/measure.f90"
  INCLUDE "Meas/statistics.f90"
  INCLUDE "RNG/my_rng.f90"    
  INCLUDE "RNG/my_time.f90"  
  INCLUDE "Init/def_His.f90"
END PROGRAM IsingSqHD
!=====================================================================