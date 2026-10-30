import pyperclip
import os


from textwrap import dedent
from unittest import TestCase
from .utils import create_redasql_process, commands_to_str


BASE_DIR = os.path.dirname(__file__)


class CliTest(TestCase):
    """
    need docker
    """

    def setUp(self) -> None:
        self.process = create_redasql_process('--ignore-rc')

    def tearDown(self) -> None:
        if self.process.returncode is None:
            self.process.kill()

    def test_describe_command__with_no_schema(self):
        stdout, stderr = self.process.communicate('\\d\n'.encode())
        stdout = stdout.decode('utf-8')
        expected = dedent("""\
        - city
        - country
        - countrylanguage
        """)
        print(stdout)
        self.assertIn(expected, stdout)

    def test_describe_command__with_schema(self):
        commands = [
            '\\d city',
        ]
        stdout, stderr = self.process.communicate(commands_to_str(commands).encode())
        stdout = stdout.decode('utf-8')
        expected = dedent("""\
        ## city
        - ID
        - Name
        - CountryCode
        - District
        - Population
        """)
        # v8, v9 order different.
        for line in expected.splitlines():
            self.assertIn(line, stdout)

    def test_execute_query(self):
        sql = 'select Code, Name from country order by Code limit 3;'
        stdout, stderr = self.process.communicate(f'{sql}\n'.encode())
        stdout = stdout.decode('utf-8')
        expected = dedent("""\
        +--------+-------------+
        | Code   | Name        |
        |--------+-------------|
        | ABW    | Aruba       |
        | AFG    | Afghanistan |
        | AGO    | Angola      |
        +--------+-------------+
        
        3 rows returned.
        """)
        print('test_execute_query', stdout)
        self.assertIn(expected, stdout)
        self.assertIn('', stdout)

    def test_execute_query_pivoted_table(self):
        sql = 'select Code, Name from country order by Code limit 3;'
        commands = [
            '\\x',
            sql
        ]
        stdout, stderr = self.process.communicate(commands_to_str(commands).encode())
        stdout = stdout.decode('utf-8')
        expected = dedent("""\
        -[RECORD 1]----
        Code| ABW
        Name| Aruba
        -[RECORD 2]----
        Code| AFG
        Name| Afghanistan
        -[RECORD 3]----
        Code| AGO
        Name| Angola
        
        
        3 rows returned.
        """)
        print(stdout)
        self.assertIn(expected, stdout)
        self.assertIn('', stdout)

    def test_execute_query_markdown(self):
        sql = 'select Code, Name from country order by Code limit 3;'
        commands = [
            '\\f markdown',
            sql
        ]
        stdout, stderr = self.process.communicate(commands_to_str(commands).encode())
        stdout = stdout.decode('utf-8')
        expected = dedent("""\
        | Code   | Name        |
        |--------|-------------|
        | ABW    | Aruba       |
        | AFG    | Afghanistan |
        | AGO    | Angola      |
        
        3 rows returned.
        """)
        print(stdout)
        self.assertIn(expected, stdout)
        self.assertIn('', stdout)

    def test_execute_query_markdown_pivoted(self):
        sql = 'select id, name, countrycode, district, population from city limit 1;'
        commands = [
            '\\f markdown',
            '\\x',
            sql
        ]
        stdout, stderr = self.process.communicate(commands_to_str(commands).encode())
        stdout = stdout.decode('utf-8')
        expected = dedent("""\
        |--------------|---------|
        | id           | 1       |
        | name         | Kabul   |
        | countrycode  | AFG     |
        | district     | Kabol   |
        | population   | 1780000 |
        """)
        print(stdout)
        self.assertIn(expected, stdout)
        self.assertIn('', stdout)

    def test_execute_query_markdown_with_sql(self):
        sql = 'select Code, Name from country order by Code limit 3;'
        commands = [
            '\\f markdown_with_sql',
            sql
        ]
        stdout, stderr = self.process.communicate(commands_to_str(commands).encode())
        stdout = stdout.decode('utf-8')
        expected = dedent("""\
        ```sql
        select Code, Name from country order by Code limit 3;
        ```
        
        | Code   | Name        |
        |--------|-------------|
        | ABW    | Aruba       |
        | AFG    | Afghanistan |
        | AGO    | Angola      |
        
        3 rows returned.
        """)
        print(stdout)
        self.assertIn(expected, stdout)
        self.assertIn('', stdout)

    def test_execute_query_output_to_clipboard(self):
        sql = 'select Code, Name from country order by Code limit 3;'
        commands = [
            '\\o stdout_and_clipboard',
            sql
        ]
        stdout, stderr = self.process.communicate(commands_to_str(commands).encode())
        stdout = stdout.decode('utf-8')
        expected = dedent("""
        +--------+-------------+
        | Code   | Name        |
        |--------+-------------|
        | ABW    | Aruba       |
        | AFG    | Afghanistan |
        | AGO    | Angola      |
        +--------+-------------+
        """)[1:-1]
        print(stdout)
        self.assertIn(expected, stdout)
        self.assertIn(expected, pyperclip.paste())

    def test_execute_query_output_to_file(self):
        file_name = 'result.txt'
        sql = 'select Code, Name from country order by Code limit 3;'
        commands = [
            f'\\o file {file_name}',
            sql
        ]
        stdout, stderr = self.process.communicate(commands_to_str(commands).encode())
        stdout = stdout.decode('utf-8')
        expected = dedent("""
        +--------+-------------+
        | Code   | Name        |
        |--------+-------------|
        | ABW    | Aruba       |
        | AFG    | Afghanistan |
        | AGO    | Angola      |
        +--------+-------------+
        """)[1:-1]
        print(stdout)
        self.assertIn(expected, stdout)
        with open(file_name) as f:
            result = f.read()
            self.assertIn(expected, result)

    def test_execute_load_query(self):
        commands = [
            '\\l 1',
        ]
        stdout, stderr = self.process.communicate(commands_to_str(commands).encode())
        stdout = stdout.decode('utf-8')
        expected = dedent("""\
        select * from country order by 1;
        """)
        print(stdout)
        self.assertIn(expected, stdout)

    def test_execute_load_file(self):
        commands = [
            f'\\i {BASE_DIR}/data/test.sql',
        ]
        stdout, stderr = self.process.communicate(commands_to_str(commands).encode())
        stdout = stdout.decode('utf-8')
        expected_query = dedent("""\
        select
            Name
        from country order by 1
        limit 3
        ;
        """)
        expected_result = dedent("""\
        +-------------+
        | Name        |
        |-------------|
        | Afghanistan |
        | Albania     |
        | Algeria     |
        +-------------+
        """)
        print(stdout)
        self.assertIn(expected_query, stdout)
        self.assertIn(expected_result, stdout)

    def test_execute_load_file__with_not_exists(self):
        file_name = f'{BASE_DIR}/data/not_exists.sql'
        commands = [
            f'\\i {file_name}',
        ]
        stdout, stderr = self.process.communicate(commands_to_str(commands).encode())
        stdout = stdout.decode('utf-8')
        expected_result = f'{file_name} is not exists.'
        print(stdout)
        self.assertIn(expected_result, stdout)

    def test_execute_query_with_parameter__prompt(self):
        sql = "select Code, Name from country where Code = '{{ code }}';"
        commands = [
            sql,
            'ABW',
        ]
        stdout, stderr = self.process.communicate(commands_to_str(commands).encode())
        stdout = stdout.decode('utf-8')
        expected = dedent("""\
        +--------+--------+
        | Code   | Name   |
        |--------+--------|
        | ABW    | Aruba  |
        +--------+--------+
        """)
        print(stdout)
        self.assertIn('code? >', stdout)
        self.assertIn(expected, stdout)


