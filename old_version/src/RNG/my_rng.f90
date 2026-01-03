
  !===============Shift register random number generator =============
  !  very long period sequential version
  !! THIS IS PROJECT-INDEPENDENT 
  SUBROUTINE set_RNG
    implicit none
    integer(4) :: i_r,k_r,k1_r
    integer(4) :: iseed

    nrannr = mxrn
    nrannr_gauss = 2
    iseed  = iabs(Seed)+1
    k_r    = 3**18+2*iseed
    k1_r   = 1313131*iseed
    k1_r   = k1_r-(k1_r/mod2)*mod2

    do i_r = 1, len1
      k_r  = k_r *mult
      k1_r = k1_r*mul2
      k1_r = k1_r-(k1_r/mod2)*mod2
      ir1(i_r) = k_r+k1_r*8193
    enddo

    do i_r = 1, len2
      k_r  = k_r *mult
      k1_r = k1_r*mul2
      k1_r = k1_r-(k1_r/mod2)*mod2
      ir2(i_r) = k_r+k1_r*4099
    enddo

    do i_r = 1, len1
      inxt1(i_r) = i_r+1
    enddo
    inxt1(len1) = 1
    ipnt1 = 1
    ipnf1 = ifd1+1

    do i_r = 1, len2
      inxt2(i_r) = i_r+1
    enddo
    inxt2(len2) = 1
    ipnt2 = 1
    ipnf2 = ifd2 + 1
    return
  END SUBROUTINE set_RNG 
  !===================================================================



  !===============Calculate next random number =======================
  !! THIS IS ALMOST PROJECT-INDEPENDENT 
    double precision function rn()
    !  integer function rn()
    implicit none
    integer(4)  :: i_r, l_r, k_r
    nrannr = nrannr +1
    if(nrannr>=mxrn) then
      nrannr = 1
      do i_r= 1, mxrn
        l_r = ieor(ir1(ipnt1),ir1(ipnf1))
        k_r = ieor(ir2(ipnt2),ir2(ipnf2))
        irn(i_r) = ieor(k_r,l_r)
        ir1(ipnt1)=l_r
        ipnt1 = inxt1(ipnt1)
        ipnf1 = inxt1(ipnf1)
        ir2(ipnt2) = k_r
        ipnt2 = inxt2(ipnt2)
        ipnf2 = inxt2(ipnf2)
      enddo
    endif 
    !  rn = irn(nrannr)
      rn = irn(nrannr)*tm32+0.5d0
  end function rn
  !===================================================================



  !===============next gaussian random number ========================
  !! THIS IS ALMOST PROJECT-INDEPENDENT 
    double precision function rn_gauss(ave_x,dev_x)
    implicit none
    double precision, INTENT(IN) :: ave_x,dev_x
    nrannr_gauss = 3-nrannr_gauss
    if(nrannr_gauss==1)  call cal_gauss_rand_polar
    rn_gauss = random_gauss(nrannr_gauss)
    rn_gauss = rn_gauss*dev_x+ave_x

  end function rn_gauss
  !===================================================================



  !===============calculate Guassian-distri random number ============
  ! Polar form of Box-Muller method
  SUBROUTINE cal_gauss_rand_polar
    implicit none
    double precision  :: x1, x2, s
    LP_REJ: DO
      x1 = rn()*2.d0-1.d0
      x2 = rn()*2.d0-1.d0
      s  = x1*x1+x2*x2
      IF(s>0.d0.and.s<1.d0) EXIT LP_REJ
    ENDDO LP_REJ
    s = dsqrt((-2.d0*log(s))/s);
    random_gauss(1) = x1 * s;
    random_gauss(2) = x2 * s;

    return
  END SUBROUTINE cal_gauss_rand_polar
  !===================================================================
