import os
import math

def get_word(fdata):    
  g_word = ""               # initialize 
  g0 = fdata.read(1)       # get first char

  while (g0==" " or g0=='\n'):     # skip space and '\n'
    g0 = fdata.read(1)    

  while (g0!=" " and g0!='\n'):
    if g0 == "": break      # the end of file
    g_word = g_word + g0    # creat word
    g0 = fdata.read(1)

  return g_word

eps = 1E-13

###################################################################################
    # Quan( 1) = Tworm*wv             ! tw per site  
    # Quan( 2) = Ux1                  ! unwrapped distance 1
    # Quan( 3) = Ux2                  ! unwrapped distance 2
    # Quan( 4) = Uxw                  ! unwrapped distance 3
    # Quan( 5) = en*wv                ! B   per site     (not per bond)
    # Quan( 6) = en2*wv*wv            ! B^2 per site^2   (not per bond)

    # Quan( 7) = C1*wv                ! F1   per site
    # Quan( 8) = C1_2*wv*wv           ! F1^2 per site^2  
    # Quan( 9) = C2*wv                ! F2 per site
    # Quan(10) = S2                   ! (s/V)^2
    # Quan(11) = S4                   ! (s/V)^4
    # Quan(12) = C_num*wv             ! the number of clusters except size = 1 per site
    # Quan(13) = N1                   ! the number of clusters condition on s>=L^2
    # Quan(14) = N2                   ! the number of clusters condition on s>=2L^2
    # Quan(15) = R1                   ! the radius of F1
    # Quan(16) = R2                   ! the radius of F2
    # Quan(17) = N_s_1                ! the number of spaning clusters  0   
    # Quan(18) = N_s_2                ! the number of spaning clusters -1
    # Quan(19) = N_s_3                ! the number of spaning clusters +1

    # Quan(20) = P_C1_le_2            ! the probability that F1<=L^2

    # jb = NObs_b+ 1;   call cal_sp_heat(jb,6,5)          !  (<en^2>-<en>^2)
	# jb = NObs_b+ 2;   call cal_sp_heat(jb,8,7)          !  (<C1^2>-<C1>^2)
###################################################################################
# obs_list_0 = ["Tworm","en","en^2","Ux1","Ux2","Uxw",
# "C1","C1^2","C2","C2^2","cluster_num","cluster_num^2","S2","S4",
# "P_one","P_C1","N1","N2","P_C1_to_1","P_C2_to_1","R1","R2",
# "div_en","div_C1","div_C2","div_cluster_num"]
# data_name_0 = "data_IsingSqH_0"

obs_list = ["Tworm","Ux1","Ux2","Uxw","en","en2","F1","F1_2","F2","S2","S4","C_num","N1",
             "N2", "R1","R2","N_s_1","N_s_2","N_s_3","P_C1_le_2","div_en","div_F1"]


data_name = "data_IsingSqH"

head = "IsingSqH"

###################################################################################
###################################################################################
#################################====EXTR====######################################
###################################################################################
###################################################################################

os.system("rm mean/dat.*")   # clear old dat
os.system("rm mean/str.*")   # clear old str
os.system("rm mean/cmp.*")   # clear old cmp

fdata = open(data_name,'r')   # read this data

obs_num = len(obs_list)

for i in range(obs_num):
    locals()["obs"+str(i)] = open("mean/dat."+obs_list[i],"w")   # sth need to write

while(1):
    word0 = get_word(fdata)
    if(word0==head):
# get basic values of this Markov Chain
        L = get_word(fdata)
        samp = str(format(float(get_word(fdata))*0.001,".3f"))
        nw = get_word(fdata)
        kc = get_word(fdata)
        seed = get_word(fdata)   
# get observables        
        for i in range(obs_num):
            obs_index = get_word(fdata)
            obs_quan  = get_word(fdata)
            obs_err   = get_word(fdata)
            obs_corr  = get_word(fdata)
            locals()["obs"+str(i)].write(format(L,"5")+"   "+obs_quan+"   "+obs_err+"   "+format(nw,"5")+"   "+format(kc,"12")+"   "+samp+"   "+head+"   "+format(seed,"9")+"\n")

    elif(word0==""): break     # the end of file


for i in range(obs_num):
    locals()["obs"+str(i)].close()  # sth need to close

fdata.close()


###====optional=====#########################################################################

