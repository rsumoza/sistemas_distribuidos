#!/usr/bin/env python3
"""Demostración didáctica de visibilidad MVCC y retención de versiones."""
from __future__ import annotations

from dataclasses import dataclass


@dataclass(frozen=True)
class Version:
    name: str
    value: int
    begin: int
    end: int | None = None

    def visible_at(self, snapshot: int) -> bool:
        return self.begin <= snapshot and (self.end is None or snapshot < self.end)


versions = [
    Version("v1", 120, begin=10, end=30),
    Version("v2", 135, begin=30, end=None),
]


def read(snapshot: int) -> Version | None:
    candidates = [v for v in versions if v.visible_at(snapshot)]
    return max(candidates, key=lambda v: v.begin) if candidates else None


for snapshot in (20, 35):
    v = read(snapshot)
    print(f"snapshot={snapshot}: ve {v.name} total={v.value}" if v else "sin versión visible")

oldest_active_snapshot = 20
print(f"\nsnapshot activo más antiguo={oldest_active_snapshot}")
for v in versions:
    reclaimable = v.end is not None and v.end <= oldest_active_snapshot
    print(f"{v.name}: end={v.end}, reclamable={reclaimable}")

print("\nMientras exista el snapshot 20, v1 sigue siendo historia necesaria.")
print("Cuando ningún snapshot pueda verla, v1 queda muerta y puede limpiarse.")
print("Si muchas versiones muertas siguen ocupando páginas e índices, aparece bloat.")
