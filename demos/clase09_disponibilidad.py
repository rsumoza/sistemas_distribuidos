#!/usr/bin/env python3
"""Disponibilidad idealizada de cadenas sincrónicas."""

def chain_availability(component_availability: float, n: int) -> float:
    return component_availability ** n

for n in [1,2,4,8]:
    a=chain_availability(0.999,n)
    downtime_minutes=(1-a)*30*24*60
    print(f"{n} componentes al 99.9%: flujo={100*a:.4f}% ~ {downtime_minutes:.1f} min/30d")
print("Nota: el cálculo asume independencia y omite red; es optimista.")
