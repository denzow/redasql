from typing import Optional, Any, List

import dataclasses


@dataclasses.dataclass(frozen=True)
class DataSourceDTO:
    """
    {
        'name': 'metadata',
        'pause_reason': None,
        'syntax': 'sql',
        'paused': 0,
        'view_only': False,
        'type': 'pg',
        'id': 2
    }
    """
    id: int
    name: str
    syntax: str
    paused: int
    view_only: bool
    type: str
    pause_reason: Optional[str]

    @classmethod
    def from_response(cls, response: dict):
        return cls(**response)


@dataclasses.dataclass(frozen=True)
class NewAttribute:
    attr_name: str
    value: Any


@dataclasses.dataclass(frozen=True)
class MetaCommandReturnList:
    """
    return object for meta command
    """
    new_attrs: List[NewAttribute]

    def apply(self, target: Any):
        for attribute in self.new_attrs:
            setattr(target, attribute.attr_name, attribute.value)
