
  !============== read histogram =====================================
  !! THIS IS PROJECT-DEPENDENT 
  SUBROUTINE read_his
    implicit none
    character(8)  :: str0, str1, str2, str3, str4, str5
    character(80) :: filename
    double precision :: hc0, hx0, hy0
    integer(4)       :: j,  j0
    logical          :: fexs

    write(str0,'(I8)') L
    filename = 'Data_His/His.L'//trim(adjustl(str0))

    !--- read his if the file exists ---------------------------------
    inquire(file=filename,exist=fexs)
    IF(.not.fexs) RETURN
    
    open(10,file=filename)
    read(10,*)
    DO j = 0, MxHis
    read(10,*) j0, hc0, hx0, hy0;      
    His_C(j) = His_C(j)+hc0
    His_X(j) = His_X(j)+hx0
    His_Y(j) = His_Y(j)+hy0
    ENDDO 

    close(10)
    return
  END SUBROUTINE read_his
  !===================================================================



  !============== write histogram ====================================
  !! THIS IS PROJECT-DEPENDENT 
  SUBROUTINE writ_his
    implicit none
    character(8)  :: str0, str1, str2, str3, str4, str5
    character(80) :: filename
    double precision :: x0, hc0, hx0, hy0, num_His, nc0, nx0, ny0
    integer(4)       :: j

    write(str0,'(I8)') L
    filename = 'Data_His/His.L'//trim(adjustl(str0))

    nc0 = His_C(0);   if(nc0>0.d0) nc0 = 1.d0/nc0
    nx0 = His_X(0);   if(nx0>0.d0) nx0 = 1.d0/nx0
    ny0 = His_Y(0);   if(ny0>0.d0) ny0 = 1.d0/ny0

    open (10,file=filename)
    write(10,*)
    do j = 0, MxHis
     hc0 = His_C(j)*nc0
     hx0 = His_X(j)*nx0
     hy0 = His_Y(j)*ny0
     write(10,'(i6,2(3ES16.6))') j, His_C(j), His_X(j), His_Y(j), hc0, hx0, hy0
    enddo
    close(10)

    return
  END SUBROUTINE writ_his
  !===================================================================


