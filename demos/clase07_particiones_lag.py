#!/usr/bin/env python3
"""Capacidad agregada, hot partition y tiempo ideal de catch-up."""
from __future__ import annotations

PARTITIONS = {
    "P0": {"arrival": 10_000, "service": 10_300, "lag": 20_000},
    "P1": {"arrival": 10_500, "service": 10_600, "lag": 18_000},
    "P2": {"arrival": 38_000, "service": 16_000, "lag": 1_800_000},
    "P3": {"arrival": 9_800, "service": 10_100, "lag": 15_000},
}

for name, data in PARTITIONS.items():
    net = data["service"] - data["arrival"]
    if net > 0:
        catchup = data["lag"] / net
        status = f"recupera ~{catchup:.1f}s (ideal)"
    elif net == 0:
        status = "lag no disminuye"
    else:
        status = f"backlog crece {-net:,} eventos/s"
    print(
        f"{name}: ingreso={data['arrival']:,}/s, consumo={data['service']:,}/s, "
        f"lag={data['lag']:,} -> {status}"
    )

print("\nConclusión: la capacidad agregada no compensa una sola partición caliente.")
print("Agregar consumers ociosos no divide P2; hay que revisar key, costo o particionado.")
