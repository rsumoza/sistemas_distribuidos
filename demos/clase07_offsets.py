#!/usr/bin/env python3
"""Demostración didáctica de offsets, pérdida, repetición e inbox atómica.

No requiere Kafka. La simulación hace visible el orden entre:
  poll -> efecto -> registro de deduplicación -> commit de offset -> crash.
"""
from __future__ import annotations

from dataclasses import dataclass, field


EVENT = {"offset": 42, "event_id": "evt-9F2A-1", "qty": 1}


@dataclass
class State:
    stock: int = 10
    committed_offset: int = 42
    processed_ids: set[str] = field(default_factory=set)


def at_most_once() -> None:
    state = State()
    print("\nAT-MOST-ONCE: poll -> commit offset -> CRASH -> efecto")
    print(f"  poll offset {EVENT['offset']}")
    state.committed_offset = 43
    print("  commit offset 43")
    print("  CRASH antes del efecto")
    print(
        f"  restart en {state.committed_offset}; stock={state.stock} "
        "(el efecto se perdió)"
    )


def at_least_once_without_idempotency() -> None:
    state = State()
    print("\nAT-LEAST-ONCE SIN IDEMPOTENCIA: poll -> efecto -> CRASH -> replay")
    print(f"  poll offset {EVENT['offset']}")
    state.stock -= EVENT["qty"]
    print(f"  efecto aplicado: stock={state.stock}")
    print("  CRASH antes del commit del offset")
    print(f"  restart en {state.committed_offset}; replay offset {EVENT['offset']}")
    state.stock -= EVENT["qty"]
    print(f"  efecto repetido: stock={state.stock}")
    state.committed_offset = 43
    print("  commit offset 43")


def atomic_inbox_and_effect() -> None:
    state = State()
    print("\nAT-LEAST-ONCE + INBOX ATÓMICA")

    def local_transaction() -> None:
        event_id = EVENT["event_id"]
        if event_id in state.processed_ids:
            print("  replay detectado: event_id ya procesado; no-op")
            return
        # Modelo didáctico: ambos cambios confirman o ninguno confirma.
        state.processed_ids.add(event_id)
        state.stock -= EVENT["qty"]
        print(f"  COMMIT local: inbox + stock; stock={state.stock}")

    print(f"  poll offset {EVENT['offset']}")
    local_transaction()
    print("  CRASH antes del commit del offset")
    print(f"  restart en {state.committed_offset}; replay offset {EVENT['offset']}")
    local_transaction()
    state.committed_offset = 43
    print(f"  commit offset 43; stock final={state.stock}")


def non_atomic_counterexample() -> None:
    state = State()
    print("\nCONTRAEJEMPLO: efecto e inbox NO son atómicos")
    state.stock -= EVENT["qty"]
    print(f"  efecto persistido: stock={state.stock}")
    print("  CRASH antes de registrar event_id")
    print("  replay: la inbox no reconoce el evento")
    state.stock -= EVENT["qty"]
    state.processed_ids.add(EVENT["event_id"])
    print(f"  segundo efecto: stock={state.stock} (duplicación lógica)")


if __name__ == "__main__":
    at_most_once()
    at_least_once_without_idempotency()
    atomic_inbox_and_effect()
    non_atomic_counterexample()
