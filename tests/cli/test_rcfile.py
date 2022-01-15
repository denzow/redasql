import os

import pyperclip

from textwrap import dedent
from unittest import TestCase
from .utils import create_redasql_process, commands_to_str


class RcFileTest(TestCase):
    """
    need docker
    """

    def setUp(self) -> None:
        dir_name = os.path.dirname(os.path.abspath(__file__))

        self.process = create_redasql_process(
            additional_envs={
                'REDASQL_RCFILE': f'{dir_name}/data/testrc'
            }
        )

    def tearDown(self) -> None:
        if self.process.returncode is None:
            self.process.kill()

    def test_rc_file(self):
        stdout, stderr = self.process.communicate('\n'.encode())
        stdout = stdout.decode('utf-8')

        self.assertIn('** load rc file from', stdout)
        self.assertIn('set pivoted [True]', stdout)
        self.assertIn('set formatter [markdown_with_sql]', stdout)
        self.assertIn('set output [stdout_and_clipboard]', stdout)
