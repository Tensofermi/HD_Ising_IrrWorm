import os
import platform

sys_str = platform.system().lower()

if sys_str == 'windows':
  print("Windows start")
  os.system('gfortran ../src/main.f90')
  os.system('.\\a.exe < input.txt > output.txt')

elif sys_str == 'linux':
  print("Linux start")
  os.system('gfortran ../src/main.f90')
  os.system('./a.out < input.txt > output.txt')