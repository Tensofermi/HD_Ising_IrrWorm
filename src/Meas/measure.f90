
  !==============Measurement =========================================
  !! THIS IS PROJECT-DEPENDENT 
  SUBROUTINE measure
    implicit none
    integer(4)  :: kx, ky, k, j, e, s, iq, qmn, qmx, bn1, bn2, bn3, bn5
    double precision :: s1,s1T,s1F
    

    call swendsen_wang(C1,C2,S2,S4,C_num)
    C1_2 = C1**2.d0;

    P_C1_le_2 = 0
    if(C1<=(L**2))  P_C1_le_2 = 1;
 

    Quan( :) = 0.d0
!============== Basic =================================================
    Quan( 1) = Tworm*wv             ! tw per site  
    Quan( 2) = Ux1                  ! unwrapped distance 1
    Quan( 3) = Ux2                  ! unwrapped distance 2
    Quan( 4) = Uxw                  ! unwrapped distance 3
    Quan( 5) = en*wv                ! B   per site     (not per bond)
    Quan( 6) = en2*wv*wv            ! B^2 per site^2   (not per bond)

    Quan( 7) = C1*wv                ! F1   per site
    Quan( 8) = C1_2*wv*wv           ! F1^2 per site^2  
    Quan( 9) = C2*wv                ! F2 per site
    Quan(10) = S2                   ! (s/V)^2
    Quan(11) = S4                   ! (s/V)^4
    Quan(12) = C_num*wv             ! the number of clusters except size = 1 per site
    Quan(13) = N1                   ! the number of clusters condition on s>=L^2
    Quan(14) = N2                   ! the number of clusters condition on s>=2L^2
    Quan(15) = R1                   ! the radius of F1
    Quan(16) = R2                   ! the radius of F2
    Quan(17) = N_s_1                ! the number of spaning clusters  0   
    Quan(18) = N_s_2                ! the number of spaning clusters -1
    Quan(19) = N_s_3                ! the number of spaning clusters +1

    Quan(20) = P_C1_le_2            ! the probability that F1<=L^2


!============== Distribution ============================================

   ! f(C1)
    bn1 = func_bnHis(int(C1+1.d-4))
    if(MxHis_now1 < bn1) MxHis_now1 = bn1
    if(MiHis_now1 > bn1) MiHis_now1 = bn1
    nsHis_now1(bn1) = nsHis_now1(bn1)+wv

   ! n(C,L)
    nsHis_now = nsHis_now + nsHis_tem
    if(MxHis_tem>MxHis_now) MxHis_now = MxHis_tem
    if(MiHis_tem<MiHis_now) MiHis_now = MiHis_tem
 
   ! R(s,L)
	  nsck_ra  =  nsck_ra  +  nsckt_ra  
	  nsck_rac =  nsck_rac +  nsckt_rac
	  nsck_ra2 =  nsck_ra2 +  nsckt_ra2

   ! f(Nc)
    bn5 = func_bnHis(int(C_num+1.d-4))
    if(MxHis_now5 < bn5) MxHis_now5 = bn5
    if(MiHis_now5 > bn5) MiHis_now5 = bn5
    nsHis_now5(bn5) = nsHis_now5(bn5)+wv
    
    nm_tem=int(nm_tem+1.d0)

    return
  END SUBROUTINE measure


  !==============Calculate Binder ratio 1================================
  !! Q=Ave(b2)/Ave(b1)^epo
  !! THIS IS PROJECT-DEPENDENT 
  SUBROUTINE cal_Q(jb,b1,b2,epo)
    implicit none
    integer, intent(in) :: jb, b1,b2
    double precision, intent(in) :: epo
    integer             :: k
    double precision    :: tmp

    !-- Average ----------------------------------------------------
      tmp = Ave(b1  )**epo;   if(dabs(tmp)>eps) tmp = Ave(b2  )/tmp
      Ave(jb  ) = tmp

    !-- Obs(j,k) series --------------------------------------------
    do k = 1, NBlck
      tmp = Obs(b1,k)**epo;   if(dabs(tmp)>eps) tmp = Obs(b2,k)/tmp
      Obs(jb,k) = tmp
    enddo
  END SUBROUTINE cal_Q

  !! Q=2*Ave(b1)/Ave(b2)-Ave(b3)/Ave(b4)-Ave(b5)
  !! THIS IS PROJECT-DEPENDENT 
  SUBROUTINE cal_gQP(jb,b1,b2,b3,b4,b5)
    implicit none
    integer, intent(in) :: jb, b1,b2,b3,b4,b5
    integer             :: k
    double precision    :: tmp, tmp1, tmp2

    !-- Average ----------------------------------------------------
      tmp1 = Ave(b2) 
      tmp2 = Ave(b4)   
      if(dabs(tmp1)>eps .and. dabs(tmp2)>eps)  tmp = 2*Ave(b1)/tmp1-Ave(b3)/tmp2-Ave(b5)
      Ave(jb) = tmp

    !-- Obs(j,k) series --------------------------------------------
    do k = 1, NBlck
      tmp1 = Obs(b2,k)
      tmp2=Obs(b4,k)  
      if(dabs(tmp1)>eps .and. dabs(tmp2)>eps) tmp =2*Obs(b1,k)/tmp1-Obs(b3,k)/tmp2-Obs(b5,k)
      Obs(jb,k) = tmp
    enddo
  END SUBROUTINE cal_gQP
  !==============Calculate specific-heat-like quantity ==================
  !! THIS IS PROJECT-INDEPENDENT 
  !! C = V(Ave(b2)-Ave(b1)^2)
  SUBROUTINE cal_sp_heat(jb,b2,b1)
    implicit none
    integer, intent(in) :: jb, b1, b2
    integer             :: k

    !-- Average ----------------------------------------------------
      Ave(jb) = Vol*Vol*(Ave(b2)-Ave(b1)**2.d0)

    !-- Obs(j,k) series --------------------------------------------
    do k = 1, NBlck
      Obs(jb,k) = Vol*Vol*(Obs(b2,k)-Obs(b1,k)**2.d0)
    enddo
  END SUBROUTINE cal_sp_heat


  !==============Calculate composite observables =====================
  !! THIS IS PROJECT-INDEPENDENT 
  !! call in 'stat_alan'
  SUBROUTINE cal_Obs_comp
    implicit none
    integer    :: jb
    jb = NObs_b+ 1;   call cal_sp_heat(jb,6,5)          !  (<en^2>-<en>^2)
	  jb = NObs_b+ 2;   call cal_sp_heat(jb,8,7)          !  (<C1^2>-<C1>^2)

    return
  END SUBROUTINE cal_Obs_comp
  !===================================================================
