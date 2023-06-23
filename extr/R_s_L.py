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
Njob = 11   # chain number
L = [4,6,8]  # size list
d = 7
###################################################################################
os.chdir("../qsub_1")

# loop different sizes 
for j in range(len(L)):

    data_temp = [0]*2000  # initialize data of this size
    average_temp = [0]*2000  # initialize data of this size
    Nsample_Block = 0 # initialize sample number of this size
    Mx_mx = 0  # initialize Max index of this size

    d_name = "R_s_V_"
    d_name = d_name + str(int(L[j]**d))

    # loop dir_job
    for i in range(Njob):
        f_name = "dir_job_"
        f_name = f_name + str(i+1)
        os.chdir(f_name)
        f_r = open(d_name,'r')
        # start catching

        while(True):  # set loop condition
            index_szHis = get_word(f_r)     # for test
            if(index_szHis==""): break      # arrive the end of the file
            index_szHis = int(index_szHis)  # get the integer            
            if(Mx_mx<index_szHis): Mx_mx = index_szHis        # update the Max
            szHis = int(get_word(f_r))
            get_word(f_r)
            get_word(f_r)
            get_word(f_r)
            f_data = float(get_word(f_r))    # R value
            get_word(f_r)
            data_temp[index_szHis] = data_temp[index_szHis] + f_data
            average_temp[index_szHis] = average_temp[index_szHis] + 1    # count
        f_r.close
        os.chdir("..")  # exit this dir_job

    # start writing
    f_w = open(d_name,'w')

    k = 0
    while(k!=Mx_mx):
        k = k + 1
        if(data_temp[k]==0): continue
        res = float(data_temp[k]/average_temp[k])
        f_w.write(format(str(k),"5") +  "     " + format(str(get_szHis(k)),"6") + "      " +  format(format(res,".10f"),"20") + "      " + format(format(data_temp[k],".10f"),"20") +"     " + format(str(average_temp[k]),"5") +'\n')
    f_w.close()
    os.system("cp "+d_name+" ../data/distribution/"+d_name)
    os.system("rm "+d_name)







