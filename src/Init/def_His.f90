  !=======initialize histogram =======================================
  !! THIS IS PROJECT-DEPENDENT 
  SUBROUTINE init_His
    implicit none
    integer(8) :: i, s, bn, szbn
    nsHis_now (:) = 0
    nsHis_now_1 (:) = 0
    nsHis_now1(:) = 0
    nsHis_now2(:) =0
    nsHis_now3(:) =0
    nsHis_now4(:) =0
    nsHis_now5(:) =0

    MxHis_now  = 0
    MiHis_now  = Vol
    MxHis_now_1= 0
    MiHis_now_1= Vol
    MxHis_now1 = 0
    MiHis_now1 = Vol
    MxHis_now2 = 0
    MiHis_now2 = Vol
    MxHis_now3 = 0
    MiHis_now3 = Vol
    MxHis_now4 = 0
    MiHis_now4 = Vol
    MxHis_now5 = 0
    MiHis_now5 = Vol

    nsHis_tem(:) = 0  
    MxHis_tem    = 0
    MiHis_tem    = Vol

    nsHis_tem_1(:) = 0  
    MxHis_tem_1    = 0
    MiHis_tem_1    = Vol

    nm_tem  = 0
    nm1_tem = 0
    nm2_tem = 0
    return
  END SUBROUTINE init_His
  !===================================================================

  !==========define histogram ========================================
  !! THIS IS PROJECT-DEPENDENT 
  SUBROUTINE def_szHis
    implicit none
    integer(8) :: i, s, bn, szbn
    double precision :: a
    szHis= 0
    szbn = 4;   ! ben
    s = 0;
    do i = 1, MxHis
      s  = s+szbn;    szHis(i) = s
      if(Mod(i,unHis)==0) szbn = szbn*2
    enddo

    return
  END SUBROUTINE def_szHis
  !===================================================================

  !============= function sz2bn ======================================
  !! THIS IS PROJECT-DEPENDENT 
  integer(4) FUNCTION func_bnHis(S)   ! get index
    implicit none
    integer(4)       :: S
    integer(4)       :: i, bn, dbn, szbn
    func_bnHis = MxHis;    IF(S>=szHis(MxHis)) RETURN  ! overflow

    i  = unHis  ! 64
    LP_I: DO
     IF(i>=MxHis)    EXIT LP_I
     IF(S<=szHis(i)) EXIT LP_I  ! already found the boundary index 
     i = i+unHis   ! roughly scan
    ENDDO LP_I
    i    = i-unHis
    bn   = i;  
!========================
    i = i/unHis
    szbn = 2**(i+2)   ! the interval of this state
    dbn  = S-szHis(bn)  ! the diff between S and nnb block
    dbn  = 1+(dbn-1)/szbn

    func_bnHis = bn+dbn   ! output

    return
  END FUNCTION func_bnHis
  !===================================================================


  !============== Write histogram to disk==============================
  !! THIS IS PROJECT-DEPENDENT 
  SUBROUTINE writ_his
    implicit none
    character*12      :: str0, str1, str2, str3, str4, str5
    character*120    :: fnam
    integer(4)       :: s, i, bn, szbn, j, MxHs,MiHs
    double precision :: pro, nor, nmHs
    double precision :: s0,  a0,  y0, x0, wn


    write(str1,'(I12)')  Vol
    51 format(2x,i8,2x,2i12,2x,3e20.10)
    41 format(2x,i8,2x,i12,2x,3e20.10)


! Distribution of cluster s ------   now
    MxHs = MxHis_now ; MiHs=MiHis_now
    nmHs = nm_tem; nor  = 1.d0/nmHs
    fnam  = 'ns'//'_V_'//trim(adjustl(str1))
    open (10,file=fnam)
    write(10,'(i12,i12,f21.1)') vol, MxHs, nmHs
    do j= MiHs,    MxHs
      bn  = (j-1)/unHis;      szbn=2**bn
      pro = nsHis_now(j)*nor/(szbn*1.d0)
      if(j==1) a0 = pro
      s0 = szHis(j);  y0 = a0*s0**(-2.5d0)
      write(10,41)j,szHis(j),nsHis_now(j), pro,y0
    enddo


