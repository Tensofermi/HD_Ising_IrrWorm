import os
import math

job_dir=os.getcwd()       # get path
os.system('cd ../../ && gfortran main.f90 && cp a.out '+job_dir+'/a.out && cd '+job_dir)    # copy new a.out 

#  Ising model Kc
#  2D：0.44068679350977...
#  3D: 0.221654631(8)
#  4D：0.149693785(10) 
#  5D：0.11391498(2)  
#  6D：0.0922982(3)  
#  7D：0.0777086(8) -> 0.0777089(2)

#======================================================================================
Njob = 40   # process chain number
Kc = 0.11391498  # temperature parameter
Lx = [24]  # Size
Nsubj = len(Lx)           # one chain
iseed = 12345             # initial seed

# toss & Sample setting
nblock={}
nsamp={}
ntoss={}
for i in range(len(Lx)):
    Lx[i]=1*Lx[i]
    if (Lx[i]<=8):
        nblock[Lx[i]]=512
        ntoss[Lx[i]]=100
        nsamp[Lx[i]]=1000
    elif(Lx[i]<=12):
        nblock[Lx[i]]=512
        ntoss[Lx[i]]= 100
        nsamp[Lx[i]]= 500                 
    else:
        nblock[Lx[i]]= 256
        ntoss[Lx[i]]=  100
        nsamp[Lx[i]]=  200

Nratio = [1]
job_label ="job_"     # task name
#======================================================================================
job_time ="44480:00:00"   # walltime
job_dir=os.getcwd()       # get path
print("========================================================") # ==============
print("path: "+job_dir)    # show path
print("Nsub: "+str(Nsubj)) # show Nsub


### simulation paramter
##########################################################
#get total
def cal_number_of_input(Nratio, Nsubj, Njob):
    tmp =0
    for i in Nratio:
        tmp = tmp + i
    return tmp * Nsubj * Njob

#get digit number
def cal_len_of_number(number_of_input):
    tmp=9
    ct =1
    for i in range(10):
        tmp = tmp *10+9 
        ct = ct+1
        if (number_of_input<=tmp):
            break
    return ct

#get string 000x like
def num_to_str(ijob, len_str):
    tmp = str(ijob)
    return tmp.zfill(len_str)


##########################################################

number_of_input = cal_number_of_input(Nratio,Nsubj, Njob)
number_inside_job = cal_number_of_input(Nratio,Nsubj,1)
len_Njob = cal_len_of_number(Njob) 
len_input = cal_len_of_number(number_of_input) 
print("len_input  number_of_input=", len_input, number_of_input)
print("len_Njob  Njob=", len_Njob, Njob)

# make job files
ijob=0
iinput=0
for i in range(Njob):
    ijob= i+1
    job_id = str(ijob)
    f=open("job_"+job_id,'w')
    f.write("#!/bin/bash"+'\n')
    f.write("#PBS -N "+ job_label + str(ijob) +'\n')
    f.write("#PBS -j oe"+ '\n')
    f.write("#PBS -l walltime="+job_time + '\n\n\n')

    f.write("cd  " + job_dir + '\n') 
    f.write("mkdir " +"dir_job_"+job_id + '\n') 
    f.write("cp a.out " +"dir_job_"+job_id + '\n\n') 

    tmp_input=iinput
    for i in range(number_inside_job):
        iinput =iinput +1
        input_id = num_to_str( iinput, len_input)
        infile = "input_"+input_id
        f.write("cp "+infile+" dir_job_"+job_id+ "\n") 

    f.write("\n cd " +"dir_job_"+job_id + '\n\n') 

    iinput=tmp_input
    for i in range(number_inside_job):
        iinput =iinput +1
        input_id = num_to_str( iinput, len_input)
        infile = "input_"+input_id
        outfile = "output_"+input_id
        f.write( "./a.out < " +infile +" > "+ outfile+ '\n')
        f.write( "echo " + infile + " finished  at `date` " +" >> "+  "log.dat"+ '\n')
        f.write("rm "+infile+"\n")
        f.write("\n")
    f.write("exit 0")
    f.close()


alljob=range(1, Njob*Nsubj+1)

# make input files
ijob=0
for i in range(Njob):    
      for j in Lx:        # for diff system size
        iseed = iseed+1    # update seed
        ijob= ijob + 1
        iijob= alljob[ijob-1]
        input_id= num_to_str(iijob, len_input)
        f= open("input_"+ input_id,'w')
        nw = 1
        content = str(j)+ "   " +str(ntoss[j])+ "   " +str(nsamp[j])+"   "+str(nw)+ "   "+ str(Kc) + "   " + str(iseed)+ "  "+ str(nblock[j]) 
        f.write(content + '\n' )
        f.close()


print("========================================================") # ==============
