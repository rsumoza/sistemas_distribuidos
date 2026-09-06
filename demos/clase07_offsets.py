#!/usr/bin/env python3
"""Semánticas de consumo y atomicidad de la deduplicación.

No requiere Kafka. Modela el orden poll/efecto/commit/crash y hace explícito
que el efecto local y la marca event_id deben persistirse en una misma
transacción para que el replay sea seguro.
"""
from dataclasses import dataclass, field


@dataclass
class State:
    stock: int = 10
    committed_offset: int = 42
    processed_ids: set[str] = field(default_factory=set)


EVENT = {"offset": 42, "event_id": "order-9F2A", "qty": 1}


def effect_non_idempotent(s: State) -> None:
    s.stock -= EVENT["qty"]
    print(f"  efecto aplicado: stock={s.stock}")


def effect_and_mark_atomic(s: State) -> None:
    """Representa una transacción local: check + efecto + inbox/event_id."""
    if EVENT["event_id"] in s.processed_ids:
        print("  efecto omitido: event_id ya existe en inbox")
        return
    s.stock -= EVENT["qty"]
    s.processed_ids.add(EVENT["event_id"])
    print(f"  transacción local: stock={s.stock}, event_id persistido")


def effect_then_crash_before_mark(s: State) -> None:
    """Anti-ejemplo: efecto y marca se guardan por separado."""
    s.stock -= EVENT["qty"]
    print(f"  efecto persistido: stock={s.stock}")
    print("  CRASH antes de persistir event_id -> el replay no podrá deduplicar")


def at_most_once() -> None:
    s = State()
    print("\nAT-MOST-ONCE: poll -> commit offset -> crash -> efecto")
    s.committed_offset = 43
    print("  commit offset 43")
    print("  CRASH antes del efecto")
    print(f"  restart en {s.committed_offset}; stock={s.stock} (efecto perdido)")


def at_least_once_without_idempotency() -> None:
    s = State()
    print("\nAT-LEAST-ONCE SIN IDEMPOTENCIA: efecto -> crash -> replay")
    effect_non_idempotent(s)
    print("  CRASH antes de commit offset")
    effect_non_idempotent(s)
    s.committed_offset = 43
    print(f"  commit offset 43; stock final={s.stock} (duplicado)")


def at_least_once_with_atomic_inbox() -> None:
    s = State()
    print("\nAT-LEAST-ONCE + INBOX ATÓMICA: efecto+event_id -> crash -> replay")
    effect_and_mark_atomic(s)
    print("  CRASH antes de commit offset")
    effect_and_mark_atomic(s)
    s.committed_offset = 43
    print(f"  commit offset 43; stock final={s.stock} (un solo efecto lógico)")


def non_atomic_dedup_counterexample() -> None:
    s = State()
    print("\nANTI-EJEMPLO: efecto y marca de deduplicación no son atómicos")
    effect_then_crash_before_mark(s)
    print("  replay:")
    effect_and_mark_atomic(s)
    print(f"  stock final={s.stock} (el efecto ocurrió dos veces)")


if __name__ == "__main__":
    at_most_once()
    at_least_once_without_idempotency()
    at_least_once_with_atomic_inbox()
    non_atomic_dedup_counterexample()
