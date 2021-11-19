import re
from typing import List
from prompt_toolkit.completion import FuzzyWordCompleter
from redasql.constants import CompleterType


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

        for completer in super().get_completions(document, complete_event):
            if targets and completer.display_meta_text not in targets:
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
