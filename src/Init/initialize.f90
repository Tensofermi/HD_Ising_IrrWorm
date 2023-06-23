  
  !--- PROJECT-DEPENDENT ---------------------------------------------
  !==============Initialization ======================================
  !! THIS IS PROJECT-DEPENDENT 
  SUBROUTINE initialize
    implicit none

    !xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
    call tst_and_prt
    call def_latt
    call def_conf
    call def_prob
    call def_szHis


    !xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
    !-- measurement initialization -----------------------------------
    Obs = 0.d0;   Quan = 0.d0
    Ave = 0.d0;   Dev  = 0.d0;     Cor = 0.d0


    return
  END SUBROUTINE initialize
  !===================================================================


  !==============Test and Print ======================================
  !! THIS IS PROJECT-DEPENDENT 
  SUBROUTINE tst_and_prt
    implicit none

    !-- Test and Print -----------------------------------------------
    if((NBlck>MxBlck).or.(NBlck<MnBlck)) then
      write(6,*) 'MnBlck <= NBlck <=MxBlck?';             stop
    endif

    ! if(NBlck>200) then
    !   write(6,*) '"NBlck>200" is supposed for extensive &
    !   & simulation. "NBlck=MxBlk" is suggested!';         stop
    ! endif                                                       

    if(L>MxL) then
      write(6,*) 'L<=MxL?';                               stop
    endif

    write(6,40) L, L
    40 format(' on ',2(i4,2x),'square lattice')

    write(6,41) Kcp
    41 format(' coupling:',f12.8)

    write(6,43) Nsamp*NBlck
    43 format(' Will simulate      ',i10,2x,'steps ')

    write(6,44) NBlck
    44 format(' #Blocks            ',i10)

    write(6,45) Ntoss*NBlck
    45 format(' Throw away         ',i10,2x,'steps')

    return
  END SUBROUTINE tst_and_prt
  !===================================================================

  SUBROUTINE def_latt
    implicit none
    integer(4) :: i
    integer(1) :: m, b, md, bd, mc
  
   ! L^i: power of L from 0 to D
  	Ld(0) =1 
    do i   = 1, D
    Ld(i)  = L**i   !  L(0) = 1; L(1) = L; L(2) = L^2; ... 
    enddo

   !                  -1  0  1  2       7   
   ! IDD(-1:IDF-1) = ( 1, 2, 4, 8, ..., 2^8)
   ! IDF = 8
    IDD(-1)= 1   
    do  i  = 0, IDF-1
    IDD(i) = 2**(i+1)
    enddo
    VID    = (Vol-1)/IDF

   ! Dx(D,nnb)
   ! for D = 2 :
   !   | 1        -1 |
   !   |    1  -1    |

     Dx=0
     do i=1,D
     	Dx(i,i)=1	; Dx(i,nnb+1-i)=-1
     enddo

    return
  END SUBROUTINE def_latt

  !===================================================================
  ! Periodic Boundary Condition
  ! (original site) k in [1,Vol]
  ! (direction) b in [1,nnb]
  integer(8) FUNCTION func_V2V(b,k)  ! get assigned site coordinate 
    implicit none
    integer(8), INTENT(IN) :: k
    integer(4), INTENT(IN) :: b
    integer(8) :: j, bk, xk
   
    IF(b<= D) THEN    ! (+)  1 ~ D
      bk = b;                                  j =  k+Ld(bk-1)   ! direct 
      ! boundary test 
      xk = Mod(k-1,Ld(bk));   ! ?? k=9 or 8 代表右下角
      xk = xk/Ld(bk-1)
      if(xk==Lm1)  j = j-Ld(bk)   ! PBC
    ELSE              ! (-)  D+1 ~ 2D
      bk = nnb+1-b;                            j =  k-Ld(bk-1)   ! direct
      ! boundary test
      xk = Mod(k-1,Ld(bk));                     
      xk = xk/Ld(bk-1)
      if(xk==0)    j = j+Ld(bk)
    ENDIF

    func_V2V = j
    return
  END FUNCTION func_V2V
  !===================================================================

 integer(8) FUNCTION func_V2E(b,k) ! get assigned bond coordinate 
	implicit none 
	integer(8), INTENT(IN)::k 
	integer(4), INTENT(IN)::b 
	integer(8)::j,xk,e  
	integer(8)::bk
	
	IF(b<=D) then 
		bk = b; 
    e = k + (bk-1)*Vol 
	ELSE 
	   bk = nnb +1 -b 
	   j = func_V2V(b,k)   ! get - site then - bond becomes + bond 
	   e = j +(bk-1)*Vol 
	ENDIF 
	func_V2E = e 
	return 
 END FUNCTION func_V2E 


  !==========define spin and bond configuration ======================
  !! THIS IS PROJECT-DEPENDENT 
  SUBROUTINE def_conf
    implicit none
    integer(4) :: kx, ky, k, s, e, tk

    Flow= 0; 
    Ira = 1;   Masha = 1;    
    
    lambda = 1;  Nb = 0;
	  Ull1 = 0;    Ull2 = 0;
	  measure_of_step = 0;  nul2 = 0;
    return
  END SUBROUTINE def_conf


  !==========define acceptance probability ===========================
  !! THIS IS PROJECT-DEPENDENT 
  SUBROUTINE def_prob
    implicit none
    double precision, parameter :: conv = 1.d-20
    double precision :: x, s, ds, fn, fk, fnk
    integer :: k, n
    !-- edge weight
    Xcp = dtanh(Kcp)
    write(6,50) Xcp
    50 format(' #add an edge accept with probability', f12.8)

    return
  END SUBROUTINE def_prob


  !==========define bit operation =====================================
! bit_read                          1~D*Vol
subroutine check_value(i,val) ! (original index, bond value)
	Implicit None
	integer(kind=8)::i,i_mod,i_re
	integer(kind=1)::val   
	i_mod=mod(i,8)
	i_re =(i-1)/8 + 1  ! i_re is integer, only catch the integralpart 
	if (btest(Flow(i_re),i_mod)) then
		val=1   ! occupied
	else
		val=0   ! unoccupied
	end if
	return
end subroutine check_value

! bit_write
subroutine set_value(j,val) ! (original index, bond value)
	implicit None
	integer(kind=8)::j,j_re,j_mod
	integer(kind=1)::val
	j_mod=mod(j,8)
	j_re=(j-1)/8+1
    if (val==0) then
		Flow(j_re)=ibclr(Flow(j_re),j_mod)
	else
		Flow(j_re)=ibset(Flow(j_re),j_mod)
    end if
	return
end subroutine set_value
