  MODULE my_time_module
    IMPLICIT NONE
    !-- time-checking variables --------------------------------------
    ! THIS IS PROJECT-INDEPENDENT 
    character( 8)         :: date
    character(10)         :: time
    character(5 )         :: zone
    integer, dimension(8) :: tval
    double precision      :: t_prev, t_curr, t_elap
    integer               :: h_prev, h_curr
    double precision      :: t_init, t_simu, t_meas, t_toss
    !-----------------------------------------------------------------

  END MODULE my_time_module
  !===================================================================
