import os
import parameter_setting as p

os.system("cd ../bin && gfortran ../src/main.f90")          # compile code
os.system("mkdir " + p.work_name)                           # create work file
os.system("cp ../bin/a.out " + p.work_name)                 # copy binary file 
os.chdir(p.work_name)                                       # enter into work file


job_dir=os.getcwd()       # get path
print("========================================================") # ==============
print("path: "+job_dir)    # show path
print("Nsub: "+str(format(p.Nsubj,'8d'))) # show Nsub

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

number_of_input = cal_number_of_input(p.Nratio,p.Nsubj, p.Njob)
number_inside_job = cal_number_of_input(p.Nratio,p.Nsubj,1)
len_Njob = cal_len_of_number(p.Njob) 
len_input = cal_len_of_number(number_of_input) 
print("Njob: ", str(format(p.Njob,'8d')))
print("number_of_input: ", str(number_of_input))

# make job files
ijob=0
iinput=0
for i in range(p.Njob):
    ijob= i+1
    job_id = str(ijob)
    f=open("job_"+job_id,'w')
    f.write("#!/bin/bash"+'\n')
    f.write("#PBS -N "+ p.job_label + str(ijob) +'\n')
    f.write("#PBS -j oe"+ '\n')
    f.write("#PBS -l walltime=" + p.job_time + '\n\n\n')

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


alljob=range(1, p.Njob*p.Nsubj+1)

# make input files
ijob = 0
iseed = p.iseed 
for i in range(p.Njob):    
      for j in p.Lx:        # for diff system size
        iseed = iseed + 1    # update seed
        ijob= ijob + 1
        iijob= alljob[ijob-1]
        input_id= num_to_str(iijob, len_input)
        f= open("input_"+ input_id,'w')
        nw = 1
        content = str(j)+ "   " +str(p.ntoss[j])+ "   " +str(p.nsamp[j])+"   "+str(nw)+ "   "+ str(p.Kc) + "   " + str(iseed)+ "  "+ str(p.nblock[j]) 
        f.write(content + '\n' )
        f.close()


print("========================================================") # ==============

# clear_qsub.sh
f_w = open('clear_qsub.sh','w')
f_w.write('rm job*' + '\n')
f_w.write('rm input*' + '\n')
f_w.write('rm -r dir*' + '\n')
f_w.write('rm Ising*' + '\n')
f_w.close()

# qsub.sh
f_w = open('qsub.sh','w')
f_w.write('#!/bin/bash' + '\n' + '\n')
f_w.write('Njob=' + str(p.Njob) + '\n')
f_w.write('sub=1' + '\n')
f_w.write('if [ $sub -eq 1 ]' + '\n')
f_w.write('then' + '\n')
f_w.write('for ((i=1;i<=$Njob;i++)); do' + '\n')
f_w.write('  {' + '\n')
f_w.write('      qsub job_$i' + '\n')
f_w.write('          sleep .5' + '\n')
f_w.write('      echo $i' + '\n')
f_w.write(' }' + '\n')
f_w.write('done' + '\n')
f_w.write('wait' + '\n')
f_w.write('fi' + '\n')
f_w.write('exit 0' + '\n')
f_w.close()