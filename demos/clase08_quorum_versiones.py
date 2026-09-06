#!/usr/bin/env python3
"""Quorums y comparación de version vectors."""
from itertools import combinations


def intersect_all(n: int, r: int, w: int) -> bool:
    nodes = range(n)
    reads = list(combinations(nodes, r))
    writes = list(combinations(nodes, w))
    return all(set(a) & set(b) for a in reads for b in writes)

for n, r, w in [(5,3,3), (5,1,5), (5,5,1), (3,1,1)]:
    print(f"N={n}, R={r}, W={w}: R+W>N={r+w>n}, intersección={intersect_all(n,r,w)}")


def compare(a: dict[str,int], b: dict[str,int]) -> str:
    keys = set(a) | set(b)
    a_ge = all(a.get(k,0) >= b.get(k,0) for k in keys)
    b_ge = all(b.get(k,0) >= a.get(k,0) for k in keys)
    if a_ge and a != b:
        return "a domina b"
    if b_ge and a != b:
        return "b domina a"
    if a == b:
        return "iguales"
    return "concurrentes"

v1={"A":2,"B":1}; v2={"A":2,"B":3}; v3={"A":4,"B":1}
for name_a,a,name_b,b in [("v1",v1,"v2",v2),("v1",v1,"v3",v3),("v2",v2,"v3",v3)]:
    print(f"{name_a} vs {name_b}: {compare(a,b)}")
