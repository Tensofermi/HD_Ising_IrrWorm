
  !============== write auxilliary information =======================
  !! THIS IS PROJECT-DEPENDENT 
  SUBROUTINE writ_auxi  
    implicit none
    character(8)  :: str1, str2, str3, str4, str5
    character(80) :: filename
    double precision :: L0, x0, x1
    integer(4)       :: j

    if(num_mv <1.d0)    num_mv = 1.d0
    ave_dx =     ave_dx/num_mv
    num_pl =     num_pl/num_mv
    write(6,50) ave_dx, num_pl, num_mv
    50 format(/'     ave. event disp.:',ES14.4,2x,'lift_part. prob.:',ES14.4,2x,'#MC:',ES12.2)

    if(num_cmv<1.d0)     num_cmv = 1.d0
    ave_cdx =    ave_cdx/num_cmv
    num_acmv=   num_acmv/num_cmv
    write(6,51) ave_cdx, num_acmv, num_cmv
    51 format(/'     ave. chain disp.:',ES14.4,2x,'chain_move prob.:',ES14.4,2x,'#MC:',ES12.2)

    if(mcu_num<1.d0)    mcu_num = 1.d0
    mcu_dx  =    mcu_dx/mcu_num
    mcu_acc =   mcu_acc/mcu_num
    write(6,52) mcu_dx, mcu_acc, mcu_num
    52 format(/'     ave. met_u disp.:',ES14.4,2x,'metro_unif prob.:',ES14.4,2x,'#MC:',ES12.2)

    return
  END SUBROUTINE writ_auxi 
  !===================================================================


