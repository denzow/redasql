from typing import Optional

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
