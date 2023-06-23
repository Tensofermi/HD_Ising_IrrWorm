import os


Njob_list = [9]
data_name = "data_IsingSqH"
qsub_list = ["2D_test"]        # each qsub must satisfy the same obs list !!
###################################################################################

os.system("rm " + data_name)  # clear old data
f_w = open(data_name,'w')     # set new data

for j in range(len(qsub_list)):

# choose qsub number 
    os.chdir("../qsub_" + str(qsub_list[j]))

    for i in range(Njob_list[j]):
# choose chain number 
        file_read = "dir_job_"
        file_read = file_read + str(i+1)
        os.chdir(file_read)
# copy data of this chain
        try:
            f_r = open(data_name,'r')
            f_w.write(f_r.read())
            f_r.close()
        except FileNotFoundError:
            print("sth lost in" + "job_" + str(i+1))
# go back
        os.chdir("..")

f_w.close()
