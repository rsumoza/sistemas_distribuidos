#!/usr/bin/env python3
"""Demostración didáctica: páginas base + WAL confirmado -> estado recuperado.

No modela el formato interno de PostgreSQL. Hace visible la diferencia entre:
- registros de modificación, que contienen cómo rehacer;
- registro COMMIT, que indica qué transacción integra la historia confirmada;
- flush_lsn, que delimita el prefijo durable;
- page_lsn, que permite evitar REDO innecesario.
"""
from __future__ import annotations

from dataclasses import dataclass, field
from copy import deepcopy


@dataclass(frozen=True)
class WalRecord:
    lsn: int
    tx: str
    kind: str
    key: str | None = None
    value: object | None = None


@dataclass
class PageState:
    data: dict[str, object] = field(default_factory=dict)
    page_lsn: int = 0


WAL = [
    WalRecord(100, "T57", "SET", "purchase:9F2A", {"status": "CONFIRMED", "total": 8000}),
    WalRecord(101, "T57", "SET", "stock:product-17", 0),
    WalRecord(102, "T57", "SET", "index:8421:9F2A", "P17"),
    WalRecord(103, "T57", "COMMIT"),
]

BASE = PageState(
    data={
        "purchase:9F2A": None,
        "stock:product-17": 1,
        "index:8421:9F2A": None,
    },
    page_lsn=99,
)


def recover(base: PageState, wal: list[WalRecord], flush_lsn: int) -> PageState:
    """Rehace únicamente transacciones cuyo COMMIT está en el prefijo durable."""
    state = deepcopy(base)
    committed = {
        r.tx for r in wal if r.kind == "COMMIT" and r.lsn <= flush_lsn
    }
    print(f"  transacciones con COMMIT durable: {sorted(committed) or 'ninguna'}")

    for record in wal:
        if record.lsn > flush_lsn:
            continue
        if record.tx not in committed or record.kind != "SET":
            continue
        if state.page_lsn >= record.lsn:
            print(f"  omitir LSN {record.lsn}: page_lsn={state.page_lsn}")
            continue
        state.data[record.key] = record.value
        state.page_lsn = record.lsn
        print(f"  REDO LSN {record.lsn}: {record.key} <- {record.value}")
    return state


def scenario(name: str, flush_lsn: int) -> None:
    print(f"\n=== {name} (flush_lsn={flush_lsn}) ===")
    print("estado persistente antes del crash:", BASE.data)
    result = recover(BASE, WAL, flush_lsn)
    print("estado después de recovery:", result.data)


if __name__ == "__main__":
    scenario("Crash antes de COMMIT durable", 102)
    scenario("Crash después de COMMIT durable, antes de páginas", 103)
    print("\nIdea: COMMIT no contiene toda la fila. Los SET contienen cómo rehacer;")
    print("COMMIT decide que esos cambios pertenecen a la historia confirmada.")
