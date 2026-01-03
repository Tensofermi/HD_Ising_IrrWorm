  !=============Swendsen-Wang algorithm ==============================
  !! THIS IS PROJECT-DEPENDENT
  SUBROUTINE swendsen_wang(Co1,Co2,So2,So4,cluster_num)
    implicit none
    double precision    :: Co1, Co2, So2, So4, ckd, cluster_num
    integer(4) :: ii, j, ck, b, bn
    integer(8) :: k, e, i1
    integer(4) :: dg, sh, tp0, tp1
    integer(4), dimension(MxV)     :: ID
    integer(1)  :: val_bond
    double precision:: Ra
    integer(8),dimension(D):: xk,x1,x0,xj,xs
    integer(8),dimension(D):: radios1,radios2

    !----- initialize ------------------------------------------------
    ID(1:Vol) = 0;   
    Co1 = 0;   Co2 = 0;   So2 = 0;   So4 = 0;   cluster_num = 0;   ! basic cluster obs
    N1 = 0;   N2 = 0;    ! catch log behavior
    nsckt_ra = 0;  nsckt_rac = 0;  nsckt_ra2 = 0;    ! distribution of radii  
    R1 = 0; R2 = 0;     ! radii
    N_s_1 = 0; N_s_2 = 0; N_s_3 = 0;

    !----- grow cluster ----------------------------------------------
    ii = 0;  
    nsHis_tem = 0; MxHis_tem =0; MiHis_tem = Vol    ! distribution of clusters

    LP_LAT: DO
      ii = ii+1
      if(ii>Vol)    exit  LP_LAT     ! overflow 
      if(ID(ii)> 0) cycle LP_LAT     ! already visited
        cluster_num = cluster_num + 1;   ! count number of clusters
        ID(ii) = 1;   ! label the site already visited
        ck = 1;       ! initialize the size of the cluster
        ijst(1) = ii  ! original point and construct queue : front + rear 
        x1 = 0; x0 = 0; ! clear two endpoints     
        Tx(:,1) = 0;    ! initialize Tx
        dg = 1;       tp0 = 1;       tp1 = 0

        Ra = 0 ; radios1 = 0 ; radios2 = 0    ! radius of gyration parameters initialization

        LP_GROW: DO

          lp_sh: do  sh = dg, tp0, dg   ! dg = -1 or +1 donotes direction for "rear";  tp0 is final index for "rear" in this cycle
          k = ijst(sh);   ! read vertex coordinate   
          xk= Tx(:,sh)    ! set xk original point

          lp_b: do b = 1, nnb
          e = func_V2E(b,k);             ! get corresponding edge
          call check_value(e, val_bond)  ! get the bond state
           if(val_bond==0)  cycle lp_b   ! jump to next nnb

            j  = func_V2V(b,k)    ! get the occupied nbb site

            if(ID(j)==0) then     !  whether visited ? 
              tp1 = tp1-dg;       ! "front" adds new site
              ijst(tp1) = j;      !  save this site

              xj = xk+Dx(:,b);    !  set xj
              Tx(:,tp1) = xj      !  set Tx

          ! update x1 and x0
				    do i1=1,D
				      if(x1(i1)<xj(i1)) x1(i1) = xj(i1);  if(x0(i1)>xj(i1)) x0(i1)=xj(i1)
				    enddo

              ck  = ck+1;        !  cluster size ++
              radios1=radios1+Tx(:,tp1)       ! Tx
      		    radios2=radios2+Tx(:,tp1)**2    ! Tx^2
              ID(j) = 1          !  set this site visited
            endif
          enddo lp_b

          enddo lp_sh

          if(tp1==0) exit LP_GROW

          ! exchange "front" and "rear" 
          dg = -dg;      ! change direction for "rear"
          tp0 = tp1;    ! set final index for "rear"
          tp1 = 0       ! set starting point for "front"
        ENDDO LP_GROW

!===================================================================================
!===================================================================================
!===================================================================================
      do i=1,D
          Ra = Ra + radios2(i)/(ck*1.d0)-(radios1(i)/(ck*1.d0))**2.d0
      enddo
        Ra = sqrt(Ra)  ! calculate radius of gyration

        ! ! R(s,L)     
        bn=func_bnHis(ck)   ! one cluster corresponds to one radius.
        nsckt_ra (bn) = nsckt_ra(bn)+Ra	
        nsckt_rac(bn) = nsckt_rac(bn)+1	
        nsckt_ra2(bn) = nsckt_ra2(bn)+Ra**2	

        ! Ns
        xs = x1-x0;
        if(xs(1)>= L  )   N_s_1 = N_s_1 + 1
        if(xs(1)>= Lm1)   N_s_2 = N_s_2 + 1
        if(xs(1)>= Lp1)   N_s_3 = N_s_3 + 1

        ! ! n(s,L)
        if(flag_of_measure) then 
        bn = func_bnHis(ck)     ! size distribution of clusters
        if(MxHis_tem <bn)  MxHis_tem = bn
        if(MiHis_tem >bn)  MiHis_tem = bn
        nsHis_tem(bn) = nsHis_tem(bn) + wv
        endif
        
        ! N1 & N2
        if((ck.ge.L*L)) N1 = N1 + 1;
        if((ck.ge.2*L*L)) N2 = N2 + 1;  

        ! cluster number except size = 1 
        if(ck==1) then 
        cluster_num = cluster_num - 1; ! ignore size = 1 for loop clusters
        endif

        ! C1 and C2
        ckd = ck *1.d0
        if(Co1<ckd)  then  
        Co2 = Co1;    ! update C2
        R2  = R1;     ! update R2
        Co1 = ckd;    ! update C1
        R1  = Ra;     ! update R1
        elseif (ckd>Co2) then
          Co2 = ckd;  ! update C2
          R2  = Ra;   ! update R2
        endif

        So2 = So2+(ck*wv)**2.d0  ! obtain S2
        So4 = So4+(ck*wv)**4.d0  ! obtain S4

    ENDDO LP_LAT

    return
  END SUBROUTINE swendsen_wang

  !===================================================================

