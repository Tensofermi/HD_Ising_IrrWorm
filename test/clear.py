import os
import platform

sys_str = platform.system().lower()

if sys_str == 'windows':
  print("Windows clear")
  os.system('del a.exe')
  os.system('del ns*')
  os.system('del *.mod')  
  os.system('del R_s_V*')
  os.system('del output.txt')

elif sys_str == 'linux':
  print("Linux clear")
  os.system('rm a.exe')
  os.system('rm ns*')
  os.system('rm *.mod')
  os.system('rm R_s_V*')
  os.system('rm output.txt')