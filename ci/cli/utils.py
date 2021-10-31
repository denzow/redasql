import os
import subprocess

REDASH_HOST = 'http://localhost:5001'
API_KEY = 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
DS_NAME = 'MySQL'
COMMAND = f'poetry run python redasql/command.py -s {REDASH_HOST} -k {API_KEY} -d {DS_NAME}'

envs = {}
for k, v in os.environ.items():
    if not k.startswith('REDASQL'):
        envs[k] = v

def run_command():
    p = subprocess.Popen(
        COMMAND,
        shell=True,
        stdin=subprocess.PIPE,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        close_fds=True,
        env=envs,
    )
    return p
