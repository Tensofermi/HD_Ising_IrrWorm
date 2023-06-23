
#!/bin/bash

Njob=40

sub=1

if [ $sub -eq 1 ]
then
for ((i=1;i<=$Njob;i++)); do
  {
      qsub job_$i
          sleep .5
      echo $i
 }
done
wait
fi


exit 0