# fdata = open(data_name_0,'r')   # read this data

# obs_num_0 = len(obs_list_0)

# for i in range(obs_num_0):
#     locals()["obs"+str(i)] = open("mean/dat."+obs_list_0[i],"a")   # sth need to append

# while(1):
#     word0 = get_word(fdata)
#     if(word0==head):
# # get basic values of this Markov Chain
#         L = get_word(fdata)
#         samp = str(format(float(get_word(fdata))*0.001,".3f"))
#         nw = get_word(fdata)
#         kc = get_word(fdata)
#         seed = get_word(fdata)   
# # get observables        
#         for i in range(obs_num_0):
#             obs_index = get_word(fdata)
#             obs_quan  = get_word(fdata)
#             obs_err   = get_word(fdata)
#             obs_corr  = get_word(fdata)
#             locals()["obs"+str(i)].write(format(L,"5")+"   "+obs_quan+"   "+obs_err+"   "+format(nw,"5")+"   "+format(kc,"12")+"   "+samp+"   "+head+"   "+format(seed,"9")+"\n")

#     elif(word0==""): break     # the end of file


# for i in range(obs_num_0):
#     locals()["obs"+str(i)].close()  # sth need to close

# fdata.close()


###################################################################################



###################################################################################
###################################################################################
#################################====SORT====######################################
###################################################################################
###################################################################################

for i in range(obs_num):
    locals()["dat"+str(i)] = open("mean/dat."+obs_list[i],"r")   # sth need to read

for i in range(obs_num):
    locals()["sort"+str(i)] = open("mean/str."+obs_list[i],"w")   # sth need to write    

# for different obs
for i in range(obs_num):
###################################################################################
# save data to lists
    L_list = {}
    quan_list = {}
    err_list = {}
    nw_list = {}
    kc_list = {}
    samp_list = {}
    head_list = {}
    seed_list = {}

    index = 0    # initial index
    while(1):
        word0 = get_word(locals()["dat"+str(i)])
        if(word0==""): break          # the end of file  
        L_list[index] = word0
        quan_list[index] = get_word(locals()["dat"+str(i)])
        err_list[index] = get_word(locals()["dat"+str(i)])
        nw_list[index] = get_word(locals()["dat"+str(i)])
        kc_list[index] = get_word(locals()["dat"+str(i)])
        samp_list[index] = get_word(locals()["dat"+str(i)])
        head_list[index] = get_word(locals()["dat"+str(i)])
        seed_list[index] = get_word(locals()["dat"+str(i)])
        index = index + 1      # next line

###################################################################################
# sort these data
    while(1):
        nin = 0  # exchange times
        for j in range(index-1):   # index just ok 
# L sort
            if(int(L_list[j])>int(L_list[j+1])):
                L_list[j],L_list[j+1] = L_list[j+1],L_list[j]
                quan_list[j],quan_list[j+1] = quan_list[j+1],quan_list[j]
                err_list[j],err_list[j+1] = err_list[j+1],err_list[j]
                nw_list[j],nw_list[j+1] = nw_list[j+1],nw_list[j]
                kc_list[j],kc_list[j+1] = kc_list[j+1],kc_list[j]
                samp_list[j],samp_list[j+1] = samp_list[j+1],samp_list[j]
                head_list[j],head_list[j+1] = head_list[j+1],head_list[j]
                seed_list[j],seed_list[j+1] = seed_list[j+1],seed_list[j]
                nin = nin + 1                             
# Kc sort                
            if(int(L_list[j])==int(L_list[j+1]) and float(kc_list[j])>float(kc_list[j+1])):
                L_list[j],L_list[j+1] = L_list[j+1],L_list[j]
                quan_list[j],quan_list[j+1] = quan_list[j+1],quan_list[j]
                err_list[j],err_list[j+1] = err_list[j+1],err_list[j]
                nw_list[j],nw_list[j+1] = nw_list[j+1],nw_list[j]
                kc_list[j],kc_list[j+1] = kc_list[j+1],kc_list[j]
                samp_list[j],samp_list[j+1] = samp_list[j+1],samp_list[j]
                head_list[j],head_list[j+1] = head_list[j+1],head_list[j]
                seed_list[j],seed_list[j+1] = seed_list[j+1],seed_list[j]
                nin = nin + 1                
        if(nin==0):break    # already done


