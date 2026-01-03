import math

work_name = "2D_test"       # work_job name

#  Ising model Kc
#  2D：0.44068679350977...
#  3D: 0.221654631(8)
#  4D：0.149693785(10) 
#  5D：0.11391498(2)  
#  6D：0.0922982(3)  
#  7D：0.0777086(8) -> 0.0777089(2)

#======================================================================================
Njob = 10   # process chain number
Kc = 0.44068679350977  # temperature parameter
Lx = [4,6,8,10]  # Size
Nsubj = len(Lx)           # one chain
iseed = 12345             # initial seed

# toss & Sample setting
nblock={}
nsamp={}
ntoss={}
for i in range(len(Lx)):
    Lx[i]=1*Lx[i]
    if (Lx[i]<=12):
        nblock[Lx[i]]=1024
        ntoss[Lx[i]]=100
        nsamp[Lx[i]]=1000
    elif(Lx[i]<=32):
        nblock[Lx[i]]=512
        ntoss[Lx[i]]= 100
        nsamp[Lx[i]]= 1000                 
    else:
        nblock[Lx[i]]= 512
        ntoss[Lx[i]]=  100
        nsamp[Lx[i]]=  500

Nratio = [1]
job_label ="job_"     # task name
#======================================================================================
job_time ="44480:00:00"   # walltime