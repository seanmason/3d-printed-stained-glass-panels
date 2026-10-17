from pathlib import Path
import subprocess,json
R=Path(__file__).resolve().parents[1]
output=R/'work/lion-ironing-test-sliced.3mf'
args=['C:/Program Files/Bambu Studio/bambu-studio.exe','--slice','1','--debug','2','--export-3mf',str(output),str(R/'outputs/lion-ironing-test-H2D.3mf')]
startup=subprocess.STARTUPINFO();startup.dwFlags|=subprocess.STARTF_USESHOWWINDOW;startup.wShowWindow=0
try:
 p=subprocess.run(args,capture_output=True,text=True,timeout=55,startupinfo=startup)
 print('returncode',p.returncode)
 (R/'work/ironing-cli.log').write_text(p.stdout+'\n'+p.stderr,encoding='utf-8')
 print(p.stdout[-6000:]);print(p.stderr[-2000:])
except subprocess.TimeoutExpired:
 print('CLI timed out; stopped only the child launched by this script.')
print('sliced_file_exists',output.exists())
