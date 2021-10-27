import re
from typing import List
from prompt_toolkit.completion import FuzzyWordCompleter
from redasql.constants import CompleterType


class RedasqlCompleter(FuzzyWordCompleter):

    def __init__(self, latest_inputs: List[str], *args, **kwargs):
        self.latest_input_string = ' '.join(latest_inputs)
        super().__init__(*args, **kwargs)

    def get_completions(self, document, complete_event):
        targets = []
        target_text = document.text[:document.cursor_position]
        if self._is_from_last(target_text):
            targets.append(CompleterType.TABLE.value)
        if self._is_in_connect(target_text):
            targets.append(CompleterType.DATA_SOURCE.value)

        for completer in super().get_completions(document, complete_event):
            if targets and completer.display_meta_text not in targets:
                continue
            yield completer

    def _is_from_last(self, text: str):
        target = self.latest_input_string + ' ' + text
        target.replace('\\n', ' ')
        target_list = re.split(r'\s+', target)
        if len(target_list) > 2:
            return target_list[-2].lower().strip().endswith('from')
        return False

    def _is_in_connect(self, text: str):
        return text.startswith(r'\c ')
