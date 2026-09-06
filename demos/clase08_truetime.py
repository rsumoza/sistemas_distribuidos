#!/usr/bin/env python3
"""Modelo didáctico del predicado usado para explicar commit wait.

No implementa TrueTime ni sincronización de relojes. Solo representa una API
que entrega intervalos con una cota y evalúa cuándo earliest > commit_ts.
"""
from dataclasses import dataclass


@dataclass(frozen=True)
class TT:
    earliest_ms: int
    latest_ms: int

    @property
    def uncertainty_ms(self) -> int:
        return self.latest_ms - self.earliest_ms


commit_ts = 10  # ms desde una referencia didáctica
samples = [TT(4, 16), TT(8, 20), TT(11, 23)]
print("MODELO DIDÁCTICO: no es una implementación de TrueTime")
print(f"timestamp de commit s={commit_ts} ms")
for i, tt in enumerate(samples, 1):
    safe = tt.earliest_ms > commit_ts
    print(
        f"muestra {i}: [{tt.earliest_ms},{tt.latest_ms}] "
        f"incertidumbre={tt.uncertainty_ms} ms -> earliest>s: {safe}"
    )
    if safe:
        print("commit puede hacerse visible: s está garantizado en el pasado")
        break
