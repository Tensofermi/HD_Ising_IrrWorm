import os
import shutil

def get_word(f_read):    
  g_word = ""               # initialize 
  g0 = f_read.read(1)       # get first char

  while (g0==" " or g0=='\n'):     # skip space and '\n'
    g0 = f_read.read(1)    

  while (g0!=" " and g0!='\n'):
    if g0 == "": break      # the end of file
    g_word = g_word + g0    # creat word
    g0 = f_read.read(1)

  return g_word

def get_szHis(index_szHis):
  szbn = 4
  s = 0
  for i in range(index_szHis):
    s = s + szbn
    if(((i+1)%64)==0): szbn = szbn*2
  return s

###################################################################################
sub = "qsub"     # type of sub
work_name = "2D_test"
Njob = 40        # chain number
L = [4,6,8,10,14,20,32]         # size list
d = 2
obs = "C1"  # C1, C2, N_b, Tworm
###################################################################################
os.chdir("../" + sub + "/" + work_name)

# loop different sizes 
for j in range(len(L)):

    data_temp = [0]*2000  # initialize data of this size
    Nsample_Block = 0 # initialize sample number of this size
    Mx_mx = 0  # initialize Max index of this size

    d_name = "ns." + obs + "_V_"
    d_name = d_name + str(int(L[j]**d))

    # loop dir_job
    for i in range(Njob):
        f_name = "dir_job_"
        f_name = f_name + str(i+1)
        os.chdir(f_name)
        f_r = open(d_name,'r')
        # start catching
        Vol = int(get_word(f_r))  # get Vol
        Mx = int(get_word(f_r))   # get ending index
        Block_Sample = float(get_word(f_r))  # get sample number

        Nsample_Block = Nsample_Block + Block_Sample  # update sample number
        if(Mx_mx<Mx): Mx_mx = Mx
        
        index_szHis = -1
        while(index_szHis!=Mx):  # set loop condition
            index_szHis = int(get_word(f_r))
            szHis = int(get_word(f_r))
            ns_Vol = int(get_word(f_r))
            f_data_str = get_word(f_r)
            # accumulate data from different chains
            data_temp[index_szHis] = data_temp[index_szHis] + ns_Vol

        f_r.close
        os.chdir("..")  # exit this dir_job

###====optional=====#########################################################################
# # loop others
#     os.chdir("../qsub_2")
#     for i in range(6):
#         f_name = "dir_job_"
#         f_name = f_name + str(i+1)
#         os.chdir(f_name)
#         f_r = open(d_name,'r')
#         # start catching
#         Vol = int(get_word(f_r))  # get Vol
#         Mx = int(get_word(f_r))   # get ending index
#         Block_Sample = float(get_word(f_r))  # get sample number

#         Nsample_Block = Nsample_Block + Block_Sample  # update sample number
#         if(Mx_mx<Mx): Mx_mx = Mx
        
#         index_szHis = -1
#         while(index_szHis!=Mx):  # set loop condition
#             index_szHis = int(get_word(f_r))
#             szHis = int(get_word(f_r))
#             ns_Vol = int(get_word(f_r))
#             f_data_str = get_word(f_r)
#             # accumulate data from different chains
#             data_temp[index_szHis] = data_temp[index_szHis] + ns_Vol

#         f_r.close
#         os.chdir("..")  # exit this dir_job
#     os.chdir("../qsub_1")
###################################################################################

    # start writing
    f_w = open(d_name,'w')
    f_w.write("     " + str(int(L[j]**4)) + "     " + str(Mx_mx) + "     " + str(Nsample_Block) + '\n')

    k = 0
    while(k!=Mx_mx):
        k = k + 1
        if(data_temp[k]==0): continue
        res = float(float(data_temp[k])/Nsample_Block)
        res = res/float(2**int((k-1)/64+2))   # interval: 4, 8, 16 ...
        f_w.write(format(str(k),"5") +  "   " + format(str(get_szHis(k)),"6") +  "   " + format(int(data_temp[k]),"8") + "   " + format(str(res),"20") +'\n')
    f_w.close()
    os.system("cp "+d_name+" ../../data/distribution/"+d_name)
    os.system("rm "+d_name)








