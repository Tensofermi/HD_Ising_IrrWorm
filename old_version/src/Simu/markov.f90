
  !! THIS IS PROJECT-DEPENDENT
  SUBROUTINE markov
  implicit none
  integer(4) :: iw, bn4
  double precision :: t0
    Tworm = 0.d0
	  t0 = 0.d0  
    Nmeu = 0.d0 
    Ux1 = 0.d0 
    Ux2 = 0.d0 
    Uxw = 0.d0 
    en = 0.d0 
    en2 = 0.d0   
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

  ! update loop configuration and measure tw

    DO iw = 1, nw     ! a volume step

    call lift_worm(t0)   ! update loop config
    
    Tworm = Tworm +t0

	  if(flag_of_measure) then 
      bn4 = func_bnHis(int(t0+1.d-4))     ! distribution of tw
      if(MxHis_now4 < bn4) MxHis_now4 = bn4
      if(MiHis_now4 > bn4) MiHis_now4 = bn4
      nsHis_now4(bn4) = nsHis_now4(bn4)+wv
      nm1_tem=int(nm1_tem+1.d0)
    endif
    
    ENDDO

    Tworm = Tworm /(nw*1.d0)     ! prepare to submit to the sample list 

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!       

  ! measure other observables

		Uxw = Uxw/(nw*1.d0)      ! unwrapped distance 3
		en  = en/(nw*1.d0)       ! bond number B
    en2 = en2/(nw*1.d0)      ! B^2

		if(Nmeu > 0) then 
			Ux1 = Ux1/Nmeu      ! unwrapped distance 1
      Ux2 = Ux2/Nmeu      ! unwrapped distance 2
		endif

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    return
  END SUBROUTINE markov

  include "Simu/Lift_Worm.f90"
  include "Simu/Swendsen_Wang.f90"
