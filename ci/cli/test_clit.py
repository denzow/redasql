from textwrap import dedent
from unittest import TestCase
from .utils import run_command


class CliTest(TestCase):
    """
    need docker
    """

    def setUp(self) -> None:
        self.process = run_command()

    def tearDown(self) -> None:
        if self.process.returncode is None:
            self.process.kill()

    def test_describe_command(self):
        stdout, stderr = self.process.communicate('\\d\n'.encode())
        expected = dedent("""\
        - city
        - country
        - countrylanguage
        """)
        self.assertIn(expected, stdout.decode('utf-8'))


