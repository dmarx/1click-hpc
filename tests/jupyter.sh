#!/bin/bash

cat > jupyter.sbatch << EOF
#!/bin/bash
#SBATCH --job-name=jupyter
#SBATCH --partition=compute-od-jupyter
#SBATCH --gpus=1
#SBATCH --cpus-per-gpu=6
#SBATCH --time=2-00:00:00
#SBATCH --output=%x_%j.out

cat /etc/hosts
python3.8 -m pip install notebook
jupyter notebook --ip=0.0.0.0 --port=8888
EOF

cat > jupyter.py << EOF
import os
import re
import time

# get slurm job ID
jobId = os.popen('sbatch jupyter.sbatch').read()
print(jobId)
jobId = [int(s) for s in jobId.split() if s.isdigit()][0]

# TO DO: script should infer headnode ip. presumably this is the IP that ran the script
HEADNODE_IP='44.195.55.5'

# wait for the output file to appear
while not os.path.exists(f'jupyter_{jobId}.out'):
    time.sleep(1)

# wait until notebook server is started
content=''
while not "http://127.0.0.1" in content:
   with open(f'jupyter_{jobId}.out') as fh:
      content = fh.read()
   time.sleep(1)

with open(f'jupyter_{jobId}.out') as fh:
   fstring = fh.readlines()

# extract compute node IP
pattern = re.compile(r'(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})')
jIP = ''
for line in fstring:
   if pattern.search(line) is not None:
      jIP = pattern.search(line)[0]
      if jIP.startswith('172.31.'):
         break

# extract jupyter notebook token
token = ''
for line in fstring:
   token = line
   if token.startswith('     or http://127.0.0.1:8888/'):
      break
token = token.split('=')[-1]

username = os.getlogin()

print ("connect with:")
print (f"ssh -L8888:{jIP}:8888 {username}@{HEADNODE_IP}")
print()
print("then browse:")
print (f"http://127.0.0.1:8888/?token={token}")
print()
print("when done, close the job:")
print(f"scancel {jobId}")
EOF

# run this command every time in the future
python3.8 jupyter.py
