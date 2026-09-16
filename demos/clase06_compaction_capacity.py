#!/usr/bin/env python3
"""Modelo didáctico de backlog y umbrales de write stall."""
from __future__ import annotations

INGEST_MB_S = 90.0
COMPACTION_MB_S = 60.0
BACKLOG_GB = 18.0
SLOWDOWN_GB = 27.0
STOP_GB = 36.0


def seconds_to(target_gb: float) -> float:
    deficit = INGEST_MB_S - COMPACTION_MB_S
    if deficit <= 0:
        return float("inf")
    return (target_gb - BACKLOG_GB) * 1000 / deficit


def fmt(seconds: float) -> str:
    return f"{seconds/60:.1f} min"


print(f"ingreso={INGEST_MB_S:.0f} MB/s")
print(f"compactación={COMPACTION_MB_S:.0f} MB/s")
print(f"déficit sostenido={INGEST_MB_S-COMPACTION_MB_S:.0f} MB/s")
print(f"tiempo ideal hasta slowdown ({SLOWDOWN_GB:.0f} GB): {fmt(seconds_to(SLOWDOWN_GB))}")
print(f"tiempo ideal hasta stop ({STOP_GB:.0f} GB): {fmt(seconds_to(STOP_GB))}")

print("\nEvolución idealizada cada 2 minutos:")
backlog = BACKLOG_GB
for minute in range(0, 12, 2):
    if minute:
        backlog += (INGEST_MB_S-COMPACTION_MB_S) * 120 / 1000
    state = "normal"
    if backlog >= STOP_GB:
        state = "stop/stall"
    elif backlog >= SLOWDOWN_GB:
        state = "slowdown"
    print(f"t={minute:2d} min backlog={backlog:4.1f} GB estado={state}")

print("\nEl stall reduce la admisión; no crea capacidad de compactación.")
print("La cuenta es idealizada: en producción importan ráfagas, niveles, disco, CPU y configuración.")
