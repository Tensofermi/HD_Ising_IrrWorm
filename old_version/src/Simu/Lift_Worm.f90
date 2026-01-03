! This program aims for simulte the Ising model with worm algortihm in high-d toru. 

  !===========  worm algorithm ==========================================
  SUBROUTINE lift_worm(Tw1)
    implicit none
    double precision :: Tw1
	  integer(8)  :: k, e
	  integer(4)  :: Nbv_k
    integer(4)  :: b,  ti, nk, ik, bk, bi, ib, ke, kb, bn3
    integer(1)  :: val_bond

    Tw1 = 0.d0 ;   ! initialize  tw 
    Ira = 1+Floor(rn()*Vol);     Masha  = Ira   ! initialize  Ira and Masha

	  Ull1 = 0   ! reset
	  if(nul2 >=8)  then
    Ull2 = 0   ! reset 
    nul2 = 0   ! clear 
    endif

    LP_WORM: DO 
    
        if(rn()<0.5d0) then   ! exchange Ira and Masha randomly
        k = Ira;               Ira = Masha;   Masha = k
        endif

        measure_of_step = measure_of_step + 1   ! count the step
        Tw1 = Tw1+1.d0   ! tw ++

        k = Ira     ! record Ira
        Nbv_k= 0    ! record vertex degree

       ! get vertex degree
        do b = 1,nnb 
            e = func_V2E(b,k) 
            call check_value(e, val_bond)
      	 	if(val_bond==1) Nbv_k = Nbv_k + 1   
        enddo  

       ! update config
        if (lambda == 1 .and. Nbv_k< nnb) THEN   ! + mode
        	call increase_bond(k,Nbv_k) 
        elseif(Nbv_k /=0 .and. lambda==-1) then  ! - mode
       		call delete_bond(k,Nbv_k) 
        else 
		   	lambda = -lambda   ! switch mode
        endif

  if (flag_of_measure .and. measure_of_step .ge. 4*L) then 
				Ux1 = Ux1 + dot_product(Ull1,Ull1)**0.5d0    ! sum unwrapped distance 1
				Ux2 = Ux2 + dot_product(Ull2,Ull2)**0.5d0    ! sum unwrapped distance 2
				measure_of_step = 0         ! clear steps
				Nmeu = Nmeu + 1.d0          ! count how many times we measure Ux1 and Ux2
	endif 

	If(Ira==Masha)  EXIT LP_WORM     ! back to Z space
	ENDDO LP_WORM 

	if(flag_of_measure) then 
		nul2 = nul2 + 1      !  how many times back to Z space
    Uxw = Uxw + dot_product(Ull1,Ull1)**0.5d0   ! sum unwrapped distance 3
		en = en + Nb ; en2 = en2 + Nb**2    ! measure B and B^2

    bn3 = func_bnHis(int(Nb+1.d-4))   ! distribution of B
    if(MxHis_now3 < bn3) MxHis_now3 = bn3
    if(MiHis_now3 > bn3) MiHis_now3 = bn3
    nsHis_now3(bn3) = nsHis_now3(bn3)+wv

	endif 

	 return 
  END SUBROUTINE lift_worm 
 
!======================================================================

Subroutine increase_bond(k,Nbv_k) ! Ira, how many bonds have been occupied
	Implicit None 
	integer(4)::Nbv_k, Nbv_j, kb, ke, b, bk
	integer(8)::k, j, e 
  integer(1)  :: val_bond
  double precision ::pbs_a, pbs_p, Acp

    kb = Floor((nnb-Nbv_k)*rn()) + 1   ! random choose a bond we can increase
    ke = 0

    do b = 1,nnb   ! search nnb for the chosen bond to bk
		e = func_V2E(b,k) 
    call check_value(e,val_bond)
		if(val_bond==0)  ke = ke + 1 
    if(ke == kb) then
        bk = b; exit
    endif
    enddo  

	  j = func_V2V(bk,k) 
  	Nbv_j = 0
  	do b=1,nnb 
		e = func_V2E(b,j) 
    call check_value(e,val_bond)
		if(val_bond==1) Nbv_j = Nbv_j + 1  ! how many bonds have been occupied in next site
  	enddo 
  
   ! compute acceptance probabilities Acp
	  e= func_V2E(bk,k) 
    if(Ira == Masha .Or. k == Masha ) then !--C_0state
        pbs_p = 1.d0/(nnb - Nbv_k) + 1.d0/(nnb - Nbv_j)     ! pre-
        pbs_a = 1.d0/(Nbv_k+1)+1.d0/(Nbv_j+1)               ! after
        Acp = Xcp * pbs_a / pbs_p
    else  
        Acp = Xcp * (nnb - Nbv_k)*1.d0 / (Nbv_j+1) 
    endif

    if (rn( )<Acp) then 
        val_bond = 1;
        call set_value(e,val_bond)
        Ira = j      ! Ira moves and occupy this bond
	    	Nb = Nb + 1             ! bond number ++
		if(flag_of_measure) then 
			Ull1 = Ull1  + Dx(:,bk)   ! unwrapped distance vector 1
			Ull2 = Ull2  + Dx(:,bk)   ! unwrapped distance vector 2
		endif 
    else 
        lambda = -1
    endif
	return 
END Subroutine increase_bond	
	

Subroutine delete_bond(k,Nbv_k) ! Ira, how many bonds have been occupied
		Implicit None 
        integer(4)::Nbv_k, Nbv_j, kb, ke, b, bk
        integer(8)::k, j, e 
        integer(1)  :: val_bond
        double precision ::pbs_a, pbs_p, Acp
	
        kb = Floor(Nbv_k*rn()) + 1   ! random choose a bond we can delete
        ke = 0

      do b = 1,nnb    ! search nnb for the chosen bond to bk
			e = func_V2E(b,k) 
      call check_value(e,val_bond)
			if(val_bond==1) ke = ke + 1 
            if(ke == kb) then
                bk= b; exit 
            endif
        enddo 

		j = func_V2V(bk,k) 
		Nbv_j = 0 
		do b = 1,nnb 
			e = func_V2E(b,j) 
     call check_value(e,val_bond)
			if(val_bond==1) Nbv_j = Nbv_j+1 
		enddo 
    
		e  = func_V2E(bk,k); 
        if(Ira == Masha .or. k == Masha ) then 
            pbs_p = 1.d0/Nbv_k+1.d0/NBv_j
            pbs_a = 1.d0/(nnb - Nbv_k+1)+1.d0/(nnb-NBv_j+1)
            Acp =  (1.d0 / Xcp )* pbs_a / pbs_p
        else
            Acp = (1.d0 / Xcp )*Nbv_k/(nnb - NBv_j+1.d0)
        endif

        if (rn() < Acp) then 
        
        val_bond = 0;
        call set_value(e,val_bond)
        Ira = j
			  Nb = Nb - 1   ! bond number --
			if(flag_of_measure) then 
				Ull1 = Ull1 + Dx(:,bk)   ! unwrapped distance vector 1
				Ull2 = Ull2 + Dx(:,bk)   ! unwrapped distance vector 2
			endif 
        else
            lambda = 1
        endif  
		
		return 
END Subroutine delete_bond

