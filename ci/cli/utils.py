import os
import sys
import subprocess

from typing import List

REDASH_HOST = os.environ.get('REDASH_HOST', 'http://localhost:5001')
API_KEY = os.environ.get('REDASH_API_KEY', 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX')
DS_NAME = os.environ.get('REDASH_DS_NAME', 'MySQL')
COMMAND = f'{sys.executable} redasql/command.py -s {REDASH_HOST} -k {API_KEY} -d {DS_NAME}'

envs = {}
for k, v in os.environ.items():
    if not k.startswith('REDASQL'):
        envs[k] = v


def create_redasql_process():
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


def commands_to_str(command_list: List[str]):
    result = ''
    for command in command_list:
        result += f'{command}\n'
    return result