! Distribution of C1   ------   now1 
    MxHs = MxHis_now1 ; MiHs=MiHis_now1
    nmHs = nm_tem; nor  = 1.d0/nmHs
    fnam  = 'ns.C1'//'_V_'//trim(adjustl(str1))
    open (11,file=fnam)
    write(11,'(i12,i12,f21.1)') vol, MxHs, nmHs
    do j= MiHs,    MxHs
      bn  = (j-1)/unHis;      szbn=2**bn
      pro = nsHis_now1(j)*nor/(szbn*1.d0)
      if(j==1) a0 = pro
      s0 = szHis(j);  y0 = a0*s0**(-2.5d0)
      write(11,51)j,szHis(j),int(nsHis_now1(j)*vol), pro*vol
    enddo

! ! Distribution of C2    ------   now2
!     MxHs = MxHis_now2 ; MiHs=MiHis_now2
!     nmHs = nm_tem; nor  = 1.d0/nmHs
!     fnam  = 'ns.C2'//'_V_'//trim(adjustl(str1))
!     open (12,file=fnam)
!     write(12,'(i12,i12,f21.1)') vol, MxHs, nmHs
!     do j= MiHs,    MxHs
!       bn  = (j-1)/unHis;      szbn=2**bn
!       pro = nsHis_now2(j)*nor/(szbn*1.d0)
!       if(j==1) a0 = pro
!       s0 = szHis(j);  y0 = a0*s0**(-2.5d0)
!       write(12,51)j,szHis(j),int(nsHis_now2(j)*vol), pro*vol
!     enddo

! Distribution of Nb    ------   now3
    MxHs = MxHis_now3 ; MiHs=MiHis_now3
    nmHs = nm_tem; nor  = 1.d0/nmHs
    fnam  = 'ns.en'//'_V_'//trim(adjustl(str1))
    open (13,file=fnam)
    write(13,'(i12,i12,f21.1)') vol, MxHs, nmHs
    do j= MiHs,    MxHs
      bn  = (j-1)/unHis;      szbn=2**bn
      pro = nsHis_now3(j)*nor/(szbn*1.d0)
      if(j==1) a0 = pro
      s0 = szHis(j);  y0 = a0*s0**(-2.5d0)
      write(13,51)j,szHis(j),int(nsHis_now3(j)*vol), pro*vol
    enddo

! Distribution of Tworm    ------   now4
    MxHs = MxHis_now4 ; MiHs=MiHis_now4
    nmHs = nm1_tem; nor  = 1.d0/nmHs    ! nm1_tem
    fnam  = 'ns.Tworm'//'_V_'//trim(adjustl(str1))
    open (14,file=fnam)
    write(14,'(i12,i12,f21.1)') vol, MxHs, nmHs
    do j= MiHs,    MxHs
      bn  = (j-1)/unHis;      szbn=2**bn
      pro = nsHis_now4(j)*nor/(szbn*1.d0)
      if(j==1) a0 = pro
      s0 = szHis(j);  y0 = a0*s0**(-2.5d0)
      write(14,51)j,szHis(j),int(nsHis_now4(j)*vol), pro*vol
    enddo

! Distribution of Nc    ------   now5
    MxHs = MxHis_now5 ; MiHs=MiHis_now5
    nmHs = nm_tem; nor  = 1.d0/nmHs    ! nm1_tem
    fnam  = 'ns.Nc'//'_V_'//trim(adjustl(str1))
    open (15,file=fnam)
    write(15,'(i12,i12,f21.1)') vol, MxHs, nmHs
    do j= MiHs,    MxHs
      bn  = (j-1)/unHis;      szbn=2**bn
      pro = nsHis_now5(j)*nor/(szbn*1.d0)
      if(j==1) a0 = pro
      s0 = szHis(j);  y0 = a0*s0**(-2.5d0)
      write(15,51)j,szHis(j),int(nsHis_now5(j)*vol), pro*vol
    enddo


    return
  END SUBROUTINE writ_his
  !===================================================================