# write sort res
    for j in range(index):   # index just ok  
        locals()["sort"+str(i)].write(format(L_list[j],"5")+"   "+quan_list[j]+"   "+err_list[j]+"   "+format(nw_list[j],"5")+"   "+format(kc_list[j],"12")+"   "+samp_list[j]+"   "+head_list[j]+"   "+format(seed_list[j],"9")+"\n")

###################################################################################

for i in range(obs_num):
    locals()["sort"+str(i)].close()  # sth need to close

for i in range(obs_num):
    locals()["dat"+str(i)].close()  # sth need to close    

###################################################################################
###################################################################################
#################################====COMP====######################################
###################################################################################
###################################################################################

for i in range(obs_num):
    locals()["sort"+str(i)] = open("mean/str."+obs_list[i],"r")   # sth need to read

for i in range(obs_num):
    locals()["comp"+str(i)] = open("mean/cmp."+obs_list[i],"w")   # sth need to write    

# for different obs
for i in range(obs_num):
###################################################################################
# save data to lists
    L_list = {}
    quan_list = {}
    err_list = {}
    nw_list = {}
    kc_list = {}
    samp_list = {}
    head_list = {}

    quan_temp = {}
    err_temp = {}

    index = 0    # initial index
    while(1):
        word0 = get_word(locals()["sort"+str(i)])
        if(word0==""): break          # the end of file  
        L_list[index] = int(word0)
        quan_list[index] = float(get_word(locals()["sort"+str(i)]))
        err_list[index] = float(get_word(locals()["sort"+str(i)]))
        nw_list[index] = float(get_word(locals()["sort"+str(i)]))
        kc_list[index] = float(get_word(locals()["sort"+str(i)]))
        samp_list[index] = float(get_word(locals()["sort"+str(i)]))
        head_list[index] = get_word(locals()["sort"+str(i)])
        get_word(locals()["sort"+str(i)])   # seed
        index = index + 1      # next line

###################################################################################
    ig = 0     # the number of final lines
    np = {}    # the number of comp for certain case
    L_ig = 0  # initial L
    kc_ig = 0.0 # initial kc

# get ig value     
    for j in range(index):   # index just ok 
        if(L_list[j]==L_ig and kc_list[j]==kc_ig):    # rule to compress !!
            np[ig-1] = np[ig-1] + 1   # count
        else:
            ig = ig + 1    # update
            np[ig-1] = 1  # index from 0 to ig-1 !!
            L_ig, kc_ig = L_list[j], kc_list[j]
# compress data
    n = -1
    for j in range(ig):
        bench = 0.0
        err_irr = 0.0
        samps = 0.0
        for k in range(np[j]):
            n = n + 1
            samps = samps + samp_list[n]
            err_ = err_list[n]
            if(abs(err_)>eps): err_ = 1.0/(err_*err_)
            err_irr = err_irr + err_
            bench = bench + err_*quan_list[n]
            quan_temp[k] = quan_list[n]
            err_temp[k] = err_list[n]
        if(abs(err_irr)>eps):
            cmp_quan = bench/err_irr
            cmp_err = 1.0/math.sqrt(err_irr)
            bench = 0
            for z in range(np[j]):
                er = (cmp_quan-quan_temp[z])/(err_temp[z]+0.000001)
                bench = bench + er*er
        else:
            cmp_quan = quan_temp[0]
            cmp_err = 0
            err_irr = 0
            bench = 0
            for z in range(np[j]):
                if(abs(cmp_quan-quan_temp[z])>eps):
                    bench = np[j]*10
        locals()["comp"+str(i)].write(format(str(L_list[n]),"5")+"   "+str(format(cmp_quan,".12f"))+"   "+str(format(cmp_err,".12f"))+"   "+format(str(int(nw_list[n])),"5")+"   "+str(format(kc_list[n],".12f"))+"   "+format(format(samps,".2f"),"5")+"   "+format(str(int(np[j]-1)),"5")+"   "+str(format(bench,".2f"))+"\n")


###################################################################################

for i in range(obs_num):
    locals()["comp"+str(i)].close()  # sth need to close

for i in range(obs_num):
    locals()["sort"+str(i)].close()  # sth need to close    

###################################################################################

for i in obs_list:
    os.system("cp mean/cmp."+i+"  ../data/basic/cmp_"+i+".txt")