class CommandOptionTest(TestCase):
    """
    need docker
    """

    def test_repl_with_variable(self):
        sql = "select Code, Name from country where Code = '{{ code }}';"
        process = create_redasql_process('--ignore-rc -v code=AFG')
        stdout, stderr = process.communicate(f'{sql}\n'.encode())
        stdout = stdout.decode('utf-8')
        expected = dedent("""\
        +--------+-------------+
        | Code   | Name        |
        |--------+-------------|
        | AFG    | Afghanistan |
        +--------+-------------+
        """)
        print(stdout)
        self.assertNotIn('code? >', stdout)
        self.assertIn(expected, stdout)

    def test_command_with_variable(self):
        sql = "select Code, Name from country where Code = '{{ code }}'"
        process = create_redasql_process(f'--ignore-rc -c "{sql}" -v code=AGO')
        stdout, stderr = process.communicate()
        stdout = stdout.decode('utf-8')
        expected = dedent("""\
        +--------+--------+
        | Code   | Name   |
        |--------+--------|
        | AGO    | Angola |
        +--------+--------+
        """)
        print(stdout)
        self.assertEqual(0, process.returncode)
        self.assertIn(expected, stdout)

    def test_command_with_multiple_variables(self):
        sql = "select Code, Name from country where Code in ('{{ a }}', '{{b}}') order by Code"
        process = create_redasql_process(f'--ignore-rc -c "{sql}" -v a=ABW -v b=AFG')
        stdout, stderr = process.communicate()
        stdout = stdout.decode('utf-8')
        expected = dedent("""\
        +--------+-------------+
        | Code   | Name        |
        |--------+-------------|
        | ABW    | Aruba       |
        | AFG    | Afghanistan |
        +--------+-------------+
        """)
        print(stdout)
        self.assertEqual(0, process.returncode)
        self.assertIn(expected, stdout)

    def test_command_with_missing_variable(self):
        sql = "select Code, Name from country where Code = '{{ code }}'"
        process = create_redasql_process(f'--ignore-rc -c "{sql}"')
        stdout, stderr = process.communicate()
        stdout = stdout.decode('utf-8')
        print(stdout)
        self.assertEqual(1, process.returncode)
        self.assertIn("query parameter ['code'] is not given", stdout)

    def test_command_with_invalid_variable_format(self):
        process = create_redasql_process('--ignore-rc -c "select 1" -v code')
        stdout, stderr = process.communicate()
        stdout = stdout.decode('utf-8')
        print(stdout)
        self.assertEqual(2, process.returncode)
        self.assertIn('[code] is invalid variable format', stdout)
