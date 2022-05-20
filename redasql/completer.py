import re
import itertools

from pathlib import Path
from typing import List

from prompt_toolkit.completion import FuzzyWordCompleter
from redasql.constants import FormatterType, CompleterType, SQL_KEYWORDS, OutputType
from redasql.dto import SchemaResponse, DataSourceResponse
from redasql.constants import CACHED_RESULTS_PREFIX


class CompleteData:
    def __init__(self):
        self.keywords = SQL_KEYWORDS
        self.schemas: List[SchemaResponse] = []
        self.data_sources: List[DataSourceResponse] = []
        self.formats = FormatterType.values()
        self.outputs = OutputType.values()

    @property
    def column_names(self):
        return list(
            itertools.chain.from_iterable([schema.columns for schema in self.schemas])
        )

    @property
    def schema_names(self):
        return [schema.name for schema in self.schemas]

    @property
    def local_files(self):
        return [
            item.name for item in Path('.').iterdir() if item.is_file()
        ]

    @property
    def data_source_names(self):
        ds_names = []
        for ds in self.data_sources:
            ds_names.append(ds.name)
            if 'results' == ds.type:
                ds_names.append(f'{CACHED_RESULTS_PREFIX}{ds.name}')
        return ds_names

    def get_completer_words(self):
        words = list(set(
                self.column_names +
                self.schema_names +
                self.keywords +
                self.data_source_names +
                self.formats +
                self.outputs +
                self.local_files
        ))
        return sorted(words, key=lambda x: len(x))

    def get_completer_meta_dict(self):
        meta_dict = {}
        meta_dict.update({c: CompleterType.TABLE.value for c in self.schema_names})
        meta_dict.update({c: CompleterType.COLUMN.value for c in self.column_names})
        meta_dict.update({c: CompleterType.KEYWORD.value for c in self.keywords})
        meta_dict.update({c: CompleterType.DATA_SOURCE.value for c in self.data_source_names})
        meta_dict.update({c: CompleterType.FORMAT.value for c in self.formats})
        meta_dict.update({c: CompleterType.OUTPUT.value for c in self.outputs})
        meta_dict.update({c: CompleterType.FILE.value for c in self.local_files})
        return meta_dict


class RedasqlCompleter(FuzzyWordCompleter):

    def __init__(self, latest_inputs: List[str], *args, **kwargs):
        self.latest_input_string = ' '.join(latest_inputs)
        super().__init__(*args, **kwargs)

    def get_completions(self, document, complete_event):
        targets = CompleterType.normal_completer_types()
        target_text = document.text[:document.cursor_position]
        if self.check_last_word(target_text, 'from'):
            targets = [CompleterType.TABLE.value]

        if self.check_last_word(target_text, 'select'):
            targets = [CompleterType.COLUMN.value]

        if self._is_in_meta(target_text, r'\c'):
            targets = [CompleterType.DATA_SOURCE.value]

        if self._is_in_meta(target_text, r'\f'):
            targets = [CompleterType.FORMAT.value]

        if self._is_in_meta(target_text, r'\d'):
            targets = [CompleterType.TABLE.value]

        if self._is_in_meta(target_text, r'\o'):
            targets = [CompleterType.OUTPUT.value]

        if self._is_in_meta(target_text, r'\i'):
            targets = [CompleterType.FILE.value]

        for completer in super().get_completions(document, complete_event):
            if targets and (completer.display_meta_text not in targets):
                continue
            yield completer

    def check_last_word(self, text: str, expect_word: str):
        target = self.latest_input_string + ' ' + text
        target.replace('\\n', ' ')
        target_list = re.split(r'\s+', target)
        # last 1 word is current input. so ignore.
        if len(target_list) > 2:
            return target_list[-2].lower().strip().endswith(expect_word)
        return False

    def _is_in_meta(self, text: str, target):
        return text.startswith(target)
